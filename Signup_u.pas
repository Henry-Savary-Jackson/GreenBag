unit Signup_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, DMUnit_u, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Buttons, System.generics.collections;

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
    function verifyCertificationCode(code: string): integer;
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
      showMessage('Certificaiton Code must be less than 10 characters.');
      Exit;
    end;

    case verifyCertificationCode(certificationCode) of
      DataModule1.notInFile:
        begin
          showMessage
            ('Your certification code doesn''t exist. Please correctly enter your code. If that doesn''t work, please ensure you have properly applied to be a seller.');
          Exit;

        end;
      DataModule1.invalidChar:
        begin
          showMessage('Your certification code must only consist of numbers.');
          Exit;
        end;
    end;

  end;

  if imgPfp.Picture.Graphic = Nil then
  begin
    showMessage('Please choose a profile picture');
    Exit;
  end;

  try
    // try to create user
    DataModule1.SignUp(userName, password, userType, homeaddress,
      certificationCode, imgPfp);


    try
      DataModule1.getCartItems(DataModule1.userName, DataModule1.jwtToken);

    except
      on e: Exception do
      begin
        if e.Message.Equals('User doesn''t have a cart.') then
          DataModule1.CreateUserCart(DataModule1.userName,
            DataModule1.jwtToken);

      end;

    end;

    frmSignUp.Hide;
    frmBrowse.Show;

  except
    on e: exception do
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



// make sure the verification code was in the text file
function TfrmSignUp.verifyCertificationCode(code: string): integer;
var
  i: integer;
  fFile: textfile;
  sLine: string;
begin

  for i := 1 to 10 do
  begin
    if pos(code[i], DataModule1.nums) = 0 then
    begin
      Result := DataModule1.invalidChar;
      Exit;
    end;
  end;

  Result := DataModule1.notInFile;

  if fileExists('SellerCertificationCodes.txt') then
  begin
    AssignFile(fFile, 'SellerCertificationCodes.txt');
    reset(fFile);

    while not eof(fFile) do
    begin
      readln(fFile, sLine);
      if sLine = code then
      begin
        Result := DataModule1.success;
        CloseFile(fFile);
        Exit;
      end;

    end;

    CloseFile(fFile);

  end
  else
  begin;
    AssignFile(fFile, 'SellerCertificationCodes.txt');
    ReWrite(fFile);
    CloseFile(fFile);

  end;

end;

end.
