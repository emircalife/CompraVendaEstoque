unit uFornecedor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, DBCtrls, ZDataset, uDM, uUtils, DB, Buttons, Grids;

type

  { TfrmFornecedor }

  TfrmFornecedor = class(TForm)
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
    edtCNPJ: TMaskEdit;
    edtComplemento: TEdit;
    edtEmail: TEdit;
    edtMediaDiasEntrega: TEdit;
    edtEndereco: TEdit;
    edtFornecedor: TEdit;
    edtDtCadastro: TMaskEdit;
    edtContato: TEdit;
    edtNumero: TEdit;
    edtTelefone: TMaskEdit;
    grdDados: TDBGrid;
    imglstWhatsappGrid: TImageList;
    lblCEP: TLabel;
    lblCidade: TLabel;
    lblCNPJ: TLabel;
    lblComplemento: TLabel;
    lblEmail: TLabel;
    lblMediaDiasEntrega: TLabel;
    lblEndereco: TLabel;
    lblEndereco1: TLabel;
    lblFornecedor: TLabel;
    lblDtCadastro: TLabel;
    lblContato: TLabel;
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
    procedure grdDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    var
      idfornecedor : Integer;
      cOperacao    : String;

    procedure ListarTodos;
    procedure getId;
    procedure GetDadosTabela;
    procedure Incluir;
    procedure Alterar;
    procedure Excluir;
  public

  end;

var
  frmFornecedor: TfrmFornecedor;

implementation

{$R *.lfm}

{ TfrmFornecedor }

procedure TfrmFornecedor.FormCreate(Sender: TObject);
begin

end;

procedure TfrmFornecedor.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  if qryUF.State = dsInactive then
    qryUF.Open;

  cOperacao := 'C';
end;

procedure TfrmFornecedor.grdDadosDrawColumnCell(Sender: TObject;
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

procedure TfrmFornecedor.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFornecedor.btnNovoClick(Sender: TObject);
begin
  idfornecedor := 0;
  cOperacao   := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtCNPJ.SetFocus;

  Caption := 'Inclusão de Fornecedor';
end;

procedure TfrmFornecedor.btnAlterarClick(Sender: TObject);
begin
  cOperacao   := 'A';
  Caption     := 'Alteração de Fornecedor';

  GetDadosTabela;
end;

procedure TfrmFornecedor.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  cOperacao          := 'C';
  edtDtCadastro.Text := '';
  Caption            := 'Fornecedores';
end;

procedure TfrmFornecedor.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmFornecedor.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Fornecedores';
end;

procedure TfrmFornecedor.ListarTodos;
const
  cSQLConsultar : String = 'select forn.idfornecedor,                         '+
                           '       forn.nomeFornecedor,                       '+
                           '       forn.cep,                                  '+
                           '       forn.endereco,                             '+
                           '       forn.numero,                               '+
                           '       forn.bairro,                               '+
                           '       forn.cidade,                               '+
                           '       forn.complemento,                          '+
                           '       forn.uf,                                   '+
                           '       forn.cnpj,                                 '+
                           '       forn.contato,                              '+
                           '       forn.diasParaEntrega,                      '+
                           '       forn.email,                                '+
                           '       forn.telefone,                             '+
                           '       forn.whatsapp,                             '+
                           '       DATE_FORMAT(forn.dtCadastro, ''%d/%m/%Y'') '+
                           '                         as dtCadastro,           '+
                           '       uf.nomeUf                                  '+
                           ' FROM estoque.fornecedores forn                   '+
                           ' INNER JOIN estoque.ufs uf ON (forn.uf = uf.idUf) '+
                           ' ORDER BY forn.nomeFornecedor                     ';

begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmFornecedor.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idfornecedor := qryListar.FieldByName('idfornecedor').AsInteger;
  end;
end;

procedure TfrmFornecedor.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idfornecedor              := qryListar.FieldByName('idfornecedor').AsInteger;

    edtFornecedor.Text        := trim(qryListar.FieldByName('nomeFornecedor').AsString);
    edtCEP.Text               := trim(qryListar.FieldByName('cep').AsString);
    edtEndereco.Text          := trim(qryListar.FieldByName('endereco').AsString);
    edtNumero.Text            := trim(qryListar.FieldByName('numero').AsString);
    edtBairro.Text            := trim(qryListar.FieldByName('bairro').AsString);
    edtCidade.Text            := trim(qryListar.FieldByName('cidade').AsString);
    edtComplemento.Text       := trim(qryListar.FieldByName('complemento').AsString);
    lkpUF.KeyValue            := qryListar.FieldByName('uf').AsInteger;
    edtCNPJ.Text              := trim(qryListar.FieldByName('cnpj').AsString);
    edtContato.Text           := trim(qryListar.FieldByName('contato').AsString);
    edtMediaDiasEntrega.Text  := trim(IntToStr(qryListar.FieldByName('diasParaEntrega').AsInteger));
    edtEmail.Text             := trim(qryListar.FieldByName('email').AsString);
    edtTelefone.Text          := trim(qryListar.FieldByName('telefone').AsString);
    rgpTipoTelefone.ItemIndex := uUtils.IIf(Trim(qryListar.FieldByName('telefone').AsString).Length = 15, 0, 1);
    chkWhatsapp.Checked       := uUtils.IIf(qryListar.FieldByName('whatsapp').AsString = 'S', True, False);

    edtDtCadastro.Text        := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);
  end;
