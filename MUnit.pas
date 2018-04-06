Unit MUnit;
interface

uses System, System.Drawing, System.Windows.Forms;
uses calcDelta;

type
  MForm = class(Form)
    procedure textBox1_TextChanged(sender: Object; e: EventArgs);
    procedure label1_Click(sender: Object; e: EventArgs);
    procedure label2_Click(sender: Object; e: EventArgs);
    procedure label3_Click(sender: Object; e: EventArgs);
    procedure textBox2_TextChanged(sender: Object; e: EventArgs);
    procedure label4_Click(sender: Object; e: EventArgs);
    procedure label6_Click(sender: Object; e: EventArgs);
    procedure label5_Click(sender: Object; e: EventArgs);
    procedure MForm_Load(sender: Object; e: EventArgs);
    procedure calcBtn_Click(sender: Object; e: EventArgs);
    procedure formula_TextChanged(sender: Object; e: EventArgs);
    procedure addVar(var resultCountName:string;name,value,delta:string);
    procedure cleanBtn_Click(sender: Object; e: EventArgs);
    procedure autoTest_Click(sender: Object; e: EventArgs);
procedure checkCase(
  var caseCount: integer;
  var failCount: integer;
  var failText: string;
  caseName: string;
  isOkResult: boolean;
  outStr: string;
  formulaText: string:= '';
  vName1: string:= ''; vValue1: string:= ''; vDelta1: string:= '';
  vName2: string:= ''; vValue2: string:= ''; vDelta2: string:= '';
  vName3: string:= ''; vValue3: string:= ''; vDelta3: string:= '';
  vName4: string:= ''; vValue4: string:= ''; vDelta4: string:= '';
  vName5: string:= ''; vValue5: string:= ''; vDelta5: string:= '';
  vName6: string:= ''; vValue6: string:= ''; vDelta6: string:= '';
  vName7: string:= ''; vValue7: string:= ''; vDelta7: string:= '';
  vName8: string:= ''; vValue8: string:= ''; vDelta8: string:= '' 
);
  {$region FormDesigner}
  private
    {$resource MUnit.MForm.resources}
    value1: TextBox;
    delta1: TextBox;
    delta2: TextBox;
    value2: TextBox;
    name2: TextBox;
    label1: &Label;
    label2: &Label;
    label3: &Label;
    delta4: TextBox;
    value4: TextBox;
    name4: TextBox;
    delta3: TextBox;
    value3: TextBox;
    name3: TextBox;
    delta8: TextBox;
    value8: TextBox;
    name8: TextBox;
    delta7: TextBox;
    value7: TextBox;
    name7: TextBox;
    delta6: TextBox;
    value6: TextBox;
    name6: TextBox;
    delta5: TextBox;
    value5: TextBox;
    name5: TextBox;
    label4: &Label;
    formulaBox: TextBox;
    label5: &Label;
    label6: &Label;
    calcBtn: Button;
    cleanBtn: Button;
    resultBox: RichTextBox;
    autoTest: Button;
    name1: TextBox;
    {$include MUnit.MForm.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  end;

implementation
uses calcDelta;

const

  // Префикс для текста ошибок
  Error_Prefix: string = 'Error: ';

  // Конец строки
  EOL: string = chr(13) + chr(10);

procedure MForm.textBox1_TextChanged(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.label1_Click(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.label2_Click(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.label3_Click(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.textBox2_TextChanged(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.label4_Click(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.label6_Click(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.label5_Click(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.MForm_Load(sender: Object; e: EventArgs);
begin
  
end;

/// добавляет переменные в словарь для расчёта формулы
procedure MForm.addVar(var resultCountName:string;name,value,delta:string);
var
  v: VarT;
  i:integer;
begin
  v.name:=name; 
  var w:=value.ToWords(';');
  v.valueCount:=w.Length;
  try
    for i:=1 to v.valueCount do
      v.valueList[i]:=toReal(w[i-1]);
    v.delta:=toReal(delta);
  except
    on System.FormatException do
      exitError('Incorrect value of variable "'+v.name+'"');
  end;
  for i:=0 to w.Length-1 do
    if precision<getPrecision(w[i])then
      precision:=getPrecision(w[i]); 
    if precision<getPrecision(delta) then
      precision:=getPrecision(delta);
  if (v.valueCount>1)and(resultCount>1)and(resultCount<>v.valueCount) then
    exitError('Inconsistent number of variable values (variables "'+v.name+'" and "'+resultCountName+'")')
  else
    if resultCount<v.valueCount then
      begin
      resultCount:=v.valueCount;
      resultCountName:=v.name;
      end;
  if varDict.ContainsKey(v.name) then
    exitError('Duplicate variable name "'+v.name+'"');
  varDict.Add(v.name,v);
end;

procedure MForm.calcBtn_Click(sender: Object; e: EventArgs);
var

  a,da,r,dr:real;
  v: VarT;
  s:string;
  i:integer;
  resArr: array of ResultT;
  resultCountName:string;
begin
  try
  varDict.Clear;
  resultCount:=0;
  precision:=0;
  formula:=formulaBox.Text;
  if formula='' then
    exitError('Formula not specified');
  addVar(resultCountName,name1.Text,value1.Text,delta1.Text);
  if name2.Text<>'' then
    addVar(resultCountName,name2.Text,value2.Text,delta2.Text);
  if name3.Text<>'' then
    addVar(resultCountName,name3.Text,value3.Text,delta3.Text);
  if name4.Text<>'' then
    addVar(resultCountName,name4.Text,value4.Text,delta4.Text);
  if name5.Text<>'' then
    addVar(resultCountName,name5.Text,value5.Text,delta5.Text);
  if name6.Text<>'' then
    addVar(resultCountName,name6.Text,value6.Text,delta6.Text);
  if name7.Text<>'' then
    addVar(resultCountName,name7.Text,value7.Text,delta7.Text);
  if name8.Text<>'' then
    addVar(resultCountName,name8.Text,value8.Text,delta8.Text);
  calculate();
  resultBox.Clear;
  for i:=1 to resultCount do
    begin
    r:=resultList[i].value;
    dr:=resultList[i].delta;
    resultBox.AppendText(
      (i>1? EOL :'')
      + (r.ToString( 'N' + precision.ToString)).Replace(',','.')
      + '+-'
      + (dr.ToString( 'N' + precision.ToString)).Replace(',','.')
    );
    end;

  except
    on ex: CalcDeltaException do
      resultBox.Text := Error_Prefix + ex.Message;
    on ex: Exception do
      resultBox.Text := Error_Prefix + ex.ToString();
  end;  
end;

procedure MForm.formula_TextChanged(sender: Object; e: EventArgs);
begin
  
end;

procedure MForm.cleanBtn_Click(sender: Object; e: EventArgs);
begin
  name1.Clear;
  name2.Clear;
  name3.Clear;
  name4.Clear;
  name5.Clear;
  name6.Clear;
  name7.Clear;
  name8.Clear;
  value1.Clear;
  value2.Clear;
  value3.Clear;
  value4.Clear;
  value5.Clear;
  value6.Clear;
  value7.Clear;
  value8.Clear;
  delta1.Clear;
  delta2.Clear;
  delta3.Clear;
  delta4.Clear;
  delta5.Clear;
  delta6.Clear;
  delta7.Clear;
  delta8.Clear;
  formulaBox.Clear;
  resultBox.Clear;
end;

procedure MForm.checkCase(
  var caseCount: integer;
  var failCount: integer;
  var failText: string;
  caseName: string;
  isOkResult: boolean;
  outStr: string;
  formulaText: string;
  vName1: string; vValue1: string; vDelta1: string;
  vName2: string; vValue2: string; vDelta2: string;
  vName3: string; vValue3: string; vDelta3: string;
  vName4: string; vValue4: string; vDelta4: string;
  vName5: string; vValue5: string; vDelta5: string;
  vName6: string; vValue6: string; vDelta6: string;
  vName7: string; vValue7: string; vDelta7: string;
  vName8: string; vValue8: string; vDelta8: string
);
var
  isOk: boolean;
  isResultDiff:boolean;
  isTextDiff:boolean;
begin
  if (failCount > 0) then exit;
  caseCount += 1;
  formulaBox.Text := formulaText;
  name1.Text := vName1; value1.Text := vValue1; delta1.Text := vDelta1;
  name2.Text := vName2; value2.Text := vValue2; delta2.Text := vDelta2;
  name3.Text := vName3; value3.Text := vValue3; delta3.Text := vDelta3;
  name4.Text := vName4; value4.Text := vValue4; delta4.Text := vDelta4;
  name5.Text := vName5; value5.Text := vValue5; delta5.Text := vDelta5;
  name6.Text := vName6; value6.Text := vValue6; delta6.Text := vDelta6;
  name7.Text := vName7; value7.Text := vValue7; delta7.Text := vDelta7;
  name8.Text := vName8; value8.Text := vValue8; delta8.Text := vDelta8;
  calcBtn_Click( nil, nil);
  isOk := not resultBox.Text.StartsWith( Error_Prefix);
  isResultDiff:= isOkResult <> isOk;
  var factualText := resultBox.Text;
  var expectedText := ( not isOk ? Error_Prefix : '') + outStr.Replace( chr(13), '');
  isTextDiff := expectedText <> factualText;
  if isResultDiff or isTextDiff then
    begin
    failCount+=1;
    failText += '*** CASE ' + caseCount + ': ' + caseName + EOL;
    end;
  if isResultDiff then
    failText +=
      'Unexpected result:' + EOL
      + ( isOk ? 'SUCCESS instead of ERROR' : 'ERROR instead of SUCCESS') + EOL
    ;
  var fb := Encoding.Default.GetBytes( factualText);
  var fHex := BitConverter.ToString(fb);    
  var eb := Encoding.Default.GetBytes( expectedText);
  var eHex := BitConverter.ToString(eb);    
  if isTextDiff then
    failText +=
      'Unexpected output:' + EOL
      + EOL + 'factual (len=' + factualText + '):' + EOL
      + factualText + EOL
      + 'xx:' + fHex + EOL
      + EOL + 'expected (len=' + expectedText.Length + '):' + EOL
      + expectedText + EOL
      + 'xx:' + eHex + EOL
    ;
end;


procedure MForm.autoTest_Click(sender: Object; e: EventArgs);
var
  caseCount:integer := 0;
  failCount:integer:=0;
  failText:string;
begin
  checkCase(
    caseCount, failCount, failText
    , 'Formula not specified'
    , false
    , 'Formula not specified'
    , ''
    , 'x', '0.22', '0.195'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Duplicate variable name'
    , false
    , 'Duplicate variable name "b"'
    , 'a+b'
    , 'a', '0.21', '0.014'
    , 'b', '0.15', '0.123'
    , 'b', '0.67', '0.125'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Invalid number of variable values'
    , false
    , 'Inconsistent number of variable values (variables "s" and "u")'
    , 'u'
    , 'u', '0.22;0.43', '0.0194'
    , 'g', '10', '0'
    , 's', '0.045;0.065;0.107;0.110', '0.001'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Incorrect value of variable'
    , false
    , 'Incorrect value of variable "b"'
    , 'b'
    , 'a', '0.211', '0.014'
    , 'b', '0.15y', '0.123'
    , 'c', '0.671', '0.125'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Unknown variable'
    , false
    , 'Variable "b" not specified'
    , 'b+a'
    , 'a', '3.0', '0.0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Unknown function'
    , false
    , 'Unknown function: ggh'
    , 'ggh(a)'
    , 'a', '3.0', '0.0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Unbalanced parenthesis'
    , false
    , 'Number of opening parenthesis is not equal to number of closing parenthesis'
    , '(a+1))'
    , 'a', '3.0', '0.0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Trivial formula'
    , true
    , '0.151+-0.123'
    , 'b'
    , 'a', '0.211', '0.014'
    , 'b', '0.151', '0.123'
    , 'c', '0.671', '0.125'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Comma as decimal separator'
    , true
    , '0.151+-0.123'
    , 'b'
    , 'a', '0,211', '0,014'
    , 'b', '0.151', '0,123'
    , 'c', '0.671', '0.125'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Arithmetic formula'
    , true
    , '3.5+-0.0'
    , '3 + 4 * 2 / (1 - 5)^2'
    , 'a', '0.1', '0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Formula with power'
    , true
    , '256.0+-0.0'
    , '2^2^3'
    , 'a', '0.1', '0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Formula with root'
    , true
    , '3.0+-0.0'
    , 'sqrt(a+b)'
    , 'a', '3.0', '0'
    , 'b', '6.0', '0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Unary operations'
    , true
    , '-2+-0'
    , '-1*(-4+6)'
    , 'a', '3', '0'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Root of the product'
    , true
    , '0.4450+-0.0246'+EOL+'0.5348+-0.0277'+EOL+'0.6861+-0.0335'+EOL+'0.6957+-0.0338'
    , 'sqrt(2*u*g*s)'
    , 'u', '0.22', '0.0194'
    , 'g', '10', '0'
    , 's', '0.045;0.065;0.107;0.110', '0.001'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Square division'
    , true
    , '0.530+-0.266'
    , '2*s/t^2'
    , 's', '1.060', '0.001'
    , 't', '2', '0.5'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Precision 1'
    , true
    , '0.150+-0.123'
    , 'b'
    , 'a', '0.211', '0.014'
    , 'b', '0.15', '0.123'
    , 'c', '0.671', '0.125'
  );
  checkCase(
    caseCount, failCount, failText
    , 'Precision 2'
    , true
    , '322.7+-1.5'
    , 'p/T'
    , 'p', '98736', '136.0'
    , 'T', '306', '1'
  );
 
  
  resultBox.Text :=
    ( failCount > 0 ? 'FAILED' : 'OK') 
    + ' ( case checked: ' + caseCount + ', failed:' + failCount + ')'
    + EOL + failText
  ;
end;

end.
