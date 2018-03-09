Unit MUnit;

interface

uses System, System.Drawing, System.Windows.Forms;

type
  MForm = class(Form)
  {$region FormDesigner}
  private
    {$resource MUnit.MForm.resources}
    {$include MUnit.MForm.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  end;

implementation

end.
