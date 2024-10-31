unit uSubcategoria;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  MaskEdit, DBGrids, DBCtrls, uUtils, uDM, uCategoria, ZDataset, Buttons;

type

  { TfrmSubcategoria }

  TfrmSubcategoria = class(TForm)
    btnNovaCategoria: TBitBtn;
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    dsCategoria: TDataSource;
    lkpCategoria: TDBLookupComboBox;
    dsListar: TDataSource;
    edtSubcategoria: TEdit;
    edtDtCadastro: TMaskEdit;
    grdDados: TDBGrid;
    lblCategoria: TLabel;
    lblCategoria1: TLabel;
    lblDtCadastro: TLabel;
    pnlBotoes: TPanel;
    qryListar: TZQuery;
    qryCategoria: TZQuery;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovaCategoriaClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dsListarDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblCategoriaClick(Sender: TObject);
    procedure lkpCategoriaChange(Sender: TObject);
    procedure pnlBotoesClick(Sender: TObject);
  private
    idSubcategoria : Integer;
    cOperacao   : String; //(I)ncluir, (A)lterar, (C)onsultar
    procedure ListarTodos;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
    procedure GetDadosTabela;
    procedure getId;
  public

  end;

var
  frmSubcategoria: TfrmSubcategoria;

implementation

{$R *.lfm}

{ TfrmSubcategoria }

procedure TfrmSubcategoria.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSubcategoria.btnNovoClick(Sender: TObject);
begin
  idSubcategoria := 0;
  cOperacao      := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  lkpCategoria.SetFocus;

  Caption := 'Inclusão de Subcategoria';
end;

procedure TfrmSubcategoria.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Subcategoria';

  GetDadosTabela;
end;

procedure TfrmSubcategoria.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);

  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Subcategorias';
end;

procedure TfrmSubcategoria.btnExcluirClick(Sender: TObject);
begin
  getid;
  Excluir;
end;

procedure TfrmSubcategoria.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Subcategorias';
end;

procedure TfrmSubcategoria.btnNovaCategoriaClick(Sender: TObject);
begin
  frmCategoria := TfrmCategoria.Create(self);
  frmCategoria.ShowModal;
  FreeAndNil(frmCategoria);

  qryCategoria.Close;
  qryCategoria.Open;

  ListarTodos;
end;

procedure TfrmSubcategoria.dsListarDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfrmSubcategoria.FormCreate(Sender: TObject);
begin

end;

procedure TfrmSubcategoria.FormShow(Sender: TObject);
begin
  uUtils.limpaCampos(self);

  ListarTodos;

  cOperacao := 'C';

  if qryCategoria.State = dsInactive then
    qryCategoria.Open;
end;

procedure TfrmSubcategoria.lblCategoriaClick(Sender: TObject);
begin

end;

procedure TfrmSubcategoria.lkpCategoriaChange(Sender: TObject);
begin

end;

procedure TfrmSubcategoria.pnlBotoesClick(Sender: TObject);
begin

end;

procedure TfrmSubcategoria.ListarTodos;
const
  cSQLConsultar : String = 'select sub.idSubcategoria,                                     '+
                           '       sub.subcategoriaDescr,                                  '+
                           '       sub.categoria,                                          '+
                           '       sub.dtCadastro,                                         '+
                           '       cat.categoriaDescr                                      '+
                           'from subcategorias sub                                         '+
                           'inner join categorias cat on (sub.categoria = cat.idCategoria) '+
                           'order by sub.subcategoriaDescr                                 ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmSubcategoria.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idSubcategoria        := qryListar.FieldByName('idSubcategoria').AsInteger;
    edtDtCadastro.Text    := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    lkpCategoria.KeyValue := qryListar.FieldByName('categoria').AsInteger;
    edtSubcategoria.Text  := trim(qryListar.FieldByName('subcategoriaDescr').AsString);
  end;
end;

procedure TfrmSubcategoria.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idSubcategoria        := qryListar.FieldByName('idSubcategoria').AsInteger;
  end;
end;

procedure TfrmSubcategoria.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO subcategorias (                     '+
                            ' subcategoriaDescr, categoria, dtCadastro       '+
                            ' ) VALUES (                                     '+
                            ' :PsubcategoriaDescr, :Pcategoria, :PdtCadastro '+
                            ' )                                              ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PsubcategoriaDescr').AsString := trim(edtSubcategoria.Text);
    QryManutencao.ParamByName('Pcategoria').asInteger        := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('PdtCadastro').AsDateTime      := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmSubcategoria.Alterar;
const
  cSQLManutencao : String = 'UPDATE subcategorias SET                  '+
                            ' subcategoriaDescr = :PsubcategoriaDescr, '+
                            ' categoria = :Pcategoria                  '+
                            ' WHERE idSubcategoria = :PidSubcategoria  ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PsubcategoriaDescr').AsString := trim(edtSubcategoria.Text);
    QryManutencao.ParamByName('Pcategoria').asInteger        := lkpCategoria.KeyValue;
    QryManutencao.ParamByName('PidSubcategoria').asInteger   := idSubcategoria;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;


procedure TfrmSubcategoria.Excluir;
const
  cSQLManutencao : String = 'DELETE from subcategorias                 '+
                            ' WHERE idSubcategoria = :PidSubcategoria  ';
var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da suncategoria ' +
       UpperCase(trim(qryListar.FieldByName('subcategoriaDescr').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if isCategoriaOuSubcategoriaComProduto(qryListar.FieldByName('categoria').AsInteger, qryListar.FieldByName('idSubcategoria').AsInteger) then
    begin
      MessageDlg('Há produto(s) cadastrado(s) com essa categoria ou sobcategoria, '+
                       'portanto não pode ser excluída.', mtError, [mbOk], 0);
      Exit;
    end;
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidSubcategoria').asInteger   := idSubcategoria;
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

