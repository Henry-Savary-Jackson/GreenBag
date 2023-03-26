unit Loginu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, DMUNIT_u;

type
  TForm2 = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation


{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
DataModule1.UserTB.Open;
end;

end.
