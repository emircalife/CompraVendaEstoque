unit uEmpresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, DBCtrls, ZDataset, uDM, uUtils, DB, Buttons, Grids;

type

  { TfrmEmpresa }

  TfrmEmpresa = class(TForm)
    btnAdicionarImagem: TBitBtn;
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    chkWhatsapp: TCheckBox;
    dsUF: TDataSource;
    dsListar: TDataSource;
    edtCEP: TMaskEdit;
    edtContato: TEdit;
    edtEmail: TEdit;
    edtTelefone: TMaskEdit;
    edtNomeFantasia: TEdit;
    edtDtCadastro: TMaskEdit;
    edtEndereco: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtComplemento: TEdit;
    edtNumero: TEdit;
    edtRazaoSocial: TEdit;
    grdDados: TDBGrid;
    imglstWhatsappGrid: TImageList;
    imgLogo: TImage;
    lblCEP: TLabel;
    lblContato: TLabel;
    lblEmail: TLabel;
    lblTelefone: TLabel;
    lblComplemento: TLabel;
    lblNumero: TLabel;
    lblUF: TLabel;
    lblEndereco1: TLabel;
    lblCidade: TLabel;
    lblNomeFantasia: TLabel;
    lblDtCadastro: TLabel;
    lblEndereco: TLabel;
    lblRazaoSocial: TLabel;
    lblCNPJ: TLabel;
    edtCNPJ: TMaskEdit;
    lkpUF: TDBLookupComboBox;
    odImagem: TOpenDialog;
    pnlBotoes: TPanel;
    qryUF: TZQuery;
    qryListar: TZQuery;
    rgpTipoTelefone: TRadioGroup;
    procedure btnAdicionarImagemClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDesfazerClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure rgpTipoTelefoneClick(Sender: TObject);
  private
    idEmpresa : Integer;
    cOperacao : String; //(I)ncluir, (A)lterar, (C)onsultar
    procedure changeTipoTelefone;
    procedure getId;
    procedure GetDadosTabela;
    procedure ListarTodos;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
  public

  end;

var
  frmEmpresa: TfrmEmpresa;

implementation

{$R *.lfm}

{ TfrmEmpresa }

procedure TfrmEmpresa.changeTipoTelefone;
begin
  case rgpTipoTelefone.ItemIndex of
    0: edtTelefone.EditMask := '(99) 99999-9999;1;_';
    1: edtTelefone.EditMask := '(99) 9999-9999;1;_';
  end;
end;

procedure TfrmEmpresa.rgpTipoTelefoneClick(Sender: TObject);
begin
  changeTipoTelefone;
end;

procedure TfrmEmpresa.FormCreate(Sender: TObject);
begin

end;

procedure TfrmEmpresa.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  if qryUF.State = dsInactive then
    qryUF.Open;

  cOperacao := 'C';
end;

procedure TfrmEmpresa.grdDadosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if UpperCase(trim(Column.FieldName)) = 'WHATSAPP' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);

    imglstWhatsappGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, -1);

    if UpperCase(trim(Column.Field.AsString)) = 'S' then // Cadastro está ativo
      imglstWhatsappGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +30,Rect.Top +3, 0);
  end;
end;

procedure TfrmEmpresa.btnAdicionarImagemClick(Sender: TObject);
begin
  if odImagem.Execute then
    if FileExists(odImagem.FileName) then
      imgLogo.Picture.LoadFromFile(odImagem.FileName);
end;

procedure TfrmEmpresa.btnAlterarClick(Sender: TObject);
begin
    cOperacao   := 'A';
  Caption     := 'Alteração de Empresa';

  GetDadosTabela;
end;

procedure TfrmEmpresa.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Empresas';
end;

procedure TfrmEmpresa.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmEmpresa.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Empresas';
end;

procedure TfrmEmpresa.btnNovoClick(Sender: TObject);
begin
  idEmpresa := 0;
  cOperacao   := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtCNPJ.SetFocus;

  Caption := 'Inclusão de Empresa';
end;