end;

procedure TfrmFornecedor.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO estoque.fornecedores (               '+
                            '        nomeFornecedor, cep, endereco,           '+
                            '        numero, bairro, cidade,                  '+
                            '        complemento, uf, cnpj, contato,          '+
                            '        diasParaEntrega, email, telefone,        '+
                            '        whatsapp, dtCadastro                     '+
                            ' ) VALUES (                                      '+
                            '        :PnomeFornecedor, :Pcep, :Pendereco,     '+
                            '        :Pnumero, :Pbairro, :Pcidade,            '+
                            '        :Pcomplemento, :Puf, :Pcnpj, :Pcontato,  '+
                            '        :PdiasParaEntrega, :Pemail, :Ptelefone,  '+
                            '        :Pwhatsapp, :PdtCadastro                 '+
                            ' )                                               ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeFornecedor').AsString    := trim(edtFornecedor.Text);
    QryManutencao.ParamByName('Pcep').AsString               := trim(edtCEP.Text);
    QryManutencao.ParamByName('Pendereco').AsString          := trim(edtEndereco.Text);
    QryManutencao.ParamByName('Pnumero').AsString            := trim(edtNumero.Text);
    QryManutencao.ParamByName('Pbairro').AsString            := trim(edtBairro.Text);
    QryManutencao.ParamByName('Pcidade').AsString            := trim(edtCidade.Text);
    QryManutencao.ParamByName('Pcomplemento').AsString       := trim(edtComplemento.Text);
    QryManutencao.ParamByName('Puf').AsInteger               := lkpUF.KeyValue;
    QryManutencao.ParamByName('Pcnpj').AsString              := trim(edtCNPJ.Text);
    QryManutencao.ParamByName('Pcontato').AsString           := trim(edtContato.Text);

    QryManutencao.ParamByName('PdiasParaEntrega').AsInteger  := uUtils.IIF(trim(edtMediaDiasEntrega.Text) = '', 0, StrToInt(trim(edtMediaDiasEntrega.Text)));
    QryManutencao.ParamByName('Pemail').AsString             := trim(edtEmail.Text);
    QryManutencao.ParamByName('Ptelefone').AsString          := trim(edtTelefone.Text);
    QryManutencao.ParamByName('Pwhatsapp').AsString          := uUtils.IIF(chkWhatsapp.Checked, 'S', 'N');
    QryManutencao.ParamByName('PdtCadastro').AsDateTime      := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmFornecedor.Alterar;
const
  cSQLManutencao : String = 'UPDATE estoque.fornecedores SET                  '+
                            '       nomeFornecedor =:PnomeFornecedor,         '+
                            '       cep =:Pcep,                               '+
                            '       endereco =:Pendereco,                     '+
                            '       numero =:Pnumero,                         '+
                            '       bairro =:Pbairro,                         '+
                            '       cidade =:Pcidade,                         '+
                            '       complemento =:Pcomplemento,               '+
                            '       uf =:Puf,                                 '+
                            '       cnpj =:pcnpj,                             '+
                            '       contato =:Pcontato,                       '+
                            '       diasParaEntrega =:PdiasParaEntrega,       '+
                            '       email =:Pemail,                           '+
                            '       telefone =:Ptelefone,                     '+
                            '       whatsapp =:Pwhatsapp                      '+
                            ' WHERE                                           '+
                            '  idFornecedor =:PidFornecedor                   ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeFornecedor').AsString    := trim(edtFornecedor.Text);
    QryManutencao.ParamByName('Pcep').AsString               := trim(edtCEP.Text);
    QryManutencao.ParamByName('Pendereco').AsString          := trim(edtEndereco.Text);
    QryManutencao.ParamByName('Pnumero').AsString            := trim(edtNumero.Text);
    QryManutencao.ParamByName('Pbairro').AsString            := trim(edtBairro.Text);
    QryManutencao.ParamByName('Pcidade').AsString            := trim(edtCidade.Text);
    QryManutencao.ParamByName('Pcomplemento').AsString       := trim(edtComplemento.Text);
    QryManutencao.ParamByName('Puf').AsString                := lkpUF.KeyValue;
    QryManutencao.ParamByName('Pcnpj').AsString              := trim(edtCNPJ.Text);
    QryManutencao.ParamByName('Pcontato').AsString           := trim(edtContato.Text);
    QryManutencao.ParamByName('PdiasParaEntrega').AsString   := IIF(trim(edtMediaDiasEntrega.Text) = EmptyStr, 0, StrToInt(trim(edtMediaDiasEntrega.Text)));
    QryManutencao.ParamByName('Pemail').AsString             := trim(edtEmail.Text);
    QryManutencao.ParamByName('Ptelefone').AsString          := trim(edtTelefone.Text);
    QryManutencao.ParamByName('Pwhatsapp').AsString          := IIF(chkWhatsapp.Checked, 'S', 'N');
    QryManutencao.ParamByName('PidFornecedor').AsInteger     := idFornecedor;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmFornecedor.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM estoque.fornecedores '+
                            ' WHERE                           '+
                            ' idFornecedor =:PidFornecedor    ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão do fornecedor ' +
       UpperCase(trim(qryListar.FieldByName('nomeFornecedor').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidFornecedor').AsInteger := idFornecedor;;
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

