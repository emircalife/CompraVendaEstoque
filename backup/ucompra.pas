unit uCompra;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, uDM, uUtils,
  DB, Buttons, DBGrids, StdCtrls, MaskEdit, ExtCtrls, DBCtrls,
  ZDataset, rxcurredit;

type

  { TfrmCompra }

  TfrmCompra = class(TForm)
    btnAlterar: TBitBtn;
    btnAlterarItens: TBitBtn;
    btnDesfazer: TBitBtn;
    btnDesfazerItens: TBitBtn;
    btnExcluir: TBitBtn;
    btnExcluirItens: TBitBtn;
    btnGravar: TBitBtn;
    btnGravarItens: TBitBtn;
    btnNovaCategoria: TBitBtn;
    btnNovaSubcategoria: TBitBtn;
    btnNovoItens: TBitBtn;
    btnNovoProduto: TBitBtn;
    btnNovo: TBitBtn;
    btnNovoFornecedor: TBitBtn;
    btnNovaFormaDePagamento: TBitBtn;
    btnSair: TBitBtn;
    dsCategoria: TDataSource;
    dsFornecedor: TDataSource;
    dsFormaDePagamento: TDataSource;
    dsListarItens: TDataSource;
    dsStatusDaCompra: TDataSource;
    dsListar: TDataSource;
    dsSubcategoria: TDataSource;
    dsProduto: TDataSource;
    edtDiasParaEntrega: TEdit;
    edtDtCadastro: TMaskEdit;
    edtDtCompra: TMaskEdit;
    edtValorDeCusto: TCurrencyEdit;
    edtQuantidade: TCurrencyEdit;
    edtValorTotalDoItem: TCurrencyEdit;
    edtValorDeVenda: TCurrencyEdit;
    edtValorDeDesconto: TCurrencyEdit;
    grdDados: TDBGrid;
    grdDadosItens: TDBGrid;
    lblCategoria: TLabel;
    lblDtCadastro: TLabel;
    lblDtCompra: TLabel;
    lblDiasParaEntrega: TLabel;
    lblStatusDaCompra: TLabel;
    lblFornecedor1: TLabel;
    lblFormaDePagamento: TLabel;
    lblSubcategoria: TLabel;
    lblProduto: TLabel;
    lblValorDeCusto: TLabel;
    lblQuantidade: TLabel;
    lblValorTotalDoItem: TLabel;
    lblValorDeVenda: TLabel;
    lblValorDeDesconto: TLabel;
    lkpCategoria: TDBLookupComboBox;
    lkpStatusDaCompra: TDBLookupComboBox;
    lkpFornecedor: TDBLookupComboBox;
    lkpFormaDePagamento: TDBLookupComboBox;
    lkpSubcategoria: TDBLookupComboBox;
    lkpProduto: TDBLookupComboBox;
    pnlBotoes: TPanel;
    pnlBotoesItens: TPanel;
    qryCategoria: TZQuery;
    qryFornecedor: TZQuery;
    qryFormaDePagamento: TZQuery;
    qryListarItens: TZQuery;
    qryStatusDaCompra: TZQuery;
    qryListar: TZQuery;
    qrySubcategoria: TZQuery;
    qryProduto: TZQuery;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnAlterarItensClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnDesfazerItensClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnExcluirItensClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnGravarItensClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnNovoItensClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dsListarDataChange(Sender: TObject; Field: TField);
    procedure dsListarItensDataChange(Sender: TObject; Field: TField);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure edtValorDeDescontoChange(Sender: TObject);
    procedure edtValorDeVendaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lkpProdutoChange(Sender: TObject);
    procedure pnlBotoesClick(Sender: TObject);
  private
    idCompra, idCompraItem : Integer;
    cOperacaoCompra, cOperacaoItemCompra : String;
    procedure ListarTodosCompras;
    procedure getIdCompra;
    procedure GetDadosTabelaCompras;
    procedure ListarTodosCompraItens(nIdCompra:Integer);
    procedure getIdCompraItem;
    procedure GetDadosTabelaCompraItens;
    procedure LimparCamposCompra;
    procedure LimparCamposCompraItens;
    function CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto : Currency):Currency;
    procedure CompraIncluir;
    procedure CompraAlterar;
    procedure CompraExcluir;
    procedure ItemCompraIncluir;
    procedure ItemCompraAlterar;
    procedure ItemCompraExcluir;
  public
    cNomeUsuarioLogado        : String;
    nIdUsuarioLogado          : Integer;
    nNivelAcessoUsuarioLogado : Integer;
  end;