procedure TfrmEmpresa.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEmpresa.ListarTodos;
const
  cSQLConsultar : String = 'SELECT emp.idempresa, emp.nomeFantasia,           '+
                           '        emp.razaoSocial, emp.cnpj,                '+
                           '        emp.bairro, emp.cep, emp.cidade,          '+
                           '        emp.uf, emp.complemento,                  '+
                           '        emp.nomeContato, emp.email,               '+
                           '        emp.endereco, emp.numero,                 '+
                           '        emp.dtCadastro, emp.telefone,             '+
                           '        emp.whatsapp, emp.logo,                   '+
                           '        emp.dtCadastro                            '+
                           '  FROM empresas emp                               '+
                           '  INNER JOIN ufs uf ON (emp.uf = uf.idUf)         '+
                           '  ORDER BY emp.nomeFantasia, emp.razaoSocial      ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmEmpresa.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idEmpresa                 := qryListar.FieldByName('idEmpresa').AsInteger;
    edtDtCadastro.Text        := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    edtRazaoSocial.Text       := qryListar.FieldByName('razaoSocial').AsString;
    edtNomeFantasia.Text      := qryListar.FieldByName('nomeFantasia').AsString;
    edtCNPJ.Text              := qryListar.FieldByName('cnpj').AsString;
    edtBairro.Text            := qryListar.FieldByName('bairro').AsString;
    edtCEP.Text               := qryListar.FieldByName('cep').AsString;
    edtCidade.Text            := qryListar.FieldByName('cidade').AsString;
    lkpUF.KeyValue            := qryListar.FieldByName('uf').AsInteger;
    edtComplemento.Text       := qryListar.FieldByName('complemento').AsString;
    edtContato.Text           := qryListar.FieldByName('nomeContato').AsString;
    edtEmail.Text             := qryListar.FieldByName('email').AsString;
    edtEndereco.Text          := qryListar.FieldByName('endereco').AsString;
    edtNumero.Text            := qryListar.FieldByName('numero').AsString;
    rgpTipoTelefone.ItemIndex := uUtils.IIf(Trim(qryListar.FieldByName('telefone').AsString).Length = 15, 0, 1);
    edtTelefone.Text          := qryListar.FieldByName('telefone').AsString;
    chkWhatsapp.Checked       := uUtils.IIf(qryListar.FieldByName('whatsapp').AsString = 'S', True, False);

    if FileExists(trim(qryListar.FieldByName('logo').AsString)) then
    begin
      odImagem.FileName       := qryListar.FieldByName('logo').AsString;
      imgLogo.Picture.LoadFromFile(odImagem.FileName);
    end
    else
    begin
      odImagem.FileName := '';
      imgLogo.Picture.Clear;
    end;
  end;
end;

procedure TfrmEmpresa.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idEmpresa := qryListar.FieldByName('idEmpresa').AsInteger;
  end;
end;

procedure TfrmEmpresa.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO empresas (           '+
                            '    idempresa, nomeFantasia,     '+
                            '    razaoSocial, cnpj,           '+
                            '    bairro, cep, cidade,         '+
                            '    uf, complemento,             '+
                            '    nomeContato, email,          '+
                            '    endereco, numero,            '+
                            '    dtCadastro, telefone,        '+
                            '    whatsapp, logo               '+
                            ' ) VALUES (                      '+
                            '    :Pidempresa, :PnomeFantasia, '+
                            '    :PrazaoSocial, :Pcnpj,       '+
                            '    :Pbairro, :Pcep, :Pcidade,   '+
                            '    :Puf, :Pcomplemento,         '+
                            '    :PnomeContato, :Pemail,      '+
                            '    :Pendereco, :Pnumero,        '+
                            '    :PdtCadastro, :Ptelefone,    '+
                            '    :Pwhatsapp, :Plogo           '+
                            ' )                               ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PrazaoSocial').AsString  := trim(edtRazaoSocial.Text);
    QryManutencao.ParamByName('PnomeFantasia').AsString := trim(edtNomeFantasia.Text);
    QryManutencao.ParamByName('Pcnpj').AsString         := edtCNPJ.Text;
    QryManutencao.ParamByName('Pbairro').AsString       := edtBairro.Text;
    QryManutencao.ParamByName('Pcep').AsString          := edtCEP.Text;
    QryManutencao.ParamByName('Pcidade').AsString       := edtCidade.Text;
    QryManutencao.ParamByName('Puf').AsInteger          := lkpUF.KeyValue;
    QryManutencao.ParamByName('Pcomplemento').AsString  := edtComplemento.Text;
    QryManutencao.ParamByName('PnomeContato').AsString  := edtContato.Text;
    QryManutencao.ParamByName('Pemail').AsString        := edtEmail.Text;
    QryManutencao.ParamByName('Pendereco').AsString     := edtEndereco.Text;
    QryManutencao.ParamByName('Pnumero').AsString       := edtNumero.Text;
    QryManutencao.ParamByName('Ptelefone').AsString     := edtTelefone.Text;
    QryManutencao.ParamByName('Pwhatsapp').AsString     := IIF(chkWhatsapp.Checked, 'S', 'N');

    if trim(odImagem.FileName) <> EmptyStr then
       QryManutencao.ParamByName('Plogo').AsString      := odImagem.FileName
    else
       QryManutencao.ParamByName('Plogo').AsString      := '';

    QryManutencao.ParamByName('PdtCadastro').AsDateTime := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmEmpresa.Alterar;
