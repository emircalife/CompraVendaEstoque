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
var
  cPath : String;
  cDatabase : String;
begin
  cPath     := ExtractFilePath(ParamStr(0));
  //cDatabase := 'MySQL';
  cDatabase := 'Frebird';
  if cDatabase = 'MySQL'then
  begin
    Conn.LibraryLocation := cPath + 'libmysql.dll';

    Conn.Database := 'estoque';
    Conn.HostName := 'localhost';
    Conn.Catalog  := 'mysql';
    Conn.Password := 'Etcn2676!';
    Conn.User     := 'root';
    Conn.Port     := 3306;
  end else if cDatabase = 'Frebird' then
  begin
    Conn.LibraryLocation := cPath + 'libmysql.dll';

    Conn.Database := cPath + 'DB\estoque.fdb';
    Conn.HostName := 'localhost';
    Conn.Catalog  := 'Firebird';
    Conn.Password := 'masterkey';
    Conn.User     := 'SYSDBA';
    Conn.Port     := 3050;
  end;

  Conn.Protocol   := Conn.Catalog;
  Conn.Connected  := true;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
    Conn.Connected := false;
end;

end.

