unit uProduto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, DBGrids,
  StdCtrls, MaskEdit, ExtCtrls, DBCtrls, ZDataset, ZAbstractRODataset,
  rxcurredit, uUtils, uDM, uCategoria, uSubcategoria, uFornecedor,
  uUnidadeMedida, DB, Grids, LCLFormat;

type

  { TfrmProduto }

  TfrmProduto = class(TForm)
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovaCategoria: TBitBtn;
    btnNovaSubcategoria: TBitBtn;
    btnNovoFornecedor: TBitBtn;
    btnNovaUnidadeMedida: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    dsStatusProduto: TDataSource;
    edtValorDeVenda: TEdit;
    edtValorDeCusto: TEdit;
    edtQuantidadeEmEstoque: TEdit;
    edtEstoqueMinimo: TEdit;
    edtEstoqueMaximo: TEdit;
    dsCategoria: TDataSource;
    dsUnidadeMedida: TDataSource;
    dsSubcategoria: TDataSource;
    dsListar: TDataSource;
    dsFornecedor: TDataSource;
    edtNomeProduto: TEdit;
    edtDtCadastro: TMaskEdit;
    grdDados: TDBGrid;
    lblCategoria: TLabel;
    lblStatusProduto: TLabel;
    lblValorDeVenda: TLabel;
    lblValorDeCusto: TLabel;
    lblQuantidadeEmEstoque: TLabel;
    lblEstoqueMinimo: TLabel;
    lblEstoqueMaximo: TLabel;
    lblUnidadeMedida: TLabel;
    lblSubcategoria: TLabel;
    lblNomeProduto: TLabel;
    lblDtCadastro: TLabel;
    lblFornecedor: TLabel;
    lkpCategoria: TDBLookupComboBox;
    lkpStatusProduto: TDBLookupComboBox;
    lkpUnidadeMedida: TDBLookupComboBox;
    lkpSubcategoria: TDBLookupComboBox;
    lkpFornecedor: TDBLookupComboBox;
    pnlBotoes: TPanel;
    qryCategoria: TZQuery;
    qryListarCATEGORIA: TZIntegerField;
    qryListarCATEGORIADESCR: TZRawStringField;
    qryListarDTCADASTRO: TZDateTimeField;
    qryListarESTOQUEMAX: TZBCDField;
    qryListarESTOQUEMIN: TZBCDField;
    qryListarFORNECEDOR: TZIntegerField;
    qryListarIDPRODUTO: TZIntegerField;
    qryListarNOMEFORNECEDOR: TZRawStringField;
    qryListarNOMEPRODUTO: TZRawStringField;
    qryListarNOMESTATUSPRODUTO: TZRawStringField;
    qryListarNOMEUNIDADEMEDIDA: TZRawStringField;
    qryListarQTDEEMESTOQUE: TZBCDField;
    qryListarSTATUS: TZIntegerField;
    qryListarSUBCATEGORIA: TZIntegerField;
    qryListarSUBCATEGORIADESCR: TZRawStringField;
    qryListarUNIDADEMEDIDA: TZIntegerField;
    qryListarVALORCUSTO: TZBCDField;
    qryListarVALORVENDA: TZBCDField;
    qryUnidadeMedida: TZQuery;
    qrySubcategoria: TZQuery;
    qryListar: TZQuery;
    qryFornecedor: TZQuery;
    qryStatusProduto: TZQuery;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovaSubcategoriaClick(Sender: TObject);
    procedure btnNovaUnidadeMedidaClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnNovoFornecedorClick(Sender: TObject);
    procedure btnNovaCategoriaClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtEstoqueMaximoChange(Sender: TObject);
    procedure edtEstoqueMinimoChange(Sender: TObject);
    procedure edtEstoqueMinimoXChange(Sender: TObject);
    procedure edtQuantidadeEmEstoqueChange(Sender: TObject);
    procedure edtValorDeCustoChange(Sender: TObject);
    procedure edtValorDeVendaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure qryListarAfterOpen(DataSet: TDataSet);
    procedure qryListarDTCADASTROGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure qryListarDTCADASTROSetText(Sender: TField; const aText: string);
  private
    idProduto   : Integer;
    cOperacao   : String; //(I)ncluir, (A)lterar, (C)onsultar
    procedure ListarTodos;
    procedure getId;
    procedure GetDadosTabela;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
  public

  end;

