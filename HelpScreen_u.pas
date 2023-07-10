unit HelpScreen_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmHelp = class(TForm)
    memHelp: TMemo;
    pnlBack: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    frmPrevious: TForm;
  end;

var
  frmHelp: TfrmHelp;

implementation

uses
  DMUnit_U;

{$R *.dfm}

procedure TfrmHelp.btnBackClick(Sender: TObject);
begin
  self.Hide;
  frmPrevious.Show;
end;

procedure TfrmHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  try
    try
      DataModule1.CancelCart(DataModule1.CartID);

    except
      on e: exception do
      begin
        showMessage(e.Message);
      end;

    end;

  finally
    Application.Terminate;
  end;
end;

end.
