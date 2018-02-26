uses System.Collections.Generic;

const

  /// Признак вывода отладочных сообщений  
  isDebug:boolean =
  // true;
 false;

type

  // Переменная (тип)
  VarT = record
    name:string;
    valueList:array [1..100] of real;
    valueCount:integer:=0;
    delta:real;
  end;
  
  // Результат (тип)
  ResultT = record
    resValue:real;
    resDelta:real;
  end;
  
  /// Тип элемента формулы (тип)
  FormulaItemTypeT = ( 
    // число
    Num_FIT
    // операция
    , Op_FIT
    // переменная
    , Var_FIT
    // функция
    , Func_FIT
  );
  
  /// Элемент формулы
  FormulaItemT = record
    itemType: FormulaItemTypeT;
    name: string;
    value: real;
  end;
  
  /// Список элементов формулы
  FormulaItemsT = List<FormulaItemT>;

const

  /// Символы операций, используемых в формулах
  Operator_Chars: string = '+-*/^()';
 
var

  // Словарь переменных
  varDict := new Dictionary<string,VarT>;
  
  // Функции для использования в формуле
  funcDict := new Dictionary< string, real->real >;
  
  // Формула
  formula:string;
  
  // Массив и число результатов
  resultList:array [1..100] of ResultT;
  resultCount:integer:=0;

  // Точность    
  precision:integer:=0;
    
// Выход с сообщением об ошибке
procedure exitError(errorText:string);
begin
  writeln(errorText);
  halt(10);
end;
  
procedure debug( msg: string);
begin
  if isDebug then
    writeln('DBG: ' + msg);
end;

/// Инициализация глобальных переменных
procedure initialize();
begin
  // Функции для использования в формуле
  funcDict[ 'sqrt'] := sqrt;
end;

// Перевод строки в число
function toReal(s:string):real;
var
  i:integer;
begin
  for i:=1 to length(s) do
    if s[i]=',' then
      begin
      delete(s,i,1);
      insert('.',s,i);
      end;
  toReal:=s.ToReal;
end;

// Точность результата
function getPrecision(s:string):integer;
var
  i:integer;
begin
    for i:=1 to length(s) do
      if s[i]=',' then
        begin
        delete(s,i,1);
        insert('.',s,i);
        end;
  getPrecision:=length(s)-pos('.',s);
end;

// Разбирает строку с переменной
procedure parseVarLine( var resultCountName:string;s: string;nLine:integer);
var
  v: VarT;
  i:integer;
  maxPr:integer;
begin
  var p:=pos('=',s,1);
  v.name:=copy(s,1,p-1);
  delete(s,1,p);
  var w:=s.ToWords;
  try
    v.delta:=toReal(w[1]);
    v.valueList[1]:=toReal(w[0]);
    v.valueCount:=w.Length-1;
    for i:=2 to w.Length-1 do
      v.valueList[i]:=toReal(w[i]);
  except
    on System.FormatException do
      exitError('Incorrect value of variable "'+v.name+'"');
  end;
  if varDict.ContainsKey(v.name) then  
    exitError('Duplicate variable name "'+v.name+'" in string '+nLine)
  else
    varDict.Add( v.name, v);
  if (v.valueCount>1)and(resultCount>1)and(resultCount<>v.valueCount) then
    exitError('Inconsistent number of variable values (variables "'+v.name+'" and "'+resultCountName+'")')
  else if resultCount<v.valueCount then
    begin
    resultCount:=v.valueCount;
    resultCountName:=v.name;
    end;
  for i:=0 to w.Length-1 do
    if maxPr<getPrecision(w[i])then
      maxPr:=getPrecision(w[i]);
  if precision<maxPr then
    precision:=maxPr;
  debug('v.name: '+v.name+', delta:'+v.delta+' ;'); 
end;

// Ввод исходных данных из файла
procedure inputData();
var
  input:text;
  s:string;
  nLine:integer:=0;
  resultCountName:string;
begin
  assign(input,'input.txt');
  reset(input);
  while not eof(input) do
    begin
    nLine+=1;
    readln(input,s);
    if pos('=',s,1)<>0 then
      parseVarLine(resultCountName,s,nLine)
    else
      formula:=s;
    end;
  close(input);
  if formula='' then
    exitError('Formula not specified');
end;

// Выводит результат
procedure outputResult();
begin
  for var i:=1 to resultCount do
    writeln(resultList[i].resValue:0:precision,'+-',resultList[i].resDelta:0:precision);
end;

// Добавляет новый элемент при разборе строки с формулой
procedure addFormulaItem( fi: FormulaItemsT; itemStr: string; itemType: FormulaItemTypeT; startPos: integer);
var
  item: FormulaItemT;
begin
  item.itemType:=itemType;
  if itemType = Num_FIT then
    item.value:=itemStr.ToReal
  else 
    item.name:=itemStr;
  if (itemType = Op_FIT) and (item.name in [string('+'),string('-')])
      and (
        (fi.Count=0)
        or (fi.Last.itemType = Op_FIT) and (fi.Last.name <> ')')
      )
      then
    begin
    item.name+='U';
    end;
  // проверка корректности
  if (itemType = Func_FIT) and (not funcDict.ContainsKey(item.name)) then
    exitError('Unknown function: ' + item.name);
  if (itemType = Var_FIT) and (not varDict.ContainsKey(item.name)) then
    exitError('Variable "' + item.name + '" not specified');
    
  // добавление элемента
  fi.Add(item);
end;

// Возвращает элементы формулы (в порядке вхождения в формулу)
function parseFormula(s: string): FormulaItemsT;
var

  // Элементы формулы
  fi := new FormulaItemsT;
  
  // Позиция первого символа элемента (0 если нет элемента)
  iFirst: integer := 0;
  
  // Позиция последнего символа элемента (0 если последний
  // символ не определен)
  iLast: integer := 0;
  
  // Тип текущего элемента формулы
  itemType: FormulaItemTypeT;
  
  // Текущий уровень вложенности скобок
  prnLevel:integer:=0;

