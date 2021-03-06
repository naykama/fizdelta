﻿unit calcDelta;
interface

uses System.Collections.Generic;
  
const
  /// Признак вывода отладочных сообщений
  isDebug:boolean =
 //true;
 false;  
 
type
  
  // Исключения при вычислении
  CalcDeltaException = class(Exception) end;

  // Переменная (тип)
  VarT = record
    name:string;
    valueList:array [1..100] of real;
    valueCount:integer:=0;
    delta:real;
  end;
 
  // Результат (тип)
  ResultT = record
    value:real;
    delta:real;

    constructor Create(value: real; delta: real);
    begin
      Self.value := value;
      Self.delta := delta;
    end;
  end;
  

var
  // Словарь переменных
  varDict := new Dictionary<string,VarT>;

  // Формула
  formula:string;

  // Массив и число результатов
  resultList:array [1..100] of ResultT;
  resultCount:integer:=0;

  // Точность
  precision:integer:=0;
  
// Выход с сообщением об ошибке
procedure exitError(errorText:string);

// Перевод строки в число
function toReal(s:string):real;

// Точность результата
function getPrecision(s:string):integer;

procedure debug( msg: string);

// Вычисляет результат
procedure calculate();

//
// Реализация
//
implementation
type
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
    // для функции и переменных
    name: string;
    // для чисел
    value: real;
  end;

  /// Список элементов формулы
  FormulaItemsT = List<FormulaItemT>;

const
  /// Символы операций, используемых в формулах
  Operator_Chars: string = '+-*/^()';

procedure debug( msg: string);
begin
  if isDebug then
    writeln('DBG: ' + msg);
end;

// Выход с сообщением об ошибке
procedure exitError(errorText:string);
begin
  raise new CalcDeltaException(errorText);
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
  s:=s.Replace(',','.');
  i:=pos('.',s);
  getPrecision := i = 0 ? 0 : length(s)-i;
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
  if (itemType = Op_FIT) and (
        ( item.name = string('+'))
        or ( item.name = string('-'))
      )
      and (
        (fi.Count=0)
        or (fi.Last.itemType = Op_FIT) and (fi.Last.name <> ')')
      )
      then
    begin
    item.name+='U';
    end;
  // проверка корректности
  if (itemType = Func_FIT) and (item.name<>'sqrt') then
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
  isLeftAssociativity :=
    (op<>string('^')) and (op<>'+U') and (op<>'-U')
  ;
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
    writeln('DBG: toRpn: result: ', outItems);
end;

// Возвращает результат i-того вычисления формулы
procedure calculateFormula(
  var res:ResultT;
  rpnFi: FormulaItemsT;
  iResult:integer
);
var
  st := new Stack<ResultT>;
  a: ResultT;
begin
  foreach var item in rpnFi do
    begin
    if isDebug then
      writeln('DBG: calculateFormula: item:',item);
    if item.itemType = Num_FIT then
//     st.Push(item.value)
      st.Push(new ResultT(item.value,0))
    else if item.itemType = Var_FIT then
      st.Push(
        new ResultT(
          varDict[item.name].valueList[
            min(iResult,varDict[item.name].valueCount)
          ]
          ,varDict[item.name].delta
        )
      )
    else if item.itemType = Op_FIT then
      begin
      var b:ResultT;
      if not(item.name in ['+U','-U']) then
        b:=st.Pop();
      if st.Count>0 then
        a:=st.Pop()
      else
        ExitError('Unexpected completion of formula');
      case item.name of
        string('+'):
          st.Push(new ResultT(
            a.value+b.value
            , a.delta+b.delta
          ));
        string('-'):
          st.Push(new ResultT(
            a.value-b.value
            , a.delta+b.delta
          ));
        string('*'):
          st.Push(new ResultT(
            a.value*b.value
            , a.value*b.delta+b.value*a.delta
          ));
        string('/'):
          st.Push(new ResultT(
            a.value/b.value
            , (a.value*b.delta+b.value*a.delta)/sqr(b.value)
          ));
        string('^'):
          st.Push(new ResultT(
            power(a.value,b.value)
            , b.value*power(a.value,b.value-1)*a.delta
          ));
        '+U': st.Push(a);
        '-U': st.Push(new ResultT(-a.value,-a.delta));
      else exitError('unknown operator: "'+item.name+'"');
      end;
      end
    else if item.itemType = Func_FIT then
      begin
        a:=st.Pop();
      case item.name of
        'sqrt':
          st.Push(new ResultT(
            sqrt(a.value)
            , a.delta/(2*sqrt(a.value))
          ));
      else exitError('unknown function: "'+item.name+'"');
      end;
      end
    else exitError('unknown itemType for: '+item.name);
    if isDebug then
      writeln('DBG: calculateFormula: st:',st);
    end;
  res:=st.Pop();
end;

// Вычисляет результат
procedure calculate();
var

  // Элементы формулы в обратной польской нотации
  rpnFi: FormulaItemsT;

begin
  rpnFi := toRpn( parseFormula( formula));
  for var i:=1 to resultCount do
    calculateFormula(resultList[i],rpnFi,i);
end;
end.