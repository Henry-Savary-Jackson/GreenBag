unit Login_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Threading,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  DMUNIT_u,
  Vcl.Mask, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, ActiveX;

type
  TfrmLogin = class(TForm)
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblSignUp: TLabel;
    pnlHelp: TPanel;
    pnlLogin: TPanel;
    btnSignIn: TSpeedButton;
    pnlSignup: TPanel;
    sbtnSignUp: TSpeedButton;
    spnHelp: TSpeedButton;
    procedure btnSignInClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSignUpScreenClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure edtPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  Browseitems_u, HelpScreen_u,
  SignUp_u;

{$R *.dfm}

procedure TfrmLogin.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmLogin.btnSignInClick(Sender: TObject);
var
  userName, userID, password: string;
begin

  // input validation
  userName := edtUsername.Text;
  if userName = '' then
  begin
    showMessage('Please enter a Username.');
    Exit;
  end;

  password := edtPassword.Text;
  if password = '' then
  begin
    showMessage('Please enter a password.');
    Exit;
  end;

  btnSignIn.Enabled := false;
  ttask.run(
    procedure
    begin
      try
        try
          CoInitialize(nil);
          DataModule1.Login(userName, password);

          // create cart is user doesn't have one

          if not DataModule1.usertype.Equals('ADMIN') then
          begin

            try
              DataModule1.getCartItems(DataModule1.userName,
                DataModule1.jwtToken);

            except
              on e: Exception do
              begin
                if e.Message.Equals('User doesn''t have a cart.') then
                  DataModule1.CreateUserCart(DataModule1.userName,
                    DataModule1.jwtToken);

              end;

            end;

          end;

          tthread.Synchronize(nil,
            procedure
            begin
              DataModule1.tmCheckCartExpired.Enabled := true;

              // set global app variables
              frmLogin.Hide;
              frmBrowse.Show;
            end);
          couninitialize();

        except
          on e: Exception do
          begin
            tthread.Synchronize(nil,
              procedure
              begin
                showMessage(e.Message);
              end);
          end;

        end;
      finally
        btnSignIn.Enabled := true;
      end

    end)
end;

procedure TfrmLogin.btnSignUpScreenClick(Sender: TObject);
begin
  frmLogin.Hide;
  frmSignUp.Show;
end;

procedure TfrmLogin.Button2Click(Sender: TObject);
begin
  // AA51811025
end;

// allow pressing enter when typing username or password to make you login
procedure TfrmLogin.edtPasswordKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnSignIn.Click;
  end;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;

end;

end.
