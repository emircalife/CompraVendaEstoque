unit uVenda;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, DBCtrls, Buttons, rxcurredit, ZDataset,
  ZAbstractRODataset, uDM, uUtils, DB;

type

  { TfrmVenda }

  TfrmVenda = class(TForm)
    btnAlterar: TBitBtn;
    btnAlterarItens: TBitBtn;
    btnDesfazer: TBitBtn;
    btnDesfazerItens: TBitBtn;
    btnExcluir: TBitBtn;
    btnExcluirItens: TBitBtn;
    btnGravar: TBitBtn;
    btnGravarItens: TBitBtn;
    btnNovaCategoria: TBitBtn;
    btnNovaFormaDePagamento: TBitBtn;
    btnNovaSubcategoria: TBitBtn;
    btnNovo: TBitBtn;
    btnNovoCliente: TBitBtn;
    btnNovoItens: TBitBtn;
    btnNovoProduto: TBitBtn;
    btnSair: TBitBtn;
    dsCategoria: TDataSource;
    dsFormaDePagamento: TDataSource;
    dsCliente: TDataSource;
    dsListar: TDataSource;
    dsListarItens: TDataSource;
    dsProduto: TDataSource;
    dsStatusDaVenda: TDataSource;
    dsSubcategoria: TDataSource;
    edtDtCadastro: TMaskEdit;
    edtDtVenda: TMaskEdit;
    edtDtEntrega: TMaskEdit;
    edtQuantidade: TCurrencyEdit;
    edtValorDeCusto: TCurrencyEdit;
    edtValorDeDesconto: TCurrencyEdit;
    edtValorDeVenda: TCurrencyEdit;
    edtValorTotalDoItem: TCurrencyEdit;
    grdDados: TDBGrid;
    grdDadosItens: TDBGrid;
    lblCategoria: TLabel;
    lblDtEntrega: TLabel;
    lblDtCadastro: TLabel;
    lblDtVenda: TLabel;
    lblFormaDePagamento: TLabel;
    lblCliente: TLabel;
    lblProduto: TLabel;
    lblQuantidade: TLabel;
    lblStatusDaVenda: TLabel;
    lblSubcategoria: TLabel;
    lblValorDeCusto: TLabel;
    lblValorDeDesconto: TLabel;
    lblValorDeVenda: TLabel;
    lblValorTotalDoItem: TLabel;
    lkpCategoria: TDBLookupComboBox;
    lkpFormaDePagamento: TDBLookupComboBox;
    lkpCliente: TDBLookupComboBox;
    lkpProduto: TDBLookupComboBox;
    lkpStatusDaVenda: TDBLookupComboBox;
    lkpSubcategoria: TDBLookupComboBox;
    pnlBotoes: TPanel;
    pnlBotoesItens: TPanel;
    qryCategoria: TZQuery;
    qryFormaDePagamento: TZQuery;
    qryCliente: TZQuery;
    qryListar: TZQuery;
    qryListarItens: TZQuery;
    qryProduto: TZQuery;
    qryStatusDaVenda: TZQuery;
    qrySubcategoria: TZQuery;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lkpClienteChange(Sender: TObject);
    procedure lkpFormaDePagamentoChange(Sender: TObject);
    procedure pnlBotoesClick(Sender: TObject);
  private
    idVenda, idVendaItem : Integer;
    cOperacaoVenda, cOperacaoItemVenda : String;
    procedure ListarTodosVendas;
    procedure getIdVenda;
    procedure GetDadosTabelaVendas;
    procedure ListarTodosVendaItens(nIdVenda : Integer);
    procedure getIdVendaItem;
    procedure GetDadosTabelaVendaItens;
    procedure LimparCamposVenda;
    procedure LimparCamposVendaItens;
    function CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto : Currency):Currency;
    procedure VendaIncluir;
    procedure VendaAlterar;
    procedure CompraExcluir;
    procedure ItemCompraIncluir;
    procedure ItemVendaAlterar;
    procedure ItemVendaExcluir;
  public
    cNomeUsuarioLogado        : String;
    nIdUsuarioLogado          : Integer;
    nNivelAcessoUsuarioLogado : Integer;
  end;