var
  frmCompra: TfrmCompra;

implementation

{$R *.lfm}

{ TfrmCompra }

procedure TfrmCompra.dsListarItensDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfrmCompra.edtQuantidadeChange(Sender: TObject);
var
  nQtde, nVlVenda, nVlDesconto, nValorTotalItem : Currency;
begin
  if (trim(edtQuantidade.Text) <> EmptyStr) and
     (trim(edtValorDeVenda.Text) <> EmptyStr) then
  begin
    nVlDesconto := uUtils.IIf(trim(edtValorDeDesconto.Text) = EmptyStr, 0, edtValorDeDesconto.Text);

    if (TryStrToCurr(edtQuantidade.Text, nQtde))then
      nQtde := nQtde
    else
      nQtde := 1;

    if (TryStrToCurr(edtValorDeVenda.Text, nVlVenda))then
      nVlVenda := nVlVenda
    else
      nVlVenda := 0;

    if (TryStrToCurr(edtValorDeDesconto.Text, nVlDesconto))then
      nVlDesconto := nVlDesconto
    else
      nVlDesconto := 0;

    nValorTotalItem := CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto);

    edtValorTotalDoItem.Text := FormatFloat('#,##0.00', nValorTotalItem);
  end;
end;

procedure TfrmCompra.edtValorDeDescontoChange(Sender: TObject);
var
  nQtde, nVlVenda, nVlDesconto, nValorTotalItem : Currency;
begin
  if (trim(edtQuantidade.Text) <> EmptyStr) and
     (trim(edtValorDeVenda.Text) <> EmptyStr) then
  begin
    nVlDesconto := uUtils.IIf(trim(edtValorDeDesconto.Text) = EmptyStr, 0, edtValorDeDesconto.Text);

    if (TryStrToCurr(edtQuantidade.Text, nQtde))then
      nQtde := nQtde
    else
      nQtde := 1;

    if (TryStrToCurr(edtValorDeVenda.Text, nVlVenda))then
      nVlVenda := nVlVenda
    else
      nVlVenda := 0;

    if (TryStrToCurr(edtValorDeDesconto.Text, nVlDesconto))then
      nVlDesconto := nVlDesconto
    else
      nVlDesconto := 0;

    nValorTotalItem := CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto);

    edtValorTotalDoItem.Text := FormatFloat('#,##0.00', nValorTotalItem);
  end;
end;

procedure TfrmCompra.edtValorDeVendaChange(Sender: TObject);
var
  nQtde, nVlVenda, nVlDesconto, nValorTotalItem : Currency;
begin
  if (TryStrToCurr(edtQuantidade.Text, nQtde))then
    nQtde := nQtde
  else
    nQtde := 1;

  if (TryStrToCurr(edtValorDeVenda.Text, nVlVenda))then
    nVlVenda := nVlVenda
  else
    nVlVenda := 0;

  if (TryStrToCurr(edtValorDeDesconto.Text, nVlDesconto))then
    nVlDesconto := nVlDesconto
  else
    nVlDesconto := 1;

  nValorTotalItem := CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto);

  edtValorTotalDoItem.Text := FormatFloat('#,##0.00', nValorTotalItem);
end;

procedure TfrmCompra.FormCreate(Sender: TObject);
begin

end;

procedure TfrmCompra.FormShow(Sender: TObject);
begin
  ListarTodosCompras;

  if qryListar.RecordCount > 0 then
    ListarTodosCompraItens(qryListar.FieldByName('idCompra').AsInteger);

  uUtils.limpaCampos(self);

  cOperacaoCompra     := 'C';
  cOperacaoItemCompra := 'C';

  //-- Compra --
  if qryStatusDaCompra.State = dsInactive then
    qryStatusDaCompra.Open;

  if qryFornecedor.State = dsInactive then
    qryFornecedor.Open;

  if qryFormaDePagamento.State = dsInactive then
    qryFormaDePagamento.Open;

  //-- Itens da Compra --
  if qryCategoria.State = dsInactive then
    qryCategoria.Open;

  if qrySubcategoria.State = dsInactive then
    qrySubcategoria.Open;

  if qryProduto.State = dsInactive then
    qryProduto.Open;