var
  frmProduto: TfrmProduto;

implementation

{$R *.lfm}

{ TfrmProduto }

procedure TfrmProduto.FormCreate(Sender: TObject);
begin

end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  uUtils.limpaCampos(self);

  ListarTodos;

  cOperacao := 'C';

  if qryCategoria.State = dsInactive then
    qryCategoria.Open;

  if qrySubcategoria.State = dsInactive then
    qrySubcategoria.Open;

  if qryFornecedor.State = dsInactive then
    qryFornecedor.Open;

  if qryUnidadeMedida.State = dsInactive then
    qryUnidadeMedida.Open;

  if qryStatusProduto.State = dsInactive then
    qryStatusProduto.Open;
end;

procedure TfrmProduto.grdDadosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TfrmProduto.qryListarAfterOpen(DataSet: TDataSet);
begin

end;

procedure TfrmProduto.qryListarDTCADASTROGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  //    FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);
  aText := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);
end;

procedure TfrmProduto.qryListarDTCADASTROSetText(Sender: TField;
  const aText: string);
begin

end;

procedure TfrmProduto.btnNovaCategoriaClick(Sender: TObject);
begin
  frmCategoria := TfrmCategoria.Create(self);
  frmCategoria.ShowModal;
  FreeAndNil(frmCategoria);

  qryCategoria.Close;
  qryCategoria.Open;

  ListarTodos;
end;

procedure TfrmProduto.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProduto.edtEstoqueMaximoChange(Sender: TObject);
begin
  edtEstoqueMaximo.Formatar(TFormato.Valor);
end;

procedure TfrmProduto.edtEstoqueMinimoChange(Sender: TObject);
begin
  edtEstoqueMinimo.Formatar(TFormato.Valor);
end;

procedure TfrmProduto.edtEstoqueMinimoXChange(Sender: TObject);
begin

end;

procedure TfrmProduto.edtQuantidadeEmEstoqueChange(Sender: TObject);
begin
  edtQuantidadeEmEstoque.Formatar(TFormato.Valor);
end;

procedure TfrmProduto.edtValorDeCustoChange(Sender: TObject);
begin
  edtValorDeCusto.Formatar(TFormato.Valor);
end;

procedure TfrmProduto.edtValorDeVendaChange(Sender: TObject);
begin
  edtValorDeVenda.Formatar(TFormato.Valor);
end;

procedure TfrmProduto.btnNovaSubcategoriaClick(Sender: TObject);
begin
  frmSubcategoria := TfrmSubcategoria.Create(self);
  frmSubcategoria.ShowModal;
  FreeAndNil(frmSubcategoria);

  qrySubcategoria.Close;
  qrySubcategoria.Open;

  ListarTodos;
end;

procedure TfrmProduto.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Produto';

  GetDadosTabela;
end;

procedure TfrmProduto.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Produtos';
end;

procedure TfrmProduto.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmProduto.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Produtos';
end;

procedure TfrmProduto.btnNovaUnidadeMedidaClick(Sender: TObject);
begin
  frmUnidadeMedida := TfrmUnidadeMedida.Create(self);
  frmUnidadeMedida.ShowModal;
  FreeAndNil(frmUnidadeMedida);

  qryUnidadeMedida.Close;
  qryUnidadeMedida.Open;

  ListarTodos;
end;

procedure TfrmProduto.btnNovoClick(Sender: TObject);
begin
  idProduto   := 0;
  cOperacao   := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtNomeProduto.SetFocus;

  Caption := 'Inclusão de Produto';
end;

procedure TfrmProduto.btnNovoFornecedorClick(Sender: TObject);
begin
  frmFornecedor := TfrmFornecedor.Create(self);
  frmFornecedor.ShowModal;
  FreeAndNil(frmFornecedor);

  qryFornecedor.Close;
  qryFornecedor.Open;

  ListarTodos;
end;

