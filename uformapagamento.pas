unit uFormaPagamento;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, ZDataset, Buttons, uUtils, uDM;

type

  { TfrmFormaPagamento }

  TfrmFormaPagamento = class(TForm)
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    dsListar: TDataSource;
    edtDtCadastro: TMaskEdit;
    edtFormaPagamento: TEdit;
    grdDados: TDBGrid;
    lblDtCadastro: TLabel;
    lblFormaPagamento: TLabel;
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
    idFormaPagamento: Integer;
    cOperacao   : String; //(I)ncluir, (A)lterar, (C)onsultar
    procedure ListarTodos;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
    procedure getId;
    procedure GetDadosTabela;
  public

  end;

var
  frmFormaPagamento: TfrmFormaPagamento;

implementation

{$R *.lfm}

procedure TfrmFormaPagamento.FormCreate(Sender: TObject);
begin

end;

procedure TfrmFormaPagamento.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  cOperacao := 'C';
end;

procedure TfrmFormaPagamento.dsListarDataChange(Sender: TObject; Field: TField);
begin
end;

procedure TfrmFormaPagamento.btnNovoClick(Sender: TObject);
begin
  idFormaPagamento := 0;
  cOperacao       := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtFormaPagamento.SetFocus;

  Caption := 'Inclusão de forma de Pagamento';
end;

procedure TfrmFormaPagamento.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFormaPagamento.btnAlterarClick(Sender: TObject);
begin
  cOperacao := 'A';
  Caption   := 'Alteração de Forma de Pagamento';

  GetDadosTabela;
end;

procedure TfrmFormaPagamento.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  edtDtCadastro.Text := '';
  cOperacao          := 'C';
  Caption            := 'Formas de Pagamento';
end;

procedure TfrmFormaPagamento.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmFormaPagamento.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'FOrmas de Pagamento';
end;

procedure TfrmFormaPagamento.ListarTodos;
const
  cSQLConsultar : String = 'SELECT idFormaPagamento,                     '+
                           '       NomeFormaPagamento,                   '+
                           '       DATE_FORMAT(dtCadastro, ''%d/%m/%Y'') '+
                           '                   as dtCadastro             '+
                           ' FROM estoque.formasPagamento                '+
                           ' ORDER BY NomeFormaPagamento                 ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmFormaPagamento.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idFormaPagamento           := qryListar.FieldByName('idFormaPagamento').AsInteger;
    edtDtCadastro.Text         := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    edtFormaPagamento.Text := trim(qryListar.FieldByName('NomeFormaPagamento').AsString);
  end;
end;

procedure TfrmFormaPagamento.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idFormaPagamento := qryListar.FieldByName('idFormaPagamento').AsInteger;
  end;
end;

procedure TfrmFormaPagamento.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO estoque.formasPagamento( '+
                            ' NomeFormaPagamento, dtCadastro      '+
                            ' ) VALUES (                          '+
                            ' :PNomeFormaPagamento, :PdtCadastro  '+
                            ' )                                   ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PNomeFormaPagamento').AsString := trim(edtFormaPagamento.Text);
    QryManutencao.ParamByName('PdtCadastro').AsDateTime       := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmFormaPagamento.Alterar;
const
  cSQLManutencao : String = 'UPDATE estoque.formasPagamento SET        '+
                            ' NomeFormaPagamento =:PNomeFormaPagamento '+
                            ' WHERE                                    '+
                            ' idFormaPagamento =:PidFormaPagamento     ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PNomeFormaPagamento').AsString  := trim(edtFormaPagamento.Text);
    QryManutencao.ParamByName('PidFormaPagamento').AsInteger   := idFormaPagamento;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmFormaPagamento.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM estoque.formasPagamento   '+
                            ' WHERE                                '+
                            ' idFormaPagamento =:pidFormaPagamento ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da forma de Pagamento ' +
       UpperCase(trim(qryListar.FieldByName('NomeFormaPagamento').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('pidFormaPagamento').AsInteger := idFormaPagamento;
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