var
  frmVenda: TfrmVenda;

implementation

{$R *.lfm}

{ TfrmVenda }

procedure TfrmVenda.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVenda.btnExcluirClick(Sender: TObject);
begin

end;

procedure TfrmVenda.FormCreate(Sender: TObject);
begin

end;

procedure TfrmVenda.FormShow(Sender: TObject);
begin
  ListarTodosVendas;

  if qryListar.RecordCount > 0 then
    ListarTodosVendaItens(qryListar.FieldByName('idVenda').AsInteger);

  uUtils.limpaCampos(self);

  cOperacaoVenda     := 'C';
  cOperacaoItemVenda := 'C';

  //-- Venda --
  if qryStatusDaVenda.State = dsInactive then
    qryStatusDaVenda.Open;

  if qryCliente.State = dsInactive then
    qryCliente.Open;

  if qryFormaDePagamento.State = dsInactive then
    qryFormaDePagamento.Open;

  //-- Itens da Venda --
  if qryCategoria.State = dsInactive then
    qryCategoria.Open;

  if qrySubcategoria.State = dsInactive then
    qrySubcategoria.Open;

  if qryProduto.State = dsInactive then
    qryProduto.Open;
end;

procedure TfrmVenda.lkpClienteChange(Sender: TObject);
begin

end;

procedure TfrmVenda.lkpFormaDePagamentoChange(Sender: TObject);
begin

end;

procedure TfrmVenda.pnlBotoesClick(Sender: TObject);
begin

end;

procedure TfrmVenda.ListarTodosVendas;
const
  cSQLConsultar : String = 'select vda.idvenda,                                                                 '+
                           '       vda.cliente,                                                                 '+
                           '       vda.formaPagamento,                                                          '+
                           '       vda.dtVenda,                                                                 '+
                           '       vda.dtEntrega,                                                               '+
                           '       vda.dtCadastro,                                                              '+
                           '       vda.usuario,                                                                 '+
                           '       vda.status,                                                                  '+
                           '       cli.nomeCliente,                                                             '+
                           '       forma.nomeFormaPagamento,                                                    '+
                           '       stvda.nomeStatusVenda                                                        '+
                           '  FROM vendas vda                                                                   '+
                           '  INNER JOIN clientes cli ON (vda.cliente = cli.idCliente)                          '+
                           '  INNER JOIN formasPagamento forma ON (vda.formaPagamento = forma.idFormaPagamento) '+
                           '  INNER JOIN statusVendas stvda ON (vda.status = stvda.idStatusVenda)               '+
                           ' ORDER BY vda.dtVenda DESC                                                          ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmVenda.getIdVenda;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idVenda := qryListar.FieldByName('idVenda').AsInteger;
  end;
end;

procedure TfrmVenda.GetDadosTabelaVendas;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idVenda            := qryListar.FieldByName('idVenda').AsInteger;
    edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    lkpCliente.KeyValue          := qryListar.FieldByName('cliente').AsInteger;
    lkpFormaDePagamento.KeyValue := qryListar.FieldByName('formaPagamento').AsInteger;
    edtDtVenda.Text              := DateToStr(qryListar.FieldByName('dtVenda').AsDateTime);
    lkpStatusDaVenda.KeyValue    := qryListar.FieldByName('status').AsInteger;
    edtDtEntrega.Text            := trim(DateToStr(qryListar.FieldByName('dtEntrega').AsDateTime));
  end;
end;