begin
  debug( 'formula: "' + s + '"');
  
  // Последняя итерация цикла выполняется "за концом строки"
  for var i:=1 to s.Length + 1 do
    begin
    var isCh := i <= s.Length;
    var ch := isCh ? s[i] : '0';
    if char.IsWhiteSpace(ch) then
      begin
      if (iFirst > 0) and (iLast=0) then
        iLast := i - 1;
      end
    else
      begin
      var isOperator := pos(ch, Operator_Chars) > 0;
      if (iFirst > 0) and ((iLast > 0) or not isCh or isOperator) then
        begin
        // добавление текущего элемента
        if iLast = 0 then iLast := i - 1;
        if (itemType = Var_FIT) and ( ch = '(') then
          itemType := Func_FIT;
        addFormulaItem( fi, copy(s, iFirst, iLast-iFirst+1), itemType, iFirst);
        iFirst := 0;
        end;
      if isCh and (iFirst = 0) then
        begin
        // начинаем новый элемент 
        iFirst := i;
        if isOperator then
          begin
          itemType := Op_FIT;
          iLast := i;
          if ch = '(' then
            prnLevel+=1
          else if ch = ')' then
            prnLevel-=1;
          end
        else
          begin
          itemType := char.IsDigit(ch) ? Num_FIT : Var_FIT;
          iLast := 0;
          end;
        end;
      end;
    if (prnLevel<0) or (not isCh and (prnLevel<>0)) then
      exitError('Number of opening parenthesis is not equal to number of closing parenthesis');
    end;
  parseFormula := fi;
  if isDebug then
    writeln('DBG: parseFormula: result: ', fi);
end;

/// Возвращает приоритет оператора 
function getPriority(op:string):integer;
begin
  case op of
    string('('), string(')'): getPriority:=0;
    string('+'), string('-'): getPriority:=1;
    string('*'), string('/'): getPriority:=2;
    string('^'): getPriority:=3;
    '+U','-U': getPriority:=4;
    else getPriority:=5;
  end;
end;

/// Возвращает истину если оператор левоассоциативный
function isLeftAssociativity(op:string):boolean;
begin
  isLeftAssociativity := not (op in ['+U','-U',string('^')]);
end;

// Возвращает элементы формулы в обратной польской нотации
function toRpn( inItems: FormulaItemsT): FormulaItemsT;
var
  outItems := new FormulaItemsT;
  st := new Stack<FormulaItemT>;
  ist:FormulaItemT;
begin
  foreach var item in inItems do
    begin
    if item.itemType in [Num_FIT, Var_FIT] then
      outItems+=item
    else if item.itemType = Func_FIT then
      st.Push(item)
    else if item.name='(' then
       st.Push(item)
    else if item.name=')' then
      begin
      while (st.Count>0) and (st.Peek().name <>'(') do
        outItems+=st.Pop();
      st.Pop();
      end
    else if item.itemType = Op_FIT then
      begin
      while (st.Count>0) and (
            isLeftAssociativity(item.name)
              and (getPriority(item.name)<=getPriority(st.Peek().name))
            or not isLeftAssociativity(item.name)
              and (getPriority(item.name)<getPriority(st.Peek().name))
          ) do
        outItems+=st.Pop();
      st.Push(item);
      end;
    end;
  while st.Count > 0 do
    outItems+=st.Pop();
  toRpn := outItems;
  if isDebug then
    writeln('DBG: toPrn: result: ', outItems);
end;

// Возвращает результат i-того вычисления формулы
procedure calculateFormula(
  var resValue:real;
  var resDelta:real;
  rpnFi: FormulaItemsT;
  iResult:integer
);
var
  st := new Stack<real>;
begin
  foreach var item in rpnFi do
    begin
    if isDebug then
      writeln('DBG: calculateFormula: item:',item);
    if item.itemType = Num_FIT then
      st.Push(item.value)
    else if item.itemType = Var_FIT then
      st.Push(
        varDict[item.name].valueList[
          min(iResult,varDict[item.name].valueCount)
        ] 
      )
    else if item.itemType = Op_FIT then
      begin
      var b:real;
      if not(item.name in ['+U','-U']) then 
        b:=st.Pop();
      var a:=st.Pop();
      case item.name of
        string('+'): st.Push(a+b);
        string('-'): st.Push(a-b);
        string('*'): st.Push(a*b);
        string('/'): st.Push(a/b);
        string('^'): st.Push(power(a,b));
        '+U': st.Push(+a);
        '-U': st.Push(-a);
      else exitError('unknown operator'+item.name);
      end;
      end
    else if item.itemType = Func_FIT then
      st.Push(funcDict[item.name](st.Pop()))
    else exitError('unknown itemType for: '+item.name);
    if isDebug then
      writeln('DBG: calculateFormula: st:',st);
    end;
  resValue:=st.Pop();
  
  if varDict.ContainsKey(formula) then
    resDelta:=varDict[formula].delta;    
end;

// Вычисляет результат
procedure calculate();
var

  // Элементы формулы в обратной польской нотации  
  rpnFi: FormulaItemsT;

begin
  rpnFi := toRpn( parseFormula( formula));
  for var i:=1 to resultCount do
    calculateFormula(resultList[i].resValue,resultList[i].resDelta,rpnFi,i);
end;

begin
  try
    initialize();
    inputData();
    calculate();
    outputResult();
  except on e: Exception do
    begin
      System.Console.Error.WriteLine( e.ToString());
      halt(13);
    end;
  end;
end.