end;

procedure TfrmCompra.lkpProdutoChange(Sender: TObject);
begin
  edtValorDeCusto.Text := FormatFloat('#,##0.00', qryProduto.FieldByName('valorCusto').AsCurrency);
  edtValorDeVenda.Text := FormatFloat('#,##0.00', qryProduto.FieldByName('valorVenda').AsCurrency);
end;

procedure TfrmCompra.pnlBotoesClick(Sender: TObject);
begin

end;

procedure TfrmCompra.dsListarDataChange(Sender: TObject; Field: TField);
begin
  if qryListarItens.State <> dsInactive then
    if qryListarItens.RecordCount > 0 then
      ListarTodosCompraItens(qryListar.FieldByName('idCompra').AsInteger);
end;

procedure TfrmCompra.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCompra.btnNovoClick(Sender: TObject);
begin
  idCompra        := 0;
  cOperacaoCompra := 'I';

  LimparCamposCompra;

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtDtCompra.SetFocus;

  Caption := 'Inclusão de Compra';
end;

procedure TfrmCompra.btnNovoItensClick(Sender: TObject);
begin
  idCompraItem        := 0;
  cOperacaoItemCompra := 'I';

  LimparCamposCompraItens;

  lkpCategoria.SetFocus;

  Caption := 'Inclusão de Item de Compra';
end;

procedure TfrmCompra.btnDesfazerClick(Sender: TObject);
begin
  LimparCamposCompra;
  cOperacaoCompra    := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Compras';
end;

procedure TfrmCompra.btnDesfazerItensClick(Sender: TObject);
begin
  LimparCamposCompraItens;
  cOperacaoItemCompra := 'C';
  Caption             := 'Compras';
end;

procedure TfrmCompra.btnExcluirClick(Sender: TObject);
begin
  getIdCompra;
  CompraExcluir;
end;

procedure TfrmCompra.btnExcluirItensClick(Sender: TObject);
begin
  getIdCompraItem;
  ItemCompraExcluir;
end;

procedure TfrmCompra.btnGravarClick(Sender: TObject);
begin
  if cOperacaoCompra = 'I' then
    CompraIncluir
  else if cOperacaoCompra = 'A' then
    CompraAlterar;

  LimparCamposCompra;

  Caption := 'Compras';
end;

procedure TfrmCompra.btnGravarItensClick(Sender: TObject);
begin
  if cOperacaoItemCompra = 'I' then
    ItemCompraIncluir
  else if cOperacaoItemCompra = 'A' then
    ItemCompraAlterar;

  LimparCamposCompraItens;

  Caption := 'Compras';
end;

procedure TfrmCompra.btnAlterarClick(Sender: TObject);
begin
  cOperacaoCompra := 'A';
  Caption         := 'Alteração de Compra';

  GetDadosTabelaCompras;
end;

procedure TfrmCompra.btnAlterarItensClick(Sender: TObject);
begin
  cOperacaoItemCompra := 'A';
  Caption             := 'Alteração de Item de Compra';

  GetDadosTabelaCompraItens;
end;

procedure TfrmCompra.ListarTodosCompras;
const
  cSQLConsultar : String = 'select cpa.idcompra,                                                                '+
                           '       cpa.fornecedor,                                                              '+
                           '       cpa.formaPagamento,                                                          '+
                           '       cpa.dtCompra,                                                                '+
                           '       cpa.dtCadastro,                                                              '+
                           '       cpa.usuario,                                                                 '+
                           '       cpa.status,                                                                  '+
                           '       cpa.diasParaEntrega,                                                         '+
                           '       forn.nomeFornecedor,                                                         '+
                           '       forma.nomeFormaPagamento,                                                    '+
                           '       stcpa.nomeStatusCompra                                                       '+
                           '  FROM compras cpa                                                                  '+
                           '  INNER JOIN fornecedores forn ON (cpa.fornecedor = forn.idFornecedor)              '+
                           '  INNER JOIN formasPagamento forma ON (cpa.formaPagamento = forma.idFormaPagamento) '+
                           '  INNER JOIN statusCompras stcpa ON (cpa.status = stcpa.idStatusCompra)             '+
                           ' ORDER BY cpa.dtCompra DESC                                                         ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmCompra.getIdCompra;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idCompra := qryListar.FieldByName('idCompra').AsInteger;
  end;
