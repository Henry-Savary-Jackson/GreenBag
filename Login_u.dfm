object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderWidth = 3
  Caption = 'Login'
  ClientHeight = 357
  ClientWidth = 660
  Color = 11074992
  Font.Charset = ANSI_CHARSET
  Font.Color = 16384
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 18
  object lblUsername: TLabel
    Left = 31
    Top = 67
    Width = 82
    Height = 18
    Caption = 'Username'
    Color = 16384
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblPassword: TLabel
    Left = 31
    Top = 115
    Width = 79
    Height = 18
    Caption = 'Password'
    Color = 16384
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblSignUp: TLabel
    Left = 62
    Top = 224
    Width = 192
    Height = 18
    Caption = 'Don'#39't have an account? '
    Color = 16384
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object edtPassword: TEdit
    Left = 116
    Top = 112
    Width = 172
    Height = 26
    Color = 8249222
    TabOrder = 0
    Text = 'okay'
    OnKeyDown = edtPasswordKeyDown
  end
  object edtUsername: TEdit
    Left = 119
    Top = 64
    Width = 169
    Height = 26
    Color = 8380296
    TabOrder = 1
    Text = 'lolkek4'
    OnKeyDown = edtPasswordKeyDown
  end
  object pnlHelp: TPanel
    Left = 258
    Top = 0
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 2
    OnClick = btnHelpClick
    object spnHelp: TSpeedButton
      Left = 2
      Top = 2
      Width = 56
      Height = 29
      Align = alClient
      Caption = '?'
      Flat = True
      OnClick = btnHelpClick
      ExplicitLeft = 10
      ExplicitTop = 4
    end
  end
  object pnlLogin: TPanel
    Left = 120
    Top = 169
    Width = 81
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 3
    OnClick = btnHelpClick
    object sbtnSignIn: TSpeedButton
      Left = 2
      Top = 2
      Width = 77
      Height = 29
      Align = alClient
      Caption = 'Sign In'
      Flat = True
      OnClick = btnSignInClick
      ExplicitTop = 4
    end
  end
  object pnlSignup: TPanel
    Left = 114
    Top = 272
    Width = 81
    Height = 33
    BorderWidth = 1
    Color = 8380296
    ParentBackground = False
    TabOrder = 4
    OnClick = btnHelpClick
    object sbtnSignUp: TSpeedButton
      Left = 2
      Top = 2
      Width = 77
      Height = 29
      Align = alClient
      Caption = 'Sign Up'
      Flat = True
      OnClick = btnSignUpScreenClick
      ExplicitTop = 4
    end
  end
  object Button1: TButton
    Left = 241
    Top = 277
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 5
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 328
    Top = 112
    Width = 664
    Height = 237
    TabOrder = 6
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = 16384
    TitleFont.Height = -16
    TitleFont.Name = 'Arial Rounded MT Bold'
    TitleFont.Style = []
  end
end
