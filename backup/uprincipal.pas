unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  Buttons, ComCtrls, uUtils, uCategoria;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnClientes: TBitBtn;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Separator1: TMenuItem;
    mnuMenu: TMainMenu;
    pnlBotoes: TPanel;
    stsPrincipal: TStatusBar;
    tmrPrincipal: TTimer;
    procedure btnClientesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure tmrPrincipalTimer(Sender: TObject);
  private

  public
    cUsuarioLogado : String;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.tmrPrincipalTimer(Sender: TObject);
begin
  stsPrincipal.Panels[0].Text :=  FormatDateTime('dddd dd/mm/yyyy', now);
  stsPrincipal.Panels[1].Text :=  TimeToStr(now);
  stsPrincipal.Panels[2].Text :=  'Olá, ' + cUsuarioLogado + '. Seja bem-vindo!';
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

end;

procedure TfrmPrincipal.MenuItem4Click(Sender: TObject);
begin
  frmCategoria := TfrmCategoria.Create(self);
  frmCategoria.ShowModal;
  FreeAndNil(frmCategoria);
end;

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin

end;

end.

