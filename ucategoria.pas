unit uCategoria;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBExtCtrls, DBGrids,
  StdCtrls, MaskEdit, ExtCtrls, Buttons, uDM, uUtils, DB, ZDataset;

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
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure dsListarDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    idCategoria : Integer;
    cOperacao   : String; //(I)ncluir, (A)lterar, (C)onsultar
    procedure ListarTodos;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
    procedure GetDadosTabela;
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
  GetDadosTabela;
end;

procedure TfrmCategoria.FormCreate(Sender: TObject);
begin

end;

procedure TfrmCategoria.FormShow(Sender: TObject);
begin
  ListarTodos;
  cOperacao := 'C';
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

  edtDtCadastro.Text := '';
  Caption            := 'Categorias';
end;

procedure TfrmCategoria.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Categoria';
end;

procedure TfrmCategoria.btnExcluirClick(Sender: TObject);
begin
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
                           '       DATE_FORMAT(dtCadastro, ''%d/%m/%Y'') '+
                           '             as dtCadastro                   '+
                           ' FROM estoque.Categorias                     '+
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
  cSQLIncluir : String = 'INSERT INTO estoque.Categorias (  '+
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
    QryManutencao.SQL.Add(cSQLIncluir);
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
  cSQLAlterar : String = 'UPDATE estoque.Categorias SET     '+
                         ' categoriaDescr =:PcategoriaDescr '+
                         ' WHERE                            '+
                         ' idCategoria =:PidCategoria       ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLAlterar);
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
  cSQLExcluir : String = 'DELETE FROM estoque.Categorias    '+
                         ' WHERE                            '+
                         ' idCategoria =:PidCategoria       ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da categoria ' +
       UpperCase(trim(qryListar.FieldByName('categoriaDescr').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLExcluir);
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