procedure TfrmVenda.ListarTodosVendaItens(nIdVenda : Integer);
const
  cSQLConsultar : String = 'SELECT vdi.idVendaItem,                                                     '+
                           '        vdi.venda,                                                          '+
                           '        vdi.categoria,                                                      '+
                           '        vdi.subcategoria,                                                   '+
                           '        vdi.produto,                                                        '+
                           '        vdi.quantidade,                                                     '+
                           '        vdi.vlCusto,                                                        '+
                           '        vdi.vlVenda,                                                        '+
                           '        vdi.vlDesconto,                                                     '+
                           '        vdi.vlTotalItem,                                                    '+
                           '        cat.categoriaDescr,                                                 '+
                           '        scat.subcategoriaDescr,                                             '+
                           '        pro.nomeProduto                                                     '+
                           '  FROM vendaItens vdi                                                       '+
                           '  INNER JOIN categorias cat ON (vdi.categoria = cat.idCategoria)            '+
                           '  INNER JOIN subcategorias scat ON (vdi.subCategoria = scat.idSubcategoria) '+
                           '  INNER JOIN produtos pro ON (vdi.produto = pro.idProduto)                  '+
                           '  WHERE vdi.venda = PidVenda                                                '+
                           ' ORDER BY venda, idVendaItem                                                ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.ParamByName('PidVenda').AsInteger := nidVenda;
    qryListar.Open;
  except
  end;
end;

procedure TfrmVenda.getIdVendaItem;
begin
  if (qryListarItens.State <> dsInactive) and (qryListarItens.RecordCount >= 1) then
  begin
    idVendaItem := qryListarItens.FieldByName('idVendaItem').AsInteger;
  end;
end;

procedure TfrmVenda.GetDadosTabelaVendaItens;
begin
  if (qryListarItens.State <> dsInactive) and (qryListarItens.RecordCount >= 1) then
  begin
    idVendaItem             := qryListarItens.FieldByName('idVendaItem').AsInteger;
    lkpCategoria.KeyValue    := qryListarItens.FieldByName('categoria').AsInteger;
    lkpSubcategoria.KeyValue := qryListarItens.FieldByName('subcategoria').AsInteger;
    lkpProduto.KeyValue      := qryListarItens.FieldByName('produto').AsInteger;
    edtQuantidade.Text       := FormatFloat('#,##0.00', qryListarItens.FieldByName('quantidade').AsCurrency);
    edtValorDeCusto.Text     := FormatFloat('#,##0.00', qryListarItens.FieldByName('vlCusto').AsCurrency);
    edtValorDeVenda.Text     := FormatFloat('#,##0.00', qryListarItens.FieldByName('vlVenda').AsCurrency);
    edtValorDeDesconto.Text  := FormatFloat('#,##0.00', qryListarItens.FieldByName('vlDesconto').AsCurrency);
    edtValorTotalDoItem.Text := FormatFloat('#,##0.00', qryListarItens.FieldByName('vlTotalItem').AsCurrency);
  end;
end;

procedure TfrmVenda.LimparCamposVenda;
begin
  edtDtCadastro.Clear;
  edtDtVenda.Clear;
  edtDtEntrega.Clear;
end;

procedure TfrmVenda.LimparCamposVendaItens;
begin
  edtQuantidade.Clear;
  edtValorDeCusto.Clear;
  edtValorDeVenda.Clear;
  edtValorDeDesconto.Clear;
  edtValorTotalDoItem.Clear;
end;

function TfrmVenda.CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto : Currency):Currency;
var
  vlTotalItem : Currency;

begin
  vlTotalItem := (nQtde * nVlVenda) - nVlDesconto;

  Result := vlTotalItem;
end;

