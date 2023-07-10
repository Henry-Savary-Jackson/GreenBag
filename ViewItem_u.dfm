object frmViewItem: TfrmViewItem
  Left = 183
  Top = 0
  ActiveControl = spnQuantity
  Caption = 'View Item'
  ClientHeight = 742
  ClientWidth = 404
  Color = 11074992
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object imgItem: TImage
    Left = 152
    Top = 8
    Width = 105
    Height = 105
    Center = True
    Stretch = True
  end
  object lblDesc: TLabel
    Left = 30
    Top = 442
    Width = 97
    Height = 18
    Caption = 'Description:'
  end
  object lblCategory: TLabel
    Left = 92
    Top = 400
    Width = 79
    Height = 18
    Caption = 'Category:'
  end
  object lblCFProduce: TLabel
    Left = 63
    Top = 269
    Width = 232
    Height = 18
    Caption = 'Carbon Footprint to produce:'
  end
  object lblEUProduce: TLabel
    Left = 64
    Top = 288
    Width = 206
    Height = 18
    Caption = 'Energy usage to produce:'
  end
  object lblWUProduce: TLabel
    Left = 64
    Top = 307
    Width = 197
    Height = 18
    Caption = 'Water usage to produce:'
  end
  object lblPrice: TLabel
    Left = 106
    Top = 168
    Width = 47
    Height = 18
    Caption = 'Price:'
  end
  object lblName: TLabel
    Left = 105
    Top = 127
    Width = 51
    Height = 18
    Caption = 'Name:'
  end
  object lblSeller: TLabel
    Left = 106
    Top = 146
    Width = 51
    Height = 18
    Caption = 'Seller:'
  end
  object lblQuantity: TLabel
    Left = 95
    Top = 544
    Width = 73
    Height = 18
    Caption = 'Quantity:'
  end
  object lblRating: TLabel
    Left = 105
    Top = 575
    Width = 61
    Height = 18
    Caption = 'Rating: '
  end
  object lblYourRating: TLabel
    Left = 63
    Top = 604
    Width = 98
    Height = 18
    Caption = 'Your Rating:'
  end
  object lblCF: TLabel
    Left = 44
    Top = 339
    Width = 256
    Height = 18
    Caption = 'Carbon footprint through usage:'
  end
  object lblEU: TLabel
    Left = 29
    Top = 358
    Width = 289
    Height = 18
    Caption = 'Energy consumption through usage:'
  end
  object lblWU: TLabel
    Left = 44
    Top = 377
    Width = 280
    Height = 18
    Caption = 'Water consumption through usage:'
  end
  object lblStock: TLabel
    Left = 103
    Top = 187
    Width = 51
    Height = 18
    Caption = 'Stock:'
  end
  object lblMaxWithdraw: TLabel
    Left = 76
    Top = 211
    Width = 194
    Height = 36
    Caption = 'Maximum Stock you can withdraw at once:'
    WordWrap = True
  end
  object lbl5: TLabel
    Left = 260
    Top = 635
    Width = 10
    Height = 18
    Caption = '5'
    Color = 11074996
    ParentColor = False
  end
  object lbl0: TLabel
    Left = 175
    Top = 635
    Width = 10
    Height = 18
    Caption = '0'
    Color = 11074998
    ParentColor = False
  end
  object trcRating: TTrackBar
    Left = 175
    Top = 599
    Width = 105
    Height = 30
    Max = 5
    TabOrder = 2
  end
  object redDesc: TRichEdit
    Left = 150
    Top = 431
    Width = 185
    Height = 89
    Color = 7987076
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Zoom = 100
  end
  object spnQuantity: TSpinEdit
    Left = 182
    Top = 541
    Width = 49
    Height = 28
    Color = 7987076
    MaxValue = 1000
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object pnlBack: TPanel
    Left = 8
    Top = 8
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 3
    OnClick = btnBackClick
    object btnBack: TSpeedButton
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
  object pnlHelp: TPanel
    Left = 336
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 4
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
      ExplicitLeft = 9
      ExplicitTop = 4
    end
  end
  object pnlSendRating: TPanel
    Left = 133
    Top = 659
    Width = 185
    Height = 29
    Color = 7987076
    ParentBackground = False
    TabOrder = 5
    OnClick = btnSendRatingClick
    object btnSendRating: TSpeedButton
      Left = 1
      Top = 1
      Width = 183
      Height = 27
      Align = alClient
      Caption = 'Send your Rating'
      Flat = True
      ExplicitTop = 2
      ExplicitHeight = 39
    end
  end
  object pnlAddToCart: TPanel
    Left = 132
    Top = 698
    Width = 185
    Height = 31
    Color = 7987076
    ParentBackground = False
    TabOrder = 6
    object btnAddToCart: TSpeedButton
      Left = 1
      Top = 1
      Width = 183
      Height = 29
      Align = alClient
      Caption = 'Add to Cart'
      Flat = True
      OnClick = btnAddToCartClick
      ExplicitLeft = 0
      ExplicitHeight = 39
    end
  end
end
