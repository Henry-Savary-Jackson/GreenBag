unit Signup_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, DMUnit_u, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Imaging.pngimage, System.Threading, Vcl.Buttons,
  System.generics.collections, ActiveX;

type
  TfrmSignUp = class(TForm)
    rgpUser: TRadioGroup;
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtCertification: TEdit;
    lblLogin: TLabel;
    lblCertificationCode: TLabel;
    lblHomeAddress: TLabel;
    redHomeAddress: TRichEdit;
    imgPfp: TImage;
    pnlHelp: TPanel;
    spnHelp: TSpeedButton;
    pnlLogin: TPanel;
    btnSignIn: TSpeedButton;
    pnlSignUp: TPanel;
    btnSignUp: TSpeedButton;
    procedure btnLoginScreenClick(Sender: TObject);
    procedure btnSignUpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgpUserClick(Sender: TObject);
    procedure imgPfpClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;

implementation

uses
  Login_u, BrowseItems_u, HelpScreen_u;

{$R *.dfm}

procedure TfrmSignUp.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmSignUp.btnLoginScreenClick(Sender: TObject);
begin
  frmSignUp.Hide;
  frmLogin.Show;
end;

procedure TfrmSignUp.btnSignUpClick(Sender: TObject);
var
  UserId, userName, password, homeaddress, userType, certificationCode: string;

begin

  // input gathering and validation
  userName := edtUsername.Text;
  if userName = '' then
  begin
    showMessage('Please enter a Username.');
    Exit;
  end;

  if length(userName) > 30 then
  begin
    showMessage('Username must be less than 30 characters.');
    Exit;
  end;

  password := edtPassword.Text;
  if password = '' then
  begin
    showMessage('Please enter a password.');
    Exit;
  end;

  // hanlde password input validation
  case DataModule1.securePassword(password) of
    DataModule1.noSpecial:
      begin
        showMessage('Your password must have atleast one special character.');
        Exit;

      end;
    DataModule1.noNums:
      begin
        showMessage('Your password must have atleast one number.');
        Exit;

      end;
    DataModule1.tooShort:
      begin
        showMessage('Your password must have be atleast 8 characters long.');
        Exit;

      end;
  end;

  homeaddress := redHomeAddress.Text;

  if homeaddress = '' then
  begin
    showMessage('Please enter a Home Address.');
    Exit;
  end;

  if rgpUser.ItemIndex = -1 then
  begin
    showMessage('Please select your user type.');
    Exit;
  end;

  case rgpUser.ItemIndex of
    0:
      userType := 'SELLER';
    1:
      userType := 'BUYER';
  end;

  certificationCode := edtCertification.Text;

  if rgpUser.ItemIndex = 0 then
  begin
    if certificationCode = '' then
    begin
      showMessage('Please enter a certification code.');
      Exit;
    end;

    if not(length(certificationCode) = 10) then
    begin
      showMessage('Certificaiton Code can only be 10 characters long.');
      Exit;
    end;

  end;

  if imgPfp.Picture.Graphic = Nil then
  begin
    showMessage('Please choose a profile picture');
    Exit;
  end;

  btnSignUp.Enabled := false;
  TTask.Run(
    procedure
    begin
      try
        try
          CoInitialize(nil);
          // try to create user
          DataModule1.SignUp(userName, password, userType, homeaddress,
            certificationCode, imgPfp);

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

          tthread.Synchronize(nil,
            procedure
            begin
              DataModule1.tmCheckCartExpired.Enabled := true;

              frmSignUp.Hide;
              frmBrowse.Show;
            end);

          couninitialize();

        except
          on e: Exception do
          begin
            // more user friendly
            if e.Message = 'The changes you requested to the table were not successful because they would create duplicate value'
            then
            begin
              showMessage('Username already in use.');
              Exit;
            end;
            showMessage(e.Message);
          end;

        end;
      finally
        // ensure to reenable button regardless of exceptions
        btnSignUp.Enabled := true;
      end
    end);

end;

procedure TfrmSignUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

// allow for pressing enter while focusing on tedits to sign up
procedure TfrmSignUp.FormKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    btnSignUp.Click;
  end;
end;

procedure TfrmSignUp.imgPfpClick(Sender: TObject);
begin
  DataModule1.loadImageFromFile(imgPfp, self);

end;

procedure TfrmSignUp.rgpUserClick(Sender: TObject);
begin
  edtCertification.Enabled := rgpUser.ItemIndex = 0
end;


end.