procedure TfrmVenda.VendaIncluir;
const
  cSQLManutencao : String = 'INSERT INTO compras (                     '+
                            ' fornecedor, formaPagamento,              '+
                            ' dtCompra, usuario, diasParaEntrega       '+
                            ' dtCadastro                               '+
                            ' ) VALUES (                               '+
                            ' :Pfornecedor, :PformaPagamento,          '+
                            ' :PdtCompra, :Pusuario, :PdiasParaEntrega '+
                            ' :PdtCadastro                             '+
                            ' )                                        ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('Pcliente').AsInteger           := lkpCliente.KeyValue;
    QryManutencao.ParamByName('PformaPagamento').AsInteger    := lkpFormaDePagamento.KeyValue;
    QryManutencao.ParamByName('PdtVenda').AsDateTime          := StrToDate(edtDtVenda.Text);
    QryManutencao.ParamByName('Pusuario').AsInteger           := nIdUsuarioLogado;
    QryManutencao.ParamByName('PdiasParaEntrega').AsInteger   := uUtils.IIf(trim(edtDiasParaEntrega.Text) = '', 0, StrToInt(edtDiasParaEntrega));
    QryManutencao.ParamByName('PDtEntrega').AsDateTime        := uUtils.IIf(trim(edtDtEntrega.Text) = '', StrToDate('09/09/9999'), StrToDate(edtDtEntrega.Text));
    QryManutencao.ParamByName('PdtCadastro').AsDateTime       := now;
    QryManutencao.ExecSQL;

    ListarTodosVendas;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmVenda.VendaAlterar;
const
  cSQLManutencao : String = 'UPDATE compras SET                  '+
                            ' fornecedor =:Pfornecedor,          '+
                            ' formaPagamento =:PformaPagamento,  '+
                            ' dtCompra =:PdtCompra,              '+
                            ' usuario =:Pusuario,                '+
                            ' diasParaEntrega =:PdiasParaEntrega '+
                            ' WHERE                              '+
                            ' idCompra =:PidCompra               ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('Pcliente').AsInteger           := lkpCliente.KeyValue;
    QryManutencao.ParamByName('PformaPagamento').AsInteger    := lkpFormaDePagamento.KeyValue;
    QryManutencao.ParamByName('PdtVenda').AsDateTime          := StrToDate(edtDtVenda.Text);
    QryManutencao.ParamByName('Pusuario').AsInteger           := nIdUsuarioLogado;
    QryManutencao.ParamByName('PdtEntrega').AsDateTime        := uUtils.IIf(trim(edtDtEntrega.Text) = '', StrToDate('00/00/0000'), StrToDate(edtDtEntrega.Text));
    QryManutencao.ParamByName('PidVenda').AsInteger          := idVenda;
    QryManutencao.ExecSQL;

    ListarTodosVendas;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmVenda.CompraExcluir;