end;

procedure TfrmCompra.GetDadosTabelaCompras;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idCompra           := qryListar.FieldByName('idCategoria').AsInteger;
    edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    lkpFornecedor.KeyValue       := qryListar.FieldByName('fornecedor').AsInteger;
    lkpFormaDePagamento.KeyValue := qryListar.FieldByName('formaPagamento').AsInteger;
    edtDtCompra.Text             := DateToStr(qryListar.FieldByName('formaPagamento').AsDateTime);
    lkpStatusDaCompra.KeyValue   := qryListar.FieldByName('status').AsInteger;
    edtDiasParaEntrega.Text      := trim(intToStr(qryListar.FieldByName('diasParaEntrega').AsInteger));
  end;
end;

procedure TfrmCompra.ListarTodosCompraItens(nIdCompra : Integer);
const
  cSQLConsultar : String = 'SELECT cpi.idCompraItem,                                                    '+
                           '        cpi.compra,                                                         '+
                           '        cpi.categoria,                                                      '+
                           '        cpi.subcategoria,                                                   '+
                           '        cpi.produto,                                                        '+
                           '        cpi.quantidade,                                                     '+
                           '        cpi.vlCusto,                                                        '+
                           '        cpi.vlVenda,                                                        '+
                           '        cpi.vlDesconto,                                                     '+
                           '        cpi.vlTotalItem,                                                    '+
                           '        cat.categoriaDescr,                                                 '+
                           '        scat.subcategoriaDescr,                                             '+
                           '        pro.nomeProduto                                                     '+
                           '  FROM compraItens cpi                                                      '+
                           '  INNER JOIN categorias cat ON (cpi.categoria = cat.idCategoria)            '+
                           '  INNER JOIN subcategorias scat ON (cpi.subCategoria = scat.idSubcategoria) '+
                           '  INNER JOIN produtos pro ON (cpi.produto = pro.idProduto)                  '+
                           ' WHERE cpi.compra = :PidCompra                                              '+
                           ' ORDER BY compra, idCompraItem                                              ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.ParamByName('PidCompra').AsInteger := nidCompra;
    qryListar.Open;
  except
  end;
end;

procedure TfrmCompra.getIdCompraItem;
begin
  if (qryListarItens.State <> dsInactive) and (qryListarItens.RecordCount >= 1) then
  begin
    idCompraItem := qryListarItens.FieldByName('idCompraItem').AsInteger;
  end;
end;

procedure TfrmCompra.GetDadosTabelaCompraItens;
begin
  if (qryListarItens.State <> dsInactive) and (qryListarItens.RecordCount >= 1) then
  begin
    idCompraItem             := qryListarItens.FieldByName('idCompraItem').AsInteger;
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

procedure TfrmCompra.LimparCamposCompra;
begin
  edtDtCadastro.Clear;
  edtDtCompra.Clear;
  edtDiasParaEntrega.Clear;
end;

procedure TfrmCompra.LimparCamposCompraItens;
begin
  edtQuantidade.Clear;
  edtValorDeCusto.Clear;
  edtValorDeVenda.Clear;
  edtValorDeDesconto.Clear;
  edtValorTotalDoItem.Clear;
end;

function TfrmCompra.CalcularValorTotalItem(nQtde, nVlVenda, nVlDesconto : Currency):Currency;
var
  vlTotalItem : Currency;

begin
  vlTotalItem := (nQtde * nVlVenda) - nVlDesconto;

  Result := vlTotalItem;
end;

