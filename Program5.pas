uses calcDelta;
var
  a,da,r,dr:real;
  v: VarT;
  s:string;
  
  resArr: array of ResultT;
begin
  readln(formula);
  readln(a,da);
//{  
  v.name:='a';
  v.valueCount:=1;
  v.valueList[1]:=a;
  v.delta:=da;
  varDict.Add(v.name,v);
  resultCount:=1;
  calculate();
  r:=resultList[1].value;
  dr:=resultList[1].delta;
  r.ToS
//}
{
  addVar( 'a', a, da);
//  addVarValue( 'a', 10);  
//  addVarValue( 'a', 15);  
  resArr := calculate( formula);
  r := resArr[0].value;
  dr := resArr[0].delta;
}  
  
  writeln('r:',r,'; dr:',dr);
end.