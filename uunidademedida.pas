unit uUnidadeMedida;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  MaskEdit, ExtCtrls, ZDataset, ZAbstractRODataset, Buttons, uUtils, uDM;

type

  { TfrmUnidadeMedida }

  TfrmUnidadeMedida = class(TForm)
    btnAlterar: TBitBtn;
    btnDesfazer: TBitBtn;
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    dsListar: TDataSource;
    edtUnidadeMedida: TEdit;
    edtDtCadastro: TMaskEdit;
    edtSigla: TEdit;
    grdDados: TDBGrid;
    lblUnidadeMedida: TLabel;
    lblDtCadastro: TLabel;
    lblSigla: TLabel;
    pnlBotoes: TPanel;
    qryListar: TZQuery;
    qryListarDTCADASTRO: TZDateTimeField;
    qryListarIDUNIDADEMEDIDA: TZIntegerField;
    qryListarNOMEUNIDADEMEDIDA: TZRawStringField;
    qryListarSIGLAUNIDADEMEDIDA: TZRawStringField;
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
    idUnidadeMedida : Integer;
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
  frmUnidadeMedida: TfrmUnidadeMedida;

implementation

{$R *.lfm}

{ TfrmUnidadeMedida }

procedure TfrmUnidadeMedida.FormCreate(Sender: TObject);
begin

end;

procedure TfrmUnidadeMedida.FormShow(Sender: TObject);
begin
  ListarTodos;

  uUtils.limpaCampos(self);

  cOperacao := 'C';
end;

procedure TfrmUnidadeMedida.pnlBotoesClick(Sender: TObject);
begin

end;

procedure TfrmUnidadeMedida.qryListarDTCADASTROGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);
end;

procedure TfrmUnidadeMedida.dsListarDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfrmUnidadeMedida.btnNovoClick(Sender: TObject);
begin
  idUnidadeMedida := 0;
  cOperacao       := 'I';

  uUtils.limpaCampos(self);

  edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', now);

  edtUnidadeMedida.SetFocus;

  Caption := 'Inclusão de Unidade de Medida';
end;

procedure TfrmUnidadeMedida.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUnidadeMedida.btnAlterarClick(Sender: TObject);
begin
  cOperacao := 'A';
  Caption   := 'Alteração de Unidade de Medida';

  GetDadosTabela;
end;

procedure TfrmUnidadeMedida.btnDesfazerClick(Sender: TObject);
begin
  uUtils.limpaCampos(self);
  edtDtCadastro.Text := '';
  cOperacao          := 'C';
  Caption            := 'Unidades de Medida';
end;

procedure TfrmUnidadeMedida.btnExcluirClick(Sender: TObject);
begin
  getId;
  Excluir;
end;

procedure TfrmUnidadeMedida.btnGravarClick(Sender: TObject);
begin
  if cOperacao = 'I' then
    Incluir
  else if cOperacao = 'A' then
    Alterar;

  uUtils.limpaCampos(self);

  Caption := 'Unidades de Medida';
end;

procedure TfrmUnidadeMedida.ListarTodos;
const
  cSQLConsultar : String = 'SELECT uni.idUnidadeMedida,                       '+
                           '       uni.nomeUnidadeMedida,                     '+
                           '       uni.siglaUnidadeMedida,                    '+
                           '       uni.dtCadastro                             '+
                           ' FROM unidadesMedida uni                          '+
                           ' ORDER BY nomeUnidadeMedida                       ';
begin
  try
    qryListar.Close;
    qryListar.SQL.Clear;
    qryListar.SQL.Add(cSQLConsultar);
    qryListar.Open;
  except
  end;
end;

procedure TfrmUnidadeMedida.GetDadosTabela;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idUnidadeMedida       := qryListar.FieldByName('idUnidadeMedida').AsInteger;
    edtDtCadastro.Text    := FormatDateTime('dd/mm/yyyy', qryListar.FieldByName('dtCadastro').AsDateTime);

    edtUnidadeMedida.Text := trim(qryListar.FieldByName('nomeUnidadeMedida').AsString);
    edtSigla.Text         := trim(qryListar.FieldByName('siglaUnidadeMedida').AsString);
  end;
end;

procedure TfrmUnidadeMedida.getId;
begin
  if (qryListar.State <> dsInactive) and (qryListar.RecordCount >= 1) then
  begin
    idUnidadeMedida       := qryListar.FieldByName('idUnidadeMedida').AsInteger;
  end;
end;

procedure TfrmUnidadeMedida.Incluir;
const
  cSQLManutencao : String = 'INSERT INTO unidadesMedida (                 '+
                            ' nomeUnidadeMedida, siglaUnidadeMedida,      '+
                            ' dtCadastro                                  '+
                            ' ) VALUES (                                  '+
                            ' :PnomeUnidadeMedida, :PsiglaUnidadeMedida,  '+
                            ' :PdtCadastro                                '+
                            ' )                                           ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeUnidadeMedida').AsString  := trim(edtUnidadeMedida.Text);
    QryManutencao.ParamByName('PsiglaUnidadeMedida').AsString := trim(edtSigla.Text);
    QryManutencao.ParamByName('PdtCadastro').AsDateTime       := now;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Inclusão realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Inclusão.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmUnidadeMedida.Alterar;
const
  cSQLManutencao : String = 'UPDATE unidadesMedida SET                 '+
                            ' nomeUnidadeMedida =:PnomeUnidadeMedida,  '+
                            ' siglaUnidadeMedida =:PsiglaUnidadeMedida '+
                            ' WHERE                                    '+
                            ' idUnidadeMedida =:PidUnidadeMedida       ';

var
  QryManutencao : TZQuery;
begin
  try
    QryManutencao:=TZQuery.Create(nil);
    QryManutencao.Connection := DM.Conn;
    QryManutencao.SQL.Add(cSQLManutencao);
    QryManutencao.ParamByName('PnomeUnidadeMedida').AsString  := trim(edtUnidadeMedida.Text);
    QryManutencao.ParamByName('PsiglaUnidadeMedida').AsString := trim(edtSigla.Text);
    QryManutencao.ParamByName('PidUnidadeMedida').AsInteger   := idUnidadeMedida;
    QryManutencao.ExecSQL;

    ListarTodos;

    MessageDlg('Alteração realizada com sucesso.', mtInformation, [mbOk], 0);
  except
    MessageDlg('Erro na Alteração.', mtError, [mbOk], 0);
  end;

  FreeAndNil(QryManutencao);
end;

procedure TfrmUnidadeMedida.Excluir;
const
  cSQLManutencao : String = 'DELETE FROM unidadesMedida          '+
                            ' WHERE                              '+
                            ' idUnidadeMedida =:PidUnidadeMedida ';

var
  QryManutencao : TZQuery;
begin
  if MessageDlg('Confirma a exclusão da Unidade de Medida ' +
       UpperCase(trim(qryListar.FieldByName('nomeUnidadeMedida').AsString)) + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      QryManutencao:=TZQuery.Create(nil);
      QryManutencao.Connection := DM.Conn;
      QryManutencao.SQL.Add(cSQLManutencao);
      QryManutencao.ParamByName('PidUnidadeMedida').AsInteger := idUnidadeMedida;
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

