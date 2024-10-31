unit uCliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, DBCtrls, ZDataset, Buttons, uDM, uUtils;

type

  { TfrmCliente }

  TfrmCliente = class(TForm)
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    chkWhatsapp: TCheckBox;
    dsListar: TDataSource;
    dsUF: TDataSource;
    edtBairro: TEdit;
    edtCEP: TMaskEdit;
    edtCidade: TEdit;
    edtCpf: TMaskEdit;
    edtComplemento: TEdit;
    edtDtCadastro: TMaskEdit;
    edtEmail: TEdit;
    edtEndereco: TEdit;
    edtCliente: TEdit;
    edtNumero: TEdit;
    edtTelefone: TMaskEdit;
    grdDados: TDBGrid;
    lblCEP: TLabel;
    lblCidade: TLabel;
    lblCpf: TLabel;
    lblComplemento: TLabel;
    lblDtCadastro: TLabel;
    lblEmail: TLabel;
    lblEndereco: TLabel;
    lblEndereco1: TLabel;
    lblCliente: TLabel;
    lblNumero: TLabel;
    lblTelefone: TLabel;
    lblUF: TLabel;
    lkpUF: TDBLookupComboBox;
    pnlBotoes: TPanel;
    qryListar: TZQuery;
    qryUF: TZQuery;
    rgpTipoTelefone: TRadioGroup;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    var
      idCliente : Integer;
      cOperacao : String;
    procedure ListarTodos;
    procedure getId;
    procedure GetDadosTabela;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
  public

  end;

var
  frmCliente: TfrmCliente;

implementation

{$R *.lfm}

{ TfrmCliente }

procedure TfrmCliente.FormCreate(Sender: TObject);
begin

end;

procedure TfrmCliente.btnNovoClick(Sender: TObject);
begin
  idCliente   := 0;
  cOperacao   := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtCpf.SetFocus;

  Caption := 'Inclusão de Cliente';
end;

procedure TfrmCliente.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCliente.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Cliente';

  GetDadosTabela;
end;

procedure TfrmCliente.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Clientes';
end;

procedure TfrmCliente.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmCliente.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Clientes';
end;

procedure TfrmCliente.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  if qryUF.State = dsInactive then
    qryUF.Open;

//  lkpUF.ListField := 'PE';
  cOperacao := 'C';
end;


procedure TfrmCliente.ListarTodos;
const
  cSQLConsultar : String = 'select cli.idCliente,                            '+
                           '       cli.nomeCliente,                          '+
                           '       cli.cep,                                  '+
                           '       cli.endereco,                             '+
                           '       cli.numero,                               '+
                           '       cli.bairro,                               '+
                           '       cli.cidade,                               '+
                           '       cli.complemento,                          '+
                           '       cli.uf,                                   '+
                           '       cli.cpf,                                  '+
                           '       cli.email,                                '+
                           '       cli.telefone,                             '+
                           '       cli.whatsapp,                             '+
                           '       cli.dtCadastro,                           '+
                           '       uf.nomeUf                                 '+
                           ' FROM clientes cli                               '+
                           ' INNER JOIN ufs uf ON (cli.uf = uf.idUf)         '+
                           ' ORDER BY cli.nomeCliente                        ';

begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmCliente.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idCliente := qryListar.FieldByName('idCliente').AsInteger;
  end;
end;

procedure TfrmCliente.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idCliente                 := qryListar.FieldByName('idCliente').AsInteger;
    edtDtCadastro.Text        := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    edtCpf.Text               := trim(qryListar.FieldByName('cpf').AsString);
    edtCliente.Text           := trim(qryListar.FieldByName('nomeCliente').AsString);
    edtCEP.Text               := trim(qryListar.FieldByName('cep').AsString);
    edtEndereco.Text          := trim(qryListar.FieldByName('endereco').AsString);
    edtNumero.Text            := trim(qryListar.FieldByName('numero').AsString);
    edtComplemento.Text       := trim(qryListar.FieldByName('complemento').AsString);
    edtBairro.Text            := trim(qryListar.FieldByName('bairro').AsString);
    edtCidade.Text            := trim(qryListar.FieldByName('cidade').AsString);
    lkpUF.KeyValue            := qryListar.FieldByName('uf').AsInteger;
    edtTelefone.Text          := trim(qryListar.FieldByName('telefone').AsString);
    rgpTipoTelefone.ItemIndex := uUtils.IIf(Trim(qryListar.FieldByName('telefone').AsString).Length = 15, 0, 1);
    chkWhatsapp.Checked       := uUtils.IIf(qryListar.FieldByName('whatsapp').AsString = 'S', True, False);
  end;
