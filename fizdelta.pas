uses System.Collections.Generic;

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
  
var

  // Словарь переменных
  varDict := new Dictionary<string,VarT>;
  
  // Формула
  formula:string;
  
  // Массив и число результатов
  resultList:array [1..100] of ResultT;
  resultCount:integer:=0;
  
  isDebug:boolean:=
//    true;
    false;
    
// Выход с сообщением об ошибке
procedure exitError(errorText:string);
begin
  writeln(errorText);
  halt(10);
end;
  
procedure debug( msg: string);
begin
  if isDebug then
    writeln(msg);
end;

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

// Разбирает строку с переменной
procedure parseVarLine( var resultCountName:string;s: string;nLine:integer);
var
  v: VarT;
  i:integer;
begin
  var p:=pos('=',s,1);
  v.name:=copy(s,1,p-1);
  delete(s,1,p);
  var w:=s.ToWords;
  v.delta:=toReal(w[1]);
  v.valueList[1]:=toReal(w[0]);
  v.valueCount:=w.Length-1;
  for i:=2 to w.Length-1 do
    v.valueList[i]:=toReal(w[i]);
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
    writeln(resultList[i].resValue,'+-',resultList[i].resDelta);
end;

// Возвращает результат i-того вычисления формулы
procedure calculateFormula(var resValue:real; var resDelta:real; iResult:integer);
begin
  if varDict.ContainsKey(formula) then
    begin
    resValue:=varDict[formula].valueList[
      min(iResult,varDict[formula].valueCount)
    ];
    resDelta:=varDict[formula].delta;
    end;
end;

// Вычисляет результат
procedure calculate();
begin
  for var i:=1 to resultCount do
    calculateFormula(resultList[i].resValue,resultList[i].resDelta,i);
end;

begin
  try
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
