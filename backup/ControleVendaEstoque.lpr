program ControlevendaEstoque;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  SysUtils,
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, rxnew, LCLFormat, uPrincipal, uDM, uSubcategoria, uUnidadeMedida,
  uFormaPagamento, uUsuario, uEmpresa, uFornecedor, uCliente, uLogin, uCompra,
  uProduto, uVenda;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  DateSeparator := '/';
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.