procedure TfrmProduto.ListarTodos;
const
  cSQLConsultar : String = 'SELECT pro.idproduto, pro.nomeProduto, pro.categoria,                                                          '+
                           '       pro.subcategoria, pro.fornecedor, pro.unidadeMedida,                                                    '+
                           '       pro.estoqueMin, pro.estoqueMax, pro.qtdeEmEstoque,                                                      '+
                           '       pro.valorCusto, pro.valorVenda, pro.dtCadastro,                                                         '+
                           '       pro.status, cat.categoriaDescr, sub.subcategoriaDescr,                                                  '+
                           '       forn.nomeFornecedor, uni.nomeUnidadeMedida, spr.nomeStatusProduto                                       '+
                           ' FROM  produtos pro                                                                                            '+
                           ' INNER JOIN categorias cat on (pro.categoria = cat.idCategoria)                                                '+
                           ' INNER JOIN subcategorias sub on (pro.subcategoria = sub.idSubcategoria and pro.categoria = sub.categoria)     '+
                           ' INNER JOIN fornecedores forn on (pro.fornecedor = forn.idfornecedor)                                          '+
                           ' INNER JOIN unidadesMedida uni on (pro.unidadeMedida = uni.idUnidadeMedida)                                    '+
                           ' INNER JOIN statusProdutos spr on (pro.status = spr.idStatusProduto)                                           '+
                           ' order BY pro.nomeProduto                                                                                      ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmProduto.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idProduto        := qryListar.FieldByName('idproduto').AsInteger;
  end;
end;

procedure TfrmProduto.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idProduto                   := qryListar.FieldByName('idProduto').AsInteger;

    edtNomeProduto.Text         := trim(qryListar.FieldByName('nomeProduto').AsString);
    lkpCategoria.KeyValue       := qryListar.FieldByName('categoria').AsInteger;
    lkpSubcategoria.KeyValue    := qryListar.FieldByName('subcategoria').AsInteger;
    lkpFornecedor.KeyValue      := qryListar.FieldByName('fornecedor').AsInteger;
    lkpUnidadeMedida.KeyValue   := qryListar.FieldByName('unidadeMedida').AsInteger;

    edtEstoqueMinimo.Text       := trim(CurrToStr(qryListar.FieldByName('estoqueMin').AsCurrency * 100));
    edtEstoqueMaximo.Text       := trim(CurrToStr(qryListar.FieldByName('estoqueMax').AsCurrency * 100));
    edtQuantidadeEmEstoque.Text := trim(CurrToStr(qryListar.FieldByName('qtdeEmEstoque').AsCurrency * 100));
    edtValorDeCusto.Text        := trim(CurrToStr(qryListar.FieldByName('valorCusto').AsCurrency * 100));
    edtValorDeVenda.Text        := trim(CurrToStr(qryListar.FieldByName('valorVenda').AsCurrency * 100));

    lkpStatusProduto.KeyValue   := qryListar.FieldByName('status').AsInteger;

    edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);
  end;
end;

procedure TfrmProduto.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO produtos (                '+
                            '       nomeProduto, categoria,        '+
                            '       subcategoria, fornecedor,      '+
                            '       unidadeMedida, estoqueMin,     '+
                            '       estoqueMax, qtdeEmEstoque,     '+
                            '       valorCusto, valorVenda,        '+
                            '       dtCadastro, status             '+
                            ' ) VALUES (                           '+
                            '       :PnomeProduto, :Pcategoria,    '+
                            '       :Psubcategoria, :Pfornecedor,  '+
                            '       :PunidadeMedida, :PestoqueMin, '+
                            '       :PestoqueMax, :PqtdeEmEstoque, '+
                            '       :PvalorCusto, :PvalorVenda,    '+
                            '       :PdtCadastro, :Pstatus         '+
                            ' )                                    ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeProduto').AsString    := trim(edtNomeProduto.Text);
    QryManutencao.ParamByName('Pcategoria').AsInteger     := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('PsubCategoria').AsInteger  := lkpSubcategoria.KeyValue;
    QryManutencao.ParamByName('Pfornecedor').AsInteger    := lkpFornecedor.KeyValue;
    QryManutencao.ParamByName('PunidadeMedida').AsInteger := lkpUnidadeMedida.KeyValue;

    QryManutencao.ParamByName('PestoqueMin').AsDouble     := uUtils.IIF(edtEstoqueMinimo.Text = EmptyStr, 0.00, StrToFloat(edtEstoqueMinimo.Text));
    QryManutencao.ParamByName('PestoqueMax').AsDouble     := uUtils.IIF(edtEstoqueMaximo.Text = EmptyStr, 0.00, StrToFloat(edtEstoqueMaximo.Text));
    QryManutencao.ParamByName('PqtdeEmEstoque').AsDouble  := uUtils.IIF(edtQuantidadeEmEstoque.Text = EmptyStr, 0.00, StrToFloat(edtQuantidadeEmEstoque.Text));
    QryManutencao.ParamByName('PvalorCusto').AsDouble     := uUtils.IIF(edtValorDeCusto.Text = EmptyStr, 0.00, StrToFloat(edtValorDeCusto.Text));
    QryManutencao.ParamByName('PvalorVenda').AsDouble     := uUtils.IIF(edtValorDeVenda.Text = EmptyStr, 0.00, StrToFloat(edtValorDeVenda.Text));

    QryManutencao.ParamByName('Pstatus').AsInteger        := lkpStatusProduto.KeyValue;
    QryManutencao.ParamByName('PdtCadastro').AsDateTime   := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmProduto.Alterar;
