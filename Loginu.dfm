object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 303
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object lblUsername: TLabel
    Left = 40
    Top = 43
    Width = 82
    Height = 18
    Caption = 'Username'
  end
  object lblPassword: TLabel
    Left = 40
    Top = 91
    Width = 79
    Height = 18
    Caption = 'Password'
  end
  object lblSignUp: TLabel
    Left = 55
    Top = 216
    Width = 192
    Height = 18
    Caption = 'Don'#39't have an account? '
  end
  object edtPassword: TEdit
    Left = 136
    Top = 88
    Width = 161
    Height = 26
    TabOrder = 0
    Text = 'password1+'
  end
  object edtUsername: TEdit
    Left = 128
    Top = 40
    Width = 169
    Height = 26
    TabOrder = 1
    Text = 'User2'
  end
  object btnSignIn: TButton
    Left = 128
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Sign In'
    TabOrder = 2
    OnClick = btnSignInClick
  end
  object btnSignUpScreen: TButton
    Left = 113
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Sign Up'
    TabOrder = 3
    OnClick = btnSignUpScreenClick
  end
end