procedure TfrmCompra.CompraIncluir;
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
    QryManutencao.ParamByName('Pfornecedor').AsInteger        := lkpFornecedor.KeyValue;
    QryManutencao.ParamByName('PformaPagamento').AsInteger    := lkpFormaDePagamento.KeyValue;
    QryManutencao.ParamByName('PdtCompra').AsDateTime         := StrToDate(edtDtCompra.Text);
    QryManutencao.ParamByName('Pusuario').AsInteger           := nIdUsuarioLogado;
    QryManutencao.ParamByName('PdiasParaEntrega').AsInteger   := uUtils.IIf(trim(edtDiasParaEntrega.Text) = '', 0, StrToInt(edtDiasParaEntrega.Text));
    QryManutencao.ParamByName('PdtCadastro').AsDateTime       := now;
    QryManutencao.ExecSQL;

    ListarTodosCompras;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCompra.CompraAlterar;
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
    QryManutencao.ParamByName('Pfornecedor').AsInteger        := lkpFornecedor.KeyValue;
    QryManutencao.ParamByName('PformaPagamento').AsInteger    := lkpFormaDePagamento.KeyValue;
    QryManutencao.ParamByName('PdtCompra').AsDateTime         := StrToDate(edtDtCompra.Text);
    QryManutencao.ParamByName('Pusuario').AsInteger           := nIdUsuarioLogado;
    QryManutencao.ParamByName('PdiasParaEntrega').AsInteger   := uUtils.IIf(trim(edtDiasParaEntrega.Text) = '', 0, StrToInt(edtDiasParaEntrega.Text));
    QryManutencao.ParamByName('PidCompra').AsInteger          := idCompra;
    QryManutencao.ExecSQL;

    ListarTodosCompras;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCompra.CompraExcluir;
const
  cSQLManutencao : String = 'DELETE FROM compras         '+
                            ' WHERE idCompra =:PidCompra ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da compra feita em ' +
       FormatFloat('#,##0.00', qryListar.FieldByName('dtCompra').AsDateTime) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidCompra').AsInteger := idCompra;
      QryManutencao.ExecSQL;

      ListarTodosCompras;

      MessageDlg('Exclusão realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Exclusão.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end;
end;

procedure TfrmCompra.ItemCompraIncluir;
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
    getIdCompra;

    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('Pcompra').AsInteger       := idCompra;
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

    ListarTodosCompraItens(idCompra);

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCompra.ItemCompraAlterar;
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
    QryManutencao.ParamByName('Pcompra').AsInteger       := idCompra;
    QryManutencao.ParamByName('Pcategoria').AsInteger    := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('Psubcategoria').AsInteger := lkpSubcategoria.KeyValue;
    QryManutencao.ParamByName('Pproduto').AsInteger      := lkpProduto.KeyValue;
    QryManutencao.ParamByName('Pquantidade').AsInteger   := uUtils.IIf(trim(edtQuantidade.Text) = '', 0, StrToInt(edtQuantidade.Text));
    QryManutencao.ParamByName('PvlCusto').AsInteger      := uUtils.IIf(trim(edtValorDeCusto.Text) = '', 0, StrToInt(edtValorDeCusto.Text));
    QryManutencao.ParamByName('PvlVenda').AsInteger      := uUtils.IIf(trim(edtValorDeVenda.Text) = '', 0, StrToInt(edtValorDeVenda.Text));
    QryManutencao.ParamByName('PvlDesconto').AsInteger   := uUtils.IIf(trim(edtValorDeDesconto.Text) = '', 0, StrToInt(edtValorDeDesconto.Text));
    QryManutencao.ParamByName('PvlTotalItem').AsInteger  := uUtils.IIf(trim(edtValorTotalDoItem.Text) = '', 0, StrToInt(edtValorTotalDoItem.Text));
    QryManutencao.ParamByName('PidCompraItem').AsInteger := idCompraItem;
    QryManutencao.ExecSQL;

    ListarTodosCompraItens(idCompra);

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCompra.ItemCompraExcluir;
const
  cSQLManutencao : String = 'DELETE FROM compraItens             '+
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
      QryManutencao.ParamByName('PidCompraItem').AsInteger := idCompraItem;;
      QryManutencao.ExecSQL;

      getIdCompra;

      ListarTodosCompraItens(idCompra);

      MessageDlg('Exclusão realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Exclusão.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end;
end;

end.

