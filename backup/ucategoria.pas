unit uCategoria;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBExtCtrls, DBGrids,
  StdCtrls, MaskEdit, ExtCtrls, Buttons, uDM, uUtils, DB, ZDataset,
  ZAbstractRODataset;

type

  { TfrmCategoria }

  TfrmCategoria = class(TForm)
    btnDesfazer: TBitBtn;
    btnSair: TBitBtn;
    btnGravar: TBitBtn;
    btnExcluir: TBitBtn;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    dsListar: TDataSource;
    grdDados: TDBGrid;
    edtCategoria: TEdit;
    lblDtCadastro: TLabel;
    lblCategoria: TLabel;
    edtDtCadastro: TMaskEdit;
    pnlBotoes: TPanel;
    qryListar: TZQuery;
    qryListarCATEGORIADESCR: TZRawStringField;
    qryListarDTCADASTRO: TZDateTimeField;
    qryListarIDCATEGORIA: TZIntegerField;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dsListarDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlBotoesClick(Sender: TObject);
    procedure qryListarDTCADASTROGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
  private
    idCategoria : Integer;
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
  frmCategoria: TfrmCategoria;

implementation

{$R *.lfm}

{ TfrmCategoria }

procedure TfrmCategoria.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCategoria.dsListarDataChange(Sender: TObject; Field: TField);
begin
end;

procedure TfrmCategoria.FormCreate(Sender: TObject);                                        
begin

end;

procedure TfrmCategoria.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  cOperacao := 'C';
end;

procedure TfrmCategoria.pnlBotoesClick(Sender: TObject);
begin

end;

procedure TfrmCategoria.qryListarDTCADASTROGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);
end;

procedure TfrmCategoria.btnNovoClick(Sender: TObject);
begin
  idCategoria := 0;
  cOperacao   := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtCategoria.SetFocus;

  Caption := 'Inclusão de Categoria';
end;

procedure TfrmCategoria.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Categorias';
end;

procedure TfrmCategoria.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Categoria';

  GetDadosTabela;
end;

procedure TfrmCategoria.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmCategoria.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Categorias';
end;

procedure TfrmCategoria.ListarTodos;
const
  cSQLConsultar : String = 'SELECT idCategoria, categoriaDescr,          '+
                           '       dtCadastro                            '+
                           ' FROM categorias                             '+
                           ' order BY categoriaDescr                     ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmCategoria.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idCategoria        := qryListar.FieldByName('idCategoria').AsInteger;
  end;
end;

procedure TfrmCategoria.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idCategoria        := qryListar.FieldByName('idCategoria').AsInteger;
    edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    edtCategoria.Text  := trim(qryListar.FieldByName('categoriaDescr').AsString);
  end;
end;

procedure TfrmCategoria.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO categorias (          '+
                            ' categoriaDescr, dtCadastro       '+
                            ' ) VALUES (                       '+
                            ' :PcategoriaDescr, :PdtCadastro   '+
                            ' )                                ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PcategoriaDescr').AsString := trim(edtCategoria.Text);
    QryManutencao.ParamByName('PdtCadastro').AsDateTime   := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCategoria.Alterar;
const
  cSQLManutencao : String = 'UPDATE categorias SET             '+
                            ' categoriaDescr =:PcategoriaDescr '+
                            ' WHERE                            '+
                            ' idCategoria =:PidCategoria       ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PcategoriaDescr').AsString := trim(edtCategoria.Text);
    QryManutencao.ParamByName('PidCategoria').AsInteger   := idCategoria;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCategoria.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM categorias            '+
                            ' WHERE idCategoria =:PidCategoria ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da categoria ' +
       UpperCase(trim(qryListar.FieldByName('categoriaDescr').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if uUtils.isCategoriaComSubcategoria(qryListar.FieldByName('idCategoria').AsInteger) then
    begin
      MessageDlg('Há categoria(s) cadastrada(s) com essa subcategoria, '+
                 'portanto não pode ser excluída.', mtError, [mbOk], 0);
      Exit;
    end
    else if isCategoriaOuSubcategoriaComProduto(qryListar.FieldByName('idCategoria').AsInteger, 0) then
    begin
      MessageDlg('Há produto(s) cadastrado(s) com essa categoria, '+
                       'portanto não pode ser excluída.', mtError, [mbOk], 0);
      Exit;
    end;
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidCategoria').AsInteger := idCategoria;;
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