const
  cSQLManutencao : String = 'DELETE FROM estoque.compras '+
                            ' WHERE idCompra =:PidCompra ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da venda feita em ' +
       FormatFloat('#,##0.00', qryListar.FieldByName('dtVenda').AsDateTime) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidVenda').AsInteger := idVenda;
      QryManutencao.ExecSQL;

      ListarTodosVendas;

      MessageDlg('Exclusão realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Exclusão.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end;
end;

procedure TfrmVenda.ItemCompraIncluir;
const
  cSQLManutencao : String = 'INSERT INTO compraItens (                '+
                            ' compra, categoria, subcategoria,        '+
                            ' produto, quantidade, vlCusto,           '+
                            ' vlVenda, vlDesconto, vlTotalItem,       '+
                            ' dtCadastro                              '+
                            ' ) VALUES (                              '+
                            ' :Pcompra, :Pcategoria, :Psubcategoria,  '+
                            ' :Pproduto, :Pquantidade, :PvlCusto,     '+
                            ' :PvlVenda, :PvlDesconto, :PvlTotalItem, '+
                            ' :PdtCadastro                            '+
                            ' )                                       ';

var
  QryManutencao : TZQuery;
begin
  try
    getIdVenda;

    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PVenda').AsInteger        := idVenda;
    QryManutencao.ParamByName('Pcategoria').AsInteger    := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('Psubcategoria').AsInteger := lkpSubcategoria.KeyValue;
    QryManutencao.ParamByName('Pproduto').AsInteger      := lkpProduto.KeyValue;
    QryManutencao.ParamByName('Pquantidade').AsInteger   := uUtils.IIf(trim(edtQuantidade.Text) = '', 0, StrToInt(edtQuantidade.Text));
    QryManutencao.ParamByName('PvlCusto').AsInteger      := uUtils.IIf(trim(edtValorDeCusto.Text) = '', 0, StrToInt(edtValorDeCusto.Text));
    QryManutencao.ParamByName('PvlVenda').AsInteger      := uUtils.IIf(trim(edtValorDeVenda.Text) = '', 0, StrToInt(edtValorDeVenda.Text));
    QryManutencao.ParamByName('PvlDesconto').AsInteger   := uUtils.IIf(trim(edtValorDeDesconto.Text) = '', 0, StrToInt(edtValorDeDesconto.Text));
    QryManutencao.ParamByName('PvlTotalItem').AsInteger  := uUtils.IIf(trim(edtValorTotalDoItem.Text) = '', 0, StrToInt(edtValorTotalDoItem.Text));
    QryManutencao.ParamByName('PdtCadastro').AsDateTime  := now;
    QryManutencao.ExecSQL;

    ListarTodosVendaItens(idVenda);

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmVenda.ItemVendaAlterar;
const
  cSQLManutencao : String = 'UPDATE compraItens SET         '+
                            ' compra =:Pcompra,             '+
                            ' categoria =:Pcategoria,       '+
                            ' subcategoria =:Psubcategoria, '+
                            ' produto =:Pproduto,           '+
                            ' quantidade =:Pquantidade,     '+
                            ' vlCusto =:PvlCusto,           '+
                            ' vlVenda =:PvlVenda,           '+
                            ' vlDesconto =:PvlDesconto,     '+
                            ' vlTotalItem =:PvlTotalItem    '+
                            ' WHERE                         '+
                            ' idCompraItem =:PidCompraItem  ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PVenda').AsInteger        := idVenda;
    QryManutencao.ParamByName('Pcategoria').AsInteger    := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('Psubcategoria').AsInteger := lkpSubcategoria.KeyValue;
    QryManutencao.ParamByName('Pproduto').AsInteger      := lkpProduto.KeyValue;
    QryManutencao.ParamByName('Pquantidade').AsInteger   := uUtils.IIf(trim(edtQuantidade.Text) = '', 0, StrToInt(edtQuantidade.Text));
    QryManutencao.ParamByName('PvlCusto').AsInteger      := uUtils.IIf(trim(edtValorDeCusto.Text) = '', 0, StrToInt(edtValorDeCusto.Text));
    QryManutencao.ParamByName('PvlVenda').AsInteger      := uUtils.IIf(trim(edtValorDeVenda.Text) = '', 0, StrToInt(edtValorDeVenda.Text));
    QryManutencao.ParamByName('PvlDesconto').AsInteger   := uUtils.IIf(trim(edtValorDeDesconto.Text) = '', 0, StrToInt(edtValorDeDesconto.Text));
    QryManutencao.ParamByName('PvlTotalItem').AsInteger  := uUtils.IIf(trim(edtValorTotalDoItem.Text) = '', 0, StrToInt(edtValorTotalDoItem.Text));
    QryManutencao.ParamByName('PidVendaItem').AsInteger  := idVendaItem;
    QryManutencao.ExecSQL;

    ListarTodosVendaItens(idVenda);

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmVenda.ItemVendaExcluir;
const
  cSQLManutencao : String = 'DELETE FROM estoque.compraItens     '+
                            ' WHERE idCompraItem =:PidCompraItem ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão do item?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidVendaItem').AsInteger := idVendaItem;
      QryManutencao.ExecSQL;

      getIdVenda;

      ListarTodosVendaItens(idVenda);

      MessageDlg('Exclusão realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Exclusão.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end;
end;

end.

