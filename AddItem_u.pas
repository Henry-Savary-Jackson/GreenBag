unit AddItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfrmAddItem = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddItem: TfrmAddItem;

implementation

{$R *.dfm}

procedure TfrmAddItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
