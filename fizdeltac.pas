
uses calcDelta;

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
  debug('v.name: '+v.name+', delta:'+v.delta+', precision:'+precision);
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
    writeln(resultList[i].value:0:precision,'+-',resultList[i].delta:0:precision);
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
