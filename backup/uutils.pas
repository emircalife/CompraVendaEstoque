unit uUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBExtCtrls, DBGrids,
  StdCtrls, MaskEdit, ExtCtrls, Buttons, uDM, uUtils, ZDataset;

Procedure limpaCampos(Form: TForm);

implementation

Procedure limpaCampos(Form: TForm);
var
  i : Integer;
begin
  for i := 0 to Form.ComponentCount-1 do
  begin
    if Form.Components[i] is TEdit then
    (Form.Components[i] as TEdit).Text:='';

    if Form.Components[i] is TMaskEdit then
    (Form.Components[i] as TMaskEdit).Text:='';

    if Form.Components[i] is TLabeledEdit then
    (Form.Components[i] as TLabeledEdit).Text:='';
  end;
end;

end.

