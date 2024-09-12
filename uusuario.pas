unit uUsuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, ZDataset, Buttons, DBCtrls, uUtils, uDM;

type

  { TfrmUsuario }

  TfrmUsuario = class(TForm)
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    dsNivelAcesso: TDataSource;
    dsListar: TDataSource;
    edtUsuario: TEdit;
    edtDtCadastro: TMaskEdit;
    edtSenha: TEdit;
    edtRepitaSenha: TEdit;
    grdDados: TDBGrid;
    lblNivelAcesso: TLabel;
    lblUsuario: TLabel;
    lblDtCadastro: TLabel;
    lblSenha: TLabel;
    lblRepitaSenha: TLabel;
    lkpNivelAcesso: TDBLookupComboBox;
    pnlBotoes: TPanel;
    qryNivelAcesso: TZQuery;
    qryListar: TZQuery;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtRepitaSenhaDblClick(Sender: TObject);
    procedure edtSenhaChange(Sender: TObject);
    procedure edtSenhaDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    idUsuario : Integer;
    cOperacao : String; //(I)ncluir, (A)lterar, (C)onsultar
    procedure ListarTodos;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
    procedure GetDadosTabela;
    procedure getId;
    function ValidaSenha(cSenha, cRepitaSenha : String) : Boolean;
  public

  end;

var
  frmUsuario: TfrmUsuario;

implementation

{$R *.lfm}

{ TfrmUsuario }

procedure TfrmUsuario.FormCreate(Sender: TObject);
begin

end;

procedure TfrmUsuario.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  cOperacao := 'C';

  if qryNivelAcesso.State = dsInactive then
    qryNivelAcesso.Open;
end;

procedure TfrmUsuario.btnNovoClick(Sender: TObject);
begin
  idUsuario := 0;
  cOperacao := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtUsuario.SetFocus;

  Caption := 'Inclusão de Usuário';
end;

procedure TfrmUsuario.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuario.edtRepitaSenhaDblClick(Sender: TObject);
begin
  if edtRepitaSenha.PasswordChar = #0 then
    edtRepitaSenha.PasswordChar := '*'
  else
    edtRepitaSenha.PasswordChar := #0;
end;

procedure TfrmUsuario.edtSenhaChange(Sender: TObject);
begin

end;

procedure TfrmUsuario.edtSenhaDblClick(Sender: TObject);
begin

end;

procedure TfrmUsuario.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Usuário';

  GetDadosTabela;
end;

procedure TfrmUsuario.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Usuários';
end;

procedure TfrmUsuario.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmUsuario.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Usuários';
end;

function TfrmUsuario.ValidaSenha(cSenha, cRepitaSenha : String) : Boolean;
var
  llSenhaOk : Boolean;

begin
  llSenhaOk := false;

  if (cSenha <> EmptyStr) and (cRepitaSenha <> EmptyStr) then
    llSenhaOk := true;

  if cSenha = cRepitaSenha then
    llSenhaOk := true;

  result := llSenhaOk;
end;

procedure TfrmUsuario.ListarTodos;
const
  cSQLConsultar : String = 'SELECT usu.idUsuario,                             '+
                           '      usu.nomeUsuario,                            '+
                           '      usu.senhaUsuario,                           '+
                           '      usu.nivelAcesso,                            '+
                           '      niv.nomeNivelAcesso,                        '+
                           '       DATE_FORMAT(usu.dtCadastro, ''%d/%m/%Y'')  '+
                           '                   as dtCadastro                  '+
                           ' FROM estoque.usuarios usu                        '+
                           ' INNER JOIN estoque.niveisAcesso niv              '+
                           '         ON (usu.nivelAcesso = niv.idNivelAcesso) '+
                           ' WHERE niv.statusNivelAcesso = ''A''              ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmUsuario.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idUsuario               := qryListar.FieldByName('idUsuario').AsInteger;
    edtDtCadastro.Text      := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    lkpNivelAcesso.KeyValue := qryListar.FieldByName('nivelAcesso').AsInteger;
    edtUsuario.Text         := trim(qryListar.FieldByName('nomeUsuario').AsString);
  end;
end;

procedure TfrmUsuario.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idUsuario               := qryListar.FieldByName('idUsuario').AsInteger;
  end;
end;

procedure TfrmUsuario.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO estoque.usuarios (                  '+
                            ' nomeUsuario, senhaUsuario, nivelAcesso,        '+
                            ' dtCadastro                                     '+
                            ' ) VALUES (                                     '+
                            ' :PnomeUsuario, :PsenhaUsuario, :PnivelAcesso,  '+
                            ' :PdtCadastro                                   '+
                            ' )                                              ';

var
  QryManutencao : TZQuery;
begin
  if ValidaSenha(trim(edtSenha.Text), trim(edtRepitaSenha.Text)) then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PnomeUsuario').AsString  := trim(edtUsuario.Text);
      QryManutencao.ParamByName('PsenhaUsuario').AsString := uUtils.Criptografar(trim(edtSenha.Text));
      QryManutencao.ParamByName('PnivelAcesso').AsInteger := lkpNivelAcesso.KeyValue;
      QryManutencao.ParamByName('PdtCadastro').AsDateTime := now;
      QryManutencao.ExecSQL;

      ListarTodos;

      MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end
  else
      MessageDLG('Inclusão não realizada!!! ' + #13#10 +
           'As senhas não são iguais, por favor, corrija.', mtError, [mbOk], 0);
end;

procedure TfrmUsuario.Alterar;
const
  cSQLManutencao : String = 'UPDATE estoque.usuarios SET   '+
                            ' nomeUsuario =:PnomeUsuario,  '+
                            ' senhaUsuario =:PsenhaUsuario '+
                            ' nivelAcesso =:PnivelAcesso   '+
                            ' WHERE                        '+
                            ' idUsuario =:PidUsuario       ';

var
  QryManutencao : TZQuery;
begin
  if ValidaSenha(trim(edtSenha.Text), trim(edtRepitaSenha.Text)) then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PnomeUsuario').AsString  := trim(edtUsuario.Text);
      QryManutencao.ParamByName('PsenhaUsuario').AsString := uUtils.Criptografar(trim(edtSenha.Text));
      QryManutencao.ParamByName('PnivelAcesso').AsInteger := lkpNivelAcesso.KeyValue;
      QryManutencao.ParamByName('PidUsuario').AsInteger   := idUsuario;
      QryManutencao.ExecSQL;

      ListarTodos;

      MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
    except
      MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
    end;

    FreeAndNil(QryManutencao);
  end
  else
      MessageDLG('Alteração não realizada!!! ' + #13#10 +
           'As senhas não são iguais, por favor, corrija.', mtError, [mbOk], 0);
end;

procedure TfrmUsuario.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM estoque.usuarios '+
                            ' WHERE                       '+
                            ' idUsuario =:PidUsuario      ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão do Usuário ' +
       UpperCase(trim(qryListar.FieldByName('nomeUsuario').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidUsuario').AsInteger := idUsuario;
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

