unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDM }

  TDM = class(TDataModule)
    Conn: TZConnection;
    Trans: TZTransaction;
    procedure ConnAfterConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.ConnAfterConnect(Sender: TObject);
begin

end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  Conn.Connected := true;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
    Conn.Connected := false;
end;

end.

