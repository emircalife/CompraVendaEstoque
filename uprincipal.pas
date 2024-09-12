unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  Buttons, ComCtrls, uUtils, uCategoria, uSubcategoria, uUnidadeMedida,
  uFormaPagamento, uUsuario, uDM, uEmpresa, uFornecedor, uCliente, uCompra,
  uProduto, uVenda;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnClientes: TBitBtn;
    btnTrocarUsuario: TBitBtn;
    btnVendas: TBitBtn;
    btnFornecedores: TBitBtn;
    btnProdutos: TBitBtn;
    btnCompra: TBitBtn;
    btnFormasPagamento: TBitBtn;
    btnSair: TBitBtn;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem9: TMenuItem;
    Separator2: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Separator3: TMenuItem;
    Separator1: TMenuItem;
    mnuMenu: TMainMenu;
    pnlBotoes: TPanel;
    stsPrincipal: TStatusBar;
    tmrPrincipal: TTimer;
    procedure btnClientesClick(Sender: TObject);
    procedure btnCompraClick(Sender: TObject);
    procedure btnFormasPagamentoClick(Sender: TObject);
    procedure btnFornecedoresClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnTrocarUsuarioClick(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure pnlBotoesClick(Sender: TObject);
    procedure Separator2Click(Sender: TObject);
    procedure Separator3Click(Sender: TObject);
    procedure tmrPrincipalTimer(Sender: TObject);
  private

  public
    cNomeUsuarioLogado        : String;
    nIdUsuarioLogado          : Integer;
    nNivelAcessoUsuarioLogado : Integer;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.tmrPrincipalTimer(Sender: TObject);
begin
  stsPrincipal.Panels[0].Text :=  FormatDateTime('dddd dd/mm/yyyy', now);
  stsPrincipal.Panels[1].Text :=  TimeToStr(now);
  stsPrincipal.Panels[2].Text :=  'Olá, ' + cNomeUsuarioLogado + '. Seja bem-vindo!';
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
end;

procedure TfrmPrincipal.MenuItem10Click(Sender: TObject);
begin
  frmFornecedor := TfrmFornecedor.create(self);
  frmFornecedor.ShowModal;
  FreeAndNil(frmFornecedor);
end;

procedure TfrmPrincipal.MenuItem11Click(Sender: TObject);
begin
  frmCompra := TfrmCompra.Create(self);

  frmCompra.cNomeUsuarioLogado        := cNomeUsuarioLogado;
  frmCompra.nIdUsuarioLogado          := nIdUsuarioLogado;
  frmCompra.nNivelAcessoUsuarioLogado := nNivelAcessoUsuarioLogado;

  frmCompra.ShowModal;
  FreeAndNil(frmCompra);
end;

procedure TfrmPrincipal.MenuItem12Click(Sender: TObject);
begin
  frmVenda := TfrmVenda.Create(self);
  frmVenda.ShowModal;
  FreeAndNil(frmVenda);
end;

procedure TfrmPrincipal.MenuItem14Click(Sender: TObject);
begin

end;

procedure TfrmPrincipal.MenuItem15Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.MenuItem2Click(Sender: TObject);
begin
  frmUsuario := TfrmUsuario.Create(self);
  frmUsuario.ShowModal;
  FreeAndNil(frmUsuario);
end;

procedure TfrmPrincipal.MenuItem3Click(Sender: TObject);
begin
  frmEmpresa := TfrmEmpresa.Create(self);
  frmEmpresa.ShowModal;
  FreeAndNil(frmEmpresa);
end;

procedure TfrmPrincipal.MenuItem4Click(Sender: TObject);
begin
  frmCategoria := TfrmCategoria.Create(self);
  frmCategoria.ShowModal;
  FreeAndNil(frmCategoria);
end;

procedure TfrmPrincipal.MenuItem5Click(Sender: TObject);
begin
  frmSubcategoria := TfrmSubcategoria.Create(self);
  frmSubcategoria.ShowModal;
  FreeAndNil(frmSubcategoria);
end;

procedure TfrmPrincipal.MenuItem6Click(Sender: TObject);
begin
  frmUnidadeMedida := TfrmUnidadeMedida.Create(self);
  frmUnidadeMedida.ShowModal;
  FreeAndNil(frmUnidadeMedida);
end;

procedure TfrmPrincipal.MenuItem7Click(Sender: TObject);
begin
  frmFormaPagamento := TfrmFormaPagamento.Create(self);
  frmFormaPagamento.ShowModal;
  FreeAndNil(frmFormaPagamento);
end;

procedure TfrmPrincipal.MenuItem8Click(Sender: TObject);
begin
  frmProduto := TfrmProduto.Create(self);
  frmProduto.ShowModal;
  FreeAndNil(frmProduto);
end;

procedure TfrmPrincipal.pnlBotoesClick(Sender: TObject);
begin

end;

procedure TfrmPrincipal.Separator2Click(Sender: TObject);
begin
  frmCliente := TfrmCliente.Create(self);
  frmCliente.ShowModal;
  FreeAndNil(frmCliente);
end;

procedure TfrmPrincipal.Separator3Click(Sender: TObject);
begin

end;

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin
  frmCliente := TfrmCliente.Create(self);
  frmCliente.ShowModal;
  FreeAndNil(frmCliente);
end;

procedure TfrmPrincipal.btnCompraClick(Sender: TObject);
begin
  frmCompra := TfrmCompra.Create(self);

  frmCompra.cNomeUsuarioLogado        := cNomeUsuarioLogado;
  frmCompra.nIdUsuarioLogado          := nIdUsuarioLogado;
  frmCompra.nNivelAcessoUsuarioLogado := nNivelAcessoUsuarioLogado;

  frmCompra.ShowModal;
  FreeAndNil(frmCompra);
end;

procedure TfrmPrincipal.btnFormasPagamentoClick(Sender: TObject);
begin
  frmFormaPagamento := TfrmFormaPagamento.Create(self);
  frmFormaPagamento.ShowModal;
  FreeAndNil(frmFormaPagamento);
end;

procedure TfrmPrincipal.btnFornecedoresClick(Sender: TObject);
begin
  frmFornecedor := TfrmFornecedor.create(self);
  frmFornecedor.ShowModal;
  FreeAndNil(frmFornecedor);
end;

procedure TfrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  frmProduto := TfrmProduto.Create(self);
  frmProduto.ShowModal;
  FreeAndNil(frmProduto);
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.btnTrocarUsuarioClick(Sender: TObject);
begin
end;

procedure TfrmPrincipal.btnVendasClick(Sender: TObject);
begin
  frmVenda := TfrmVenda.Create(self);
  frmVenda.ShowModal;
  FreeAndNil(frmVenda);
end;

end.

