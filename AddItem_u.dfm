object frmAddItem: TfrmAddItem
  Left = 366
  Top = 0
  Caption = 'Add Item'
  ClientHeight = 712
  ClientWidth = 454
  Color = 11074992
  Font.Charset = ANSI_CHARSET
  Font.Color = 16384
  Font.Height = -15
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object imgItem: TImage
    Left = 161
    Top = 24
    Width = 105
    Height = 105
    Center = True
    Stretch = True
    OnClick = imgItemClick
  end
  object lblDesc: TLabel
    Left = 93
    Top = 598
    Width = 89
    Height = 17
    Caption = 'Description:'
  end
  object lblCategory: TLabel
    Left = 108
    Top = 540
    Width = 72
    Height = 17
    Caption = 'Category:'
  end
  object lblCF: TLabel
    Left = 26
    Top = 330
    Width = 199
    Height = 17
    Caption = 'Carbon FootPrint of its use:'
  end
  object lblEU: TLabel
    Left = 41
    Top = 357
    Width = 176
    Height = 17
    Caption = 'Energy Usage of its use:'
  end
  object lblWaterUsage: TLabel
    Left = 53
    Top = 391
    Width = 168
    Height = 17
    Caption = 'Water Usage of its use:'
  end
  object lblPrice: TLabel
    Left = 118
    Top = 216
    Width = 44
    Height = 17
    Caption = 'Price:'
  end
  object lblName: TLabel
    Left = 126
    Top = 174
    Width = 47
    Height = 17
    Caption = 'Name:'
  end
  object lblRating: TLabel
    Left = 130
    Top = 143
    Width = 56
    Height = 17
    Caption = 'Rating: '
  end
  object lblCFProduce: TLabel
    Left = 3
    Top = 432
    Width = 252
    Height = 17
    Caption = 'Carbon FootPrint of its production:'
  end
  object lblEUProduce: TLabel
    Left = 27
    Top = 474
    Width = 224
    Height = 17
    Caption = 'Energy Usage of its production'
  end
  object lblWUProduce: TLabel
    Left = 27
    Top = 510
    Width = 221
    Height = 17
    Caption = 'Water Usage of its production:'
  end
  object lblStock: TLabel
    Left = 118
    Top = 255
    Width = 47
    Height = 17
    Caption = 'Stock:'
  end
  object lblMaxWithdrawStock: TLabel
    Left = 26
    Top = 290
    Width = 174
    Height = 34
    Caption = 'Maximum withdrawable stock per customer'
    WordWrap = True
  end
  object lblCFUnit: TLabel
    Left = 385
    Top = 325
    Width = 36
    Height = 17
    Caption = 't/unit'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel
    Left = 388
    Top = 432
    Width = 36
    Height = 17
    Caption = 't/unit'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblEuUnit: TLabel
    Left = 388
    Top = 348
    Width = 63
    Height = 17
    Caption = 'kWh/unit'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 388
    Top = 468
    Width = 63
    Height = 17
    Caption = 'kWh/unit'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 388
    Top = 390
    Width = 40
    Height = 17
    Caption = 'L/unit'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    Left = 388
    Top = 497
    Width = 40
    Height = 17
    Caption = 'L/unit'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblmaxwithdrawstockunits: TLabel
    Left = 358
    Top = 299
    Width = 35
    Height = 17
    Caption = 'units'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblStockUnits: TLabel
    Left = 308
    Top = 255
    Width = 35
    Height = 17
    Caption = 'units'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object label67: TLabel
    Left = 182
    Top = 216
    Width = 11
    Height = 17
    Caption = 'R'
    Color = 16384
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16384
    Font.Height = -15
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object redDesc: TRichEdit
    Left = 188
    Top = 582
    Width = 185
    Height = 67
    Color = 7987076
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Zoom = 100
  end
  object edtName: TEdit
    Left = 181
    Top = 171
    Width = 164
    Height = 25
    Color = 8118149
    TabOrder = 1
  end
  object edtPrice: TEdit
    Left = 199
    Top = 213
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 2
    Text = '80.00'
  end
  object edtCF: TEdit
    Left = 261
    Top = 322
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 3
    Text = '100'
  end
  object edtEU: TEdit
    Left = 261
    Top = 349
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 4
    Text = '100'
  end
  object edtWU: TEdit
    Left = 261
    Top = 388
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 5
    Text = '100'
  end
  object cmbCategory: TComboBox
    Left = 261
    Top = 533
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 6
    Items.Strings = (
      'Toileteries'
      'Food'
      'Electronics'
      'Containers'
      'Clothes'
      'Other')
  end
  object edtCFProduce: TEdit
    Left = 261
    Top = 429
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 7
    Text = '100'
  end
  object edtEUProduce: TEdit
    Left = 261
    Top = 466
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 8
    Text = '100'
  end
  object edtWUProduce: TEdit
    Left = 261
    Top = 502
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 9
    Text = '100'
  end
  object edtStock: TEdit
    Left = 181
    Top = 252
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 10
    Text = '80'
  end
  object edtMaxWithdrawStock: TEdit
    Left = 206
    Top = 291
    Width = 121
    Height = 25
    Color = 7987076
    TabOrder = 11
    Text = '10'
  end
  object pnlHelp: TPanel
    Left = 386
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 12
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
      ExplicitLeft = 34
    end
  end
  object pnlBack: TPanel
    Left = 13
    Top = 8
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 13
    OnClick = btnBackClick
    object SpeedButton1: TSpeedButton
      Left = 2
      Top = 2
      Width = 71
      Height = 29
      Align = alClient
      Caption = 'Back'
      Flat = True
      OnClick = btnBackClick
      ExplicitLeft = 4
      ExplicitTop = 4
    end
  end
  object pnlSaveChanges: TPanel
    Left = 145
    Top = 670
    Width = 131
    Height = 34
    Color = 7987076
    ParentBackground = False
    TabOrder = 14
    object btnSaveChanges: TSpeedButton
      Left = 1
      Top = 1
      Width = 129
      Height = 32
      Align = alClient
      Caption = 'Save Changes'
      Flat = True
      OnClick = btnSaveChangesClick
      ExplicitLeft = -38
      ExplicitWidth = 183
      ExplicitHeight = 39
    end
  end
end