const
  cSQLManutencao : String = 'UPDATE produtos SET                   '+
                            '       nomeProduto=:PnomeProduto,     '+
                            '       categoria=:Pcategoria,         '+
                            '       subcategoria=:Psubcategoria,   '+
                            '       fornecedor=:Pfornecedor,       '+
                            '       unidadeMedida=:PunidadeMedida, '+
                            '       estoqueMin=:PestoqueMin,       '+
                            '       estoqueMax=:PestoqueMax,       '+
                            '       qtdeEmEstoque=:PqtdeEmEstoque, '+
                            '       valorCusto=:PvalorCusto,       '+
                            '       valorVenda=:PvalorVenda,       '+
                            '       status=:Pstatus                '+
                            ' WHERE                                '+
                            ' idProduto=:PidProduto                ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeProduto').AsString    := trim(edtNomeProduto.Text);
    QryManutencao.ParamByName('Pcategoria').AsInteger     := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('PsubCategoria').AsInteger  := lkpSubcategoria.KeyValue;
    QryManutencao.ParamByName('Pfornecedor').AsInteger    := lkpFornecedor.KeyValue;
    QryManutencao.ParamByName('PunidadeMedida').AsInteger := lkpUnidadeMedida.KeyValue;

    QryManutencao.ParamByName('PestoqueMin').AsInteger    := uUtils.IIF(edtEstoqueMinimo.Text = EmptyStr, 0.00, StrToFloat(edtEstoqueMinimo.Text));
    QryManutencao.ParamByName('PestoqueMax').AsInteger    := uUtils.IIF(edtEstoqueMaximo.Text = EmptyStr, 0.00, StrToFloat(edtEstoqueMaximo.Text));
    QryManutencao.ParamByName('PqtdeEmEstoque').AsInteger := uUtils.IIF(edtQuantidadeEmEstoque.Text = EmptyStr, 0.00, StrToFloat(edtQuantidadeEmEstoque.Text));
    QryManutencao.ParamByName('PvalorCusto').AsInteger    := uUtils.IIF(edtValorDeCusto.Text = EmptyStr, 0.00, StrToFloat(edtValorDeCusto.Text));
    QryManutencao.ParamByName('PvalorVenda').AsInteger    := uUtils.IIF(edtValorDeVenda.Text = EmptyStr, 0.00, StrToFloat(edtValorDeVenda.Text));

    QryManutencao.ParamByName('Pstatus').AsInteger        := lkpStatusProduto.KeyValue;
    QryManutencao.ParamByName('PidProduto').AsInteger     := idProduto;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmProduto.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM produtos         '+
                            ' WHERE idProduto=:PidProduto ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão do produto ' +
       UpperCase(trim(qryListar.FieldByName('nomeProduto').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidProduto').AsInteger := idProduto;;
      QryManutencao.ExecSQL;

      ListarTodos;

      MessageDlg('Exclusão realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Exclusão.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end;
end;

end.

