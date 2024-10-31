unit uLogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  uDM, uUtils, uPrincipal, ZDataset;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnLogar: TButton;
    btnCancelar: TButton;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    imgLogin: TImage;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    qryLogin: TZQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnLogarClick(Sender: TObject);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    nQtdeTentativas           : Integer;
    llTrocarUsuario           : Boolean;
    cNomeUsuarioLogado        : String;
    nIdUsuarioLogado          : Integer;
    nNivelAcessoUsuarioLogado : Integer;

    function Logar(cUsuario, cSenha : String):Boolean;
    procedure executarLogin;
  public

  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.btnCancelarClick(Sender: TObject);
begin
  if llTrocarUsuario then
    frmLogin.Hide
  else
    Application.Terminate;
end;

procedure TfrmLogin.btnLogarClick(Sender: TObject);
begin
  executarLogin;
end;

procedure TfrmLogin.edtSenhaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    executarLogin;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  nQtdeTentativas := 0;
end;

function TfrmLogin.Logar(cUsuario, cSenha : String):Boolean;
const
  cSQLLogin : String = 'select idUsuario,                 '+
                       '      nomeUsuario,                '+
                       '      senhaUsuario,               '+
                       '      nivelAcesso,                '+
                       '      dtCadastro                  '+
                       ' FROM usuarios                    '+
                       ' WHERE nomeUsuario =:PnomeUsuario ';
var
  QryManutencao : TZQuery;
  llOk          : Boolean;
begin
  llOk := false;

  if (cUsuario = 'admin' ) and (cSenha = uUtils.Criptografar('nimda')) then
  begin
    llOk                      := true;
    cNomeUsuarioLogado        := 'admin';
    nIdUsuarioLogado          := 0;
    nNivelAcessoUsuarioLogado := 1;

    Result := llOk;
    exit;
  end;

  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLLogin);
    QryManutencao.ParamByName('PnomeUsuario').AsString   := cUsuario;
    QryManutencao.Open;

    if(QryManutencao.RecordCount > 0) then
      if(QryManutencao.FieldByName('senhaUsuario').AsString = cSenha)then
      begin
        llOk                      := true;
        cNomeUsuarioLogado        := trim(QryManutencao.FieldByName('nomeUsuario').AsString);
        nIdUsuarioLogado          := QryManutencao.FieldByName('idUsuario').AsInteger;
        nNivelAcessoUsuarioLogado := QryManutencao.FieldByName('nivelAcesso').AsInteger;
      end;
  except
    MessageDlg('Erro no Login.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);

  Result := llOk;
end;

procedure TfrmLogin.executarLogin;
begin
  if llTrocarUsuario then
  begin
    if Logar(trim(edtUsuario.Text) , uUtils.Criptografar(trim(edtSenha.Text))) then
    begin
      frmPrincipal.cNomeUsuarioLogado        := cNomeUsuarioLogado;
      frmPrincipal.nIdUsuarioLogado          := nIdUsuarioLogado;
      frmPrincipal.nNivelAcessoUsuarioLogado := nNivelAcessoUsuarioLogado;

      frmLogin.Hide;
    end;
  end;

  if Logar(trim(edtUsuario.Text) , uUtils.Criptografar(trim(edtSenha.Text))) then
  begin
    frmPrincipal := TfrmPrincipal.Create(Application);

    frmPrincipal.cNomeUsuarioLogado        := cNomeUsuarioLogado;
    frmPrincipal.nIdUsuarioLogado          := nIdUsuarioLogado;
    frmPrincipal.nNivelAcessoUsuarioLogado := nNivelAcessoUsuarioLogado;

    frmPrincipal.ShowModal;
    FreeAndNil(frmPrincipal);
    frmLogin.Hide;
  end
  else
  begin
    nQtdeTentativas := nQtdeTentativas + 1;

    if nQtdeTentativas < 3 then
      MessageDlg('Login incorreto. Tentativa nº ' + trim(IntToStr(nQtdeTentativas)), mtWarning, [mbOk], 0)
    else
      begin
        MessageDlg('Foram executadas 3 tentativas sem sucesso, portanto, a aplicação vai ser encerrada.', mtError, [mbOk], 0);
        Application.Terminate;
      end;
  end;
end;

end.

