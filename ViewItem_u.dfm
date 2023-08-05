object frmViewItem: TfrmViewItem
  Left = 183
  Top = 0
  AutoSize = True
  Caption = 'View Item'
  ClientHeight = 723
  ClientWidth = 510
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
  object pnlBack: TPanel
    Left = 0
    Top = 8
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8118149
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
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
    Left = 450
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
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
      ExplicitLeft = 42
    end
  end
  object pnlAddToCart: TPanel
    Left = 161
    Top = 692
    Width = 185
    Height = 31
    Color = 7987076
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
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
    end
  end
  object pnlIItemInfo: TPanel
    Left = 25
    Top = 115
    Width = 448
    Height = 571
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object lblCF: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 134
      Width = 440
      Height = 18
      Margins.Top = 2
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Carbon footprint through usage:'
      ExplicitWidth = 256
    end
    object lblCFProduce: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 207
      Width = 440
      Height = 18
      Margins.Top = 2
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Carbon Footprint to produce:'
      ExplicitWidth = 232
    end
    object lblEU: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 177
      Width = 440
      Height = 18
      Margins.Bottom = 10
      Align = alTop
      Alignment = taCenter
      Caption = 'Energy consumption through usage:'
      ExplicitWidth = 289
    end
    object lblEUProduce: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 228
      Width = 440
      Height = 18
      Margins.Top = 2
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Energy usage to produce:'
      ExplicitWidth = 206
    end
    object lblMaxWithdraw: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 104
      Width = 440
      Height = 18
      Margins.Bottom = 10
      Align = alTop
      Alignment = taCenter
      Caption = 'Maximum Stock you can withdraw at once:'
      WordWrap = True
      ExplicitWidth = 336
    end
    object lblName: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 2
      Width = 440
      Height = 18
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Name:'
      ExplicitWidth = 51
    end
    object lblPrice: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 42
      Width = 440
      Height = 18
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Price:'
      ExplicitWidth = 47
    end
    object lblSeller: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 62
      Width = 440
      Height = 18
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Seller:'
      ExplicitWidth = 51
    end
    object lblStock: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 82
      Width = 440
      Height = 18
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Stock:'
      ExplicitWidth = 51
    end
    object lblWU: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 155
      Width = 440
      Height = 18
      Margins.Top = 2
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Water consumption through usage:'
      ExplicitWidth = 280
    end
    object lblWUProduce: TLabel
      Left = 1
      Top = 247
      Width = 446
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Water usage to produce:'
      ExplicitWidth = 197
    end
    object lblCategory: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 22
      Width = 440
      Height = 18
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alTop
      Alignment = taCenter
      Caption = 'Category:'
      ExplicitWidth = 79
    end
    object pnlDesc: TPanel
      Left = 1
      Top = 265
      Width = 446
      Height = 130
      Align = alTop
      TabOrder = 0
      object lblDesc: TLabel
        Left = 1
        Top = 1
        Width = 97
        Height = 128
        Align = alLeft
        Alignment = taCenter
        Caption = 'Description:'
        ExplicitHeight = 18
      end
      object redDesc: TRichEdit
        Left = 98
        Top = 1
        Width = 347
        Height = 128
        Align = alClient
        Alignment = taCenter
        Color = 7987076
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Zoom = 100
      end
    end
    object pnlQuantity: TPanel
      Left = 1
      Top = 530
      Width = 446
      Height = 41
      Align = alTop
      TabOrder = 1
      object lblQuantity: TLabel
        Left = 76
        Top = 6
        Width = 73
        Height = 18
        Caption = 'Quantity:'
      end
      object spnQuantity: TSpinEdit
        Left = 247
        Top = 6
        Width = 49
        Height = 28
        Color = 7987076
        MaxValue = 1000
        MinValue = 1
        TabOrder = 0
        Value = 1
      end
    end
    object pnlRating: TPanel
      Left = 1
      Top = 395
      Width = 446
      Height = 135
      Align = alTop
      TabOrder = 2
      object lbl0: TLabel
        Left = 215
        Top = 73
        Width = 10
        Height = 18
        Caption = '0'
        Color = 11074998
        ParentColor = False
      end
      object lbl5: TLabel
        Left = 310
        Top = 74
        Width = 10
        Height = 18
        Caption = '5'
        Color = 11074996
        ParentColor = False
      end
      object lblRating: TLabel
        Left = 98
        Top = 6
        Width = 133
        Height = 18
        Caption = 'Average Rating: '
      end
      object lblYourRating: TLabel
        Left = 90
        Top = 47
        Width = 98
        Height = 18
        Caption = 'Your Rating:'
      end
      object trcRating: TTrackBar
        Left = 215
        Top = 46
        Width = 105
        Height = 30
        Max = 5
        TabOrder = 0
      end
      object pnlSendRating: TPanel
        Left = 143
        Top = 97
        Width = 185
        Height = 29
        Color = 7987076
        ParentBackground = False
        TabOrder = 1
        OnClick = btnSendRatingClick
        object btnSendRating: TSpeedButton
          Left = 1
          Top = 1
          Width = 183
          Height = 27
          Align = alClient
          Caption = 'Send your Rating'
          Flat = True
          OnClick = btnSendRatingClick
          ExplicitLeft = -47
        end
      end
    end
  end
  object pnlImage: TPanel
    Left = 208
    Top = 0
    Width = 106
    Height = 109
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object imgItem: TImage
      Left = 1
      Top = 0
      Width = 105
      Height = 105
      Center = True
      Stretch = True
    end
  end
end
