unit uUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBExtCtrls, DBGrids,
  StdCtrls, MaskEdit, ExtCtrls, Buttons, uDM, ZDataset, md5, rxcurredit;

procedure limpaCampos(Form: TForm);
function Criptografar(cTexto : String):String;
function IIf(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
function isCategoriaComSubcategoria(idCategoria : Integer):Boolean;
function isCategoriaOuSubcategoriaComProduto(idCategoria, idSubcategoria : Integer):Boolean;

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

    if Form.Components[i] is TCheckbox then
      (Form.Components[i] as TCheckbox).Checked:=false;

    if Form.Components[i] is TCurrencyEdit then
      (Form.Components[i] as TCurrencyEdit).Text:='';
  end;
end;

function Criptografar(cTexto : String):String;
begin
  result := MD5Print(MD5String(cTexto));
end;

function IIf(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
 begin
   if Expressao then
      Result := ParteTRUE
   else
      Result := ParteFALSE;
 end;

function isCategoriaComSubcategoria(idCategoria : Integer):Boolean;
const
  cSQLBusca : String = 'SELECT idSubcategoria            '+
                       '  FROM estoque.subcategorias     '+
                       '  WHERE categoria =:PidCategoria ';
var
  QryManutencao  : TZQuery;
  llTemCategoria : Boolean;
begin
  llTemCategoria := false;

  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLBusca);
    QryManutencao.ParamByName('PidCategoria').AsInteger := idCategoria;
    QryManutencao.Open;

    if QryManutencao.RecordCount > 0 then
      llTemCategoria := true;
  except
    MessageDlg('Erro na Busca de categoria.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);

  Result := llTemCategoria;
end;

function isCategoriaOuSubcategoriaComProduto(idCategoria, idSubcategoria : Integer):Boolean;
const
  cSQLBuscaCategoria : String = 'SELECT produto                 '+
                                '  FROM estoque.produtos        '+
                                '  WHERE categoria =:Pcategoria ';

  cSQLBuscaSubcategoria : String = 'SELECT subcategoria                  '+
                                   '  FROM estoque.produtos              '+
                                   '  WHERE subcategoria =:Psubcategoria ';

var
  QryManutencao  : TZQuery;
  llTem : Boolean;
begin
  llTem := false;

  try
    if idCategoria > 0 then
    begin
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLBuscaCategoria);
      QryManutencao.ParamByName('Pcategoria').AsInteger := idCategoria;
      QryManutencao.Open;

      if QryManutencao.RecordCount > 0 then
        llTem := true;
    end
    else if idSubcategoria > 0 then
    begin
      QryManutencao.Close;
      QryManutencao.SQL.Add(cSQLBuscaCategoria);
      QryManutencao.ParamByName('Psubcategoria').AsInteger := idSubcategoria;
      QryManutencao.Open;

      if QryManutencao.RecordCount > 0 then
        llTem := true;
    end;
  except
    MessageDlg('Erro na Busca de categoria/subcategoria.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);

  Result := llTem;
end;

end.