end;

procedure TfrmCliente.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO clientes (                           '+
                            '        nomeCliente, cep, endereco,              '+
                            '        numero, bairro, cidade,                  '+
                            '        complemento, uf, cpf, email,             '+
                            '        telefone, whatsapp, dtCadastro           '+
                            ' ) VALUES (                                      '+
                            '        :PnomeCliente, :Pcep, :Pendereco,        '+
                            '        :Pnumero, :Pbairro, :Pcidade,            '+
                            '        :Pcomplemento, :Puf, :Pcpf, :Pemail,     '+
                            '        :Ptelefone, :Pwhatsapp, :PdtCadastro     '+
                            ' )                                               ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeCliente').AsString       := trim(edtCliente.Text);
    QryManutencao.ParamByName('Pcep').AsString               := trim(edtCEP.Text);
    QryManutencao.ParamByName('Pendereco').AsString          := trim(edtEndereco.Text);
    QryManutencao.ParamByName('Pnumero').AsString            := trim(edtNumero.Text);
    QryManutencao.ParamByName('Pbairro').AsString            := trim(edtBairro.Text);
    QryManutencao.ParamByName('Pcidade').AsString            := trim(edtCidade.Text);
    QryManutencao.ParamByName('Pcomplemento').AsString       := trim(edtComplemento.Text);
    QryManutencao.ParamByName('Puf').AsString                := lkpUF.KeyValue;
    QryManutencao.ParamByName('Pcpf').AsString               := trim(edtCpf.Text);
    QryManutencao.ParamByName('Pemail').AsString             := trim(edtEmail.Text);
    QryManutencao.ParamByName('Ptelefone').AsString          := trim(edtTelefone.Text);
    QryManutencao.ParamByName('Pwhatsapp').AsString          := IIF(chkWhatsapp.Checked, 'S', 'N');
    QryManutencao.ParamByName('PdtCadastro').AsDateTime      := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCliente.Alterar;
const
  cSQLManutencao : String = 'UPDATE clientes SET                              '+
                            '       nomeCliente =:PnomeCliente,               '+
                            '       cep =:Pcep,                               '+
                            '       endereco =:Pendereco,                     '+
                            '       numero =:Pnumero,                         '+
                            '       bairro =:Pbairro,                         '+
                            '       cidade =:Pcidade,                         '+
                            '       complemento =:Pcomplemento,               '+
                            '       uf =:Puf,                                 '+
                            '       cnpj =:pcnpj,                             '+
                            '       email =:Pemail,                           '+
                            '       telefone =:Ptelefone,                     '+
                            '       whatsapp =:Pwhatsapp                      '+
                            ' WHERE                                           '+
                            '   idCliente =:PidCliente                        ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeCliente').AsString       := trim(edtCliente.Text);
    QryManutencao.ParamByName('Pcep').AsString               := trim(edtCEP.Text);
    QryManutencao.ParamByName('Pendereco').AsString          := trim(edtEndereco.Text);
    QryManutencao.ParamByName('Pnumero').AsString            := trim(edtNumero.Text);
    QryManutencao.ParamByName('Pbairro').AsString            := trim(edtBairro.Text);
    QryManutencao.ParamByName('Pcidade').AsString            := trim(edtCidade.Text);
    QryManutencao.ParamByName('Pcomplemento').AsString       := trim(edtComplemento.Text);
    QryManutencao.ParamByName('Puf').AsString                := lkpUF.KeyValue;
    QryManutencao.ParamByName('Pcpf').AsString               := trim(edtCpf.Text);
    QryManutencao.ParamByName('Pemail').AsString             := trim(edtEmail.Text);
    QryManutencao.ParamByName('Ptelefone').AsString          := trim(edtTelefone.Text);
    QryManutencao.ParamByName('Pwhatsapp').AsString          := IIF(chkWhatsapp.Checked, 'S', 'N');
    QryManutencao.ParamByName('PidCliente').AsInteger        := idCliente;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmCliente.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM clientes    '+
                            ' WHERE                  '+
                            ' idCliente =:PidCliente ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão do cliente ' +
       UpperCase(trim(qryListar.FieldByName('nomeCliente').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidCliente').AsInteger := idCliente;;
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

