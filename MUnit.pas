Unit MUnit;

interface

uses System, System.Drawing, System.Windows.Forms;

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
    formula: TextBox;
    label5: &Label;
    label6: &Label;
    calcBtn: Button;
    cleanBtn: Button;
    result: RichTextBox;
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

end.
