uses System.Diagnostics;

var
  configPath: string := 'Test\autotest.cfg';
  inPath: string := 'input.txt';
  runPath: string := 'fizdeltac.exe';
  caseCount: integer := 0;
  isDebug: boolean := 
//    true
    false
  ;
  isExitAfterDiff: boolean :=
    true
//    false
  ;
  failcount:integer:=0;
  
  type StringArrayT = array [1..100] of String;

procedure debug( msg: string);
begin
  if isDebug then
    writeln(msg);
end;
 
procedure exitError(errorText:string);
begin
  writeln(errorText);
  halt(10);
end;

procedure execProgram( var exitCode: integer; var outStr:StringArrayT; var nOutStr:integer);
begin
  var p := new Process();
  p.StartInfo.FileName := runPath;
  p.StartInfo.Arguments := '';
  p.StartInfo.WindowStyle := ProcessWindowStyle.Hidden;
  // нужно для перенаправления потоков
  p.StartInfo.UseShellExecute := false;
  p.StartInfo.RedirectStandardError:=true;
  p.StartInfo.RedirectStandardOutput := true;
  p.Start();
  p.WaitForExit();
  exitCode := p.ExitCode;
  debug('exitCode: ' + exitCode);
  nOutStr := 0;
  var erout := p.StandardError;
  while erout.Peek() >= 0 do
    begin
    nOutStr += 1;
    outStr[nOutStr] := erout.ReadLine();
    debug('sout: ' + nOutStr + ': [' + outStr[nOutStr] + ']');
    end;
  var sout := p.StandardOutput;
  while sout.Peek() >= 0 do
    begin
    nOutStr += 1;
    outStr[nOutStr] := sout.ReadLine();
    debug('sout: ' + nOutStr + ': [' + outStr[nOutStr] + ']');
    end;
  p.Close();
end;
 
procedure processConfig();
var

  // '-' - нет тестового случая
  // 'I' - ожидаем строки ввода
  // 'R' - ожидаем строки результата
  state:char:='-';
  
  // метка текущей строки
  // возможные значения: "CASE", "OK", "ERROR"
  // "" если в текущей строке нет метки
  mark:string;
  caseName:string;
  caseLine:integer;
  cfg:text;
  s:string;
  nLine:integer:=0;
  input:text;
  isOkResult:boolean;
  outStr:array[1..100]of string;
  nOutStr:integer:=0;
  
  procedure setMark;
  begin
    if copy(s,1,5)='CASE ' then
      mark:='CASE'
    else if s='ERROR:' then
      mark:='ERROR'
    else if s='OK:' then
      mark:='OK'
    else
      mark:='';
  end;
  
  procedure newCase();
  begin
    nOutStr:=0;
    rewrite(input);
    caseName:=copy(s,6,length(s)-4);
    caseLine:=nLine;
//    debug('caseName: [' + caseName + ']');
    state:='I';
  end;
  
  procedure checkCase();
  var
  
    exitCode:integer;
    execOutStr: StringArrayT;
    nExecOutStr:integer;
    isResultDiff:boolean;
    isTextDiff:boolean;
    i:integer;
    
  begin
    close(input);
    caseCount+=1;
    debug('checkCase: ' + caseName);
    execProgram( exitCode, execOutStr, nExecOutStr);
    isResultDiff:=
      isOkResult and (exitCode<>0)
      or not isOkResult and (exitCode=0)
    ;
    isTextDiff := nOutStr <> nExecOutStr;
    if not isTextDiff then
      for i:=1 to nOutStr do
        if execOutStr[i]<>outStr[i] then
          begin
          isTextDiff:=true;
          break;
          end;
    if isResultDiff or isTextDiff then
      begin
      failcount+=1;
      writeln('*** CASE ',caseCount,': ',caseName,' (line ',caseLine,')');
      end;
   if isResultDiff then
      begin
      writeln('Unexpected result:');
      if exitCode=0 then
        writeln('SUCCESS instead of ERROR ')
      else
        writeln('ERROR instead of SUCCESS')
      end;
    if isTextDiff then
      begin
      writeln('Unexpected output:');
      writeln('factual:');
      for i:=1 to nExecOutStr do
        writeln(execOutStr[i]);
      writeln('expected:');
      for i:=1 to nOutStr do
        writeln(OutStr[i]);
      end;
    if isExitAfterDiff and (isTextDiff or isResultDiff) then
      halt();
  end;
  
begin
  assign(cfg,configPath);
  reset(cfg);
  assign(input,'input.txt');
  while not eof(cfg) do
    begin
    readln(cfg,s);
    nLine+=1;
    if (s='') or (s[1]='#') then  continue;
//    debug('cfg '+nLine+': ' + state + ': ' + s);
    setMark();
    case state of
      '-':
        if mark='CASE' then
          newCase()
        else
          exitError('line #'+ nLine +': unexpected string instead of "CASE <caseName>"');
      'I':
        if (mark='OK') or (mark='ERROR')then
          begin
          state:='R';
          isOkResult:= mark='OK';
          end
        else if mark='CASE' then
          exitError('line #'+ nLine +': unexpected string CASE ')
        else
          writeln(input,s);
      'R':
        begin
        if mark='CASE'then
          begin
          checkCase();
          newCase();
          end
        else if (mark='ERROR')  or (mark='OK') then
          exitError('line #'+ nLine +': unexpected string')
        else
          begin
          nOutStr+=1;
          outStr[nOutStr]:=s;
          end;
       end;
    end;
    end;
  if state='R' then
    checkCase()
  else if state<>'-' then
    exitError('The description of the last test case is incomplete');
end;

 
begin
  processConfig();
  writeln('OK ( case checked: ',caseCount,')',' failed:' ,failcount);

end.