const
  cSQLManutencao : String = 'UPDATE empresas SET               '+
                            '    nomeFantasia =:PnomeFantasia, '+
                            '    razaoSocial =:PrazaoSocial,   '+
                            '    cnpj =:Pcnpj,                 '+
                            '    bairro =:Pbairro,             '+
                            '    cep =:Pcep,                   '+
                            '    cidade =:Pcidade,             '+
                            '    uf =:Puf,                     '+
                            '    complemento =:Pcomplemento,   '+
                            '    nomeContato =:PnomeContato,   '+
                            '    email =:Pemail,               '+
                            '    endereco =:Pendereco,         '+
                            '    numero =:Pnumero,             '+
                            '    telefone =:Ptelefone,         '+
                            '    whatsapp =:Pwhatsapp,         '+
                            '    logo =:Plogo                  '+
                            ' WHERE                            '+
                            ' idEmpresa =:PidEmpresa           ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PrazaoSocial').AsString  := trim(edtRazaoSocial.Text);
    QryManutencao.ParamByName('PnomeFantasia').AsString := trim(edtNomeFantasia.Text);
    QryManutencao.ParamByName('Pcnpj').AsString         := edtCNPJ.Text;
    QryManutencao.ParamByName('Pbairro').AsString       := edtBairro.Text;
    QryManutencao.ParamByName('Pcep').AsString          := edtCEP.Text;
    QryManutencao.ParamByName('Pcidade').AsString       := edtCidade.Text;
    QryManutencao.ParamByName('Puf').AsInteger          := lkpUF.KeyValue;
    QryManutencao.ParamByName('Pcomplemento').AsString  := edtComplemento.Text;
    QryManutencao.ParamByName('PnomeContato').AsString  := edtContato.Text;
    QryManutencao.ParamByName('Pemail').AsString        := edtEmail.Text;
    QryManutencao.ParamByName('Pendereco').AsString     := edtEndereco.Text;
    QryManutencao.ParamByName('Pnumero').AsString       := edtNumero.Text;
    QryManutencao.ParamByName('Ptelefone').AsString     := edtTelefone.Text;
    QryManutencao.ParamByName('Pwhatsapp').AsString     := IIF(chkWhatsapp.Checked, 'S', 'N');

    if trim(odImagem.FileName) <> EmptyStr then
       QryManutencao.ParamByName('Plogo').AsString      := odImagem.FileName
    else
       QryManutencao.ParamByName('Plogo').AsString      := '';

    QryManutencao.ParamByName('PidEmpresa').AsInteger   := idEmpresa;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmEmpresa.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM empresas          '+
                            ' WHERE idEmpresa =:PidEmpresa ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da Empresa ' +
       UpperCase(trim(qryListar.FieldByName('razaoSocial').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidEmpresa').AsInteger := idEmpresa;
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

