object frmAddItem: TfrmAddItem
  Left = 366
  Top = 0
  Caption = 'Add Item'
  ClientHeight = 723
  ClientWidth = 706
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
  object pnlHelp: TPanel
    Left = 646
    Top = 0
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 0
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
      ExplicitLeft = 50
      ExplicitTop = -14
    end
  end
  object pnlBack: TPanel
    Left = 0
    Top = 0
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 1
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
      ExplicitLeft = 13
    end
  end
  object pnlSaveChanges: TPanel
    Left = 298
    Top = 685
    Width = 131
    Height = 34
    Color = 7987076
    ParentBackground = False
    TabOrder = 2
    object btnSaveChanges: TSpeedButton
      Left = 1
      Top = 1
      Width = 129
      Height = 32
      Align = alClient
      Caption = 'Save Changes'
      Flat = True
      OnClick = btnSaveChangesClick
      ExplicitTop = 0
    end
  end
  object pnlItemInfo: TPanel
    Left = 64
    Top = 111
    Width = 577
    Height = 570
    Margins.Bottom = 1
    TabOrder = 3
    object lblRating: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 5
      Width = 569
      Height = 17
      Margins.Top = 4
      Margins.Bottom = 4
      Align = alTop
      Alignment = taCenter
      Caption = 'Average Rating: '
      Color = 11074994
      ParentColor = False
      ExplicitWidth = 122
    end
    object pnlName: TPanel
      Left = 1
      Top = 26
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 0
      object lblName: TLabel
        AlignWithMargins = True
        Left = 204
        Top = 16
        Width = 47
        Height = 17
        Margins.Top = 8
        Margins.Bottom = 5
        Alignment = taRightJustify
        Caption = 'Name:'
      end
      object edtName: TEdit
        AlignWithMargins = True
        Left = 257
        Top = 10
        Width = 203
        Height = 25
        Margins.Top = 2
        Color = 8118149
        TabOrder = 0
      end
    end
    object pnlCategory: TPanel
      Left = 1
      Top = 108
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 1
      object lblCategory: TLabel
        AlignWithMargins = True
        Left = 179
        Top = 15
        Width = 72
        Height = 17
        Margins.Top = 5
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Category:'
      end
      object cmbCategory: TComboBox
        AlignWithMargins = True
        Left = 257
        Top = 10
        Width = 206
        Height = 25
        Margins.Top = 2
        Color = 7987076
        TabOrder = 0
        Items.Strings = (
          'Toileteries'
          'Food'
          'Electronics'
          'Containers'
          'Clothes'
          'Other')
      end
    end
    object pnlPrice: TPanel
      Left = 1
      Top = 67
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 2
      object lblPrice: TLabel
        AlignWithMargins = True
        Left = 192
        Top = 15
        Width = 59
        Height = 17
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Price: R'
      end
      object edtPrice: TEdit
        AlignWithMargins = True
        Left = 257
        Top = 10
        Width = 206
        Height = 25
        Hint = 'Enter your price per unit with  a comma as a decimal point'
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Color = 7987076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '80.00'
      end
    end
    object pnlWUProduce: TPanel
      Left = 1
      Top = 436
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 3
      object lblWUProduce: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 8
        Width = 221
        Height = 17
        Margins.Top = 5
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Water Usage of its production:'
      end
      object lblWuProduceUnit: TLabel
        AlignWithMargins = True
        Left = 477
        Top = 9
        Width = 40
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Bottom = 6
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
      object edtWUProduce: TEdit
        AlignWithMargins = True
        Left = 257
        Top = 5
        Width = 207
        Height = 25
        Hint = 
          'Enter your product'#39's water usage during production per unit with' +
          '  a comma as a decimal point'
        Margins.Top = 2
        Color = 7987076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '100'
      end
    end
    object pnlWU: TPanel
      Left = 1
      Top = 313
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 4
      object lblWaterUsage: TLabel
        AlignWithMargins = True
        Left = 82
        Top = 8
        Width = 168
        Height = 17
        Margins.Top = 5
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Water Usage of its use:'
      end
      object lblWuUnit: TLabel
        AlignWithMargins = True
        Left = 477
        Top = 9
        Width = 40
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Bottom = 6
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
      object edtWU: TEdit
        AlignWithMargins = True
        Left = 256
        Top = 5
        Width = 208
        Height = 25
        Hint = 
          'Enter your product'#39's water usage during a consumer'#39's usage per u' +
          'nit with  a comma as a decimal point'
        Margins.Top = 2
        Color = 7987076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '100'
      end
    end
    object pnlEUProduce: TPanel
      Left = 1
      Top = 395
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 5
      object lblEUProduce: TLabel
        AlignWithMargins = True
        Left = 22
        Top = 8
        Width = 229
        Height = 17
        Margins.Top = 5
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Energy Usage of its production:'
      end
      object lblEUProduceUnit: TLabel
        AlignWithMargins = True
        Left = 469
        Top = 9
        Width = 63
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Bottom = 6
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
      object edtEUProduce: TEdit
        AlignWithMargins = True
        Left = 257
        Top = 5
        Width = 207
        Height = 25
        Hint = 
          'Enter your product'#39's energy footprint during production per unit' +
          ' with  a comma as a decimal point'
        Margins.Top = 2
        Color = 7987076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '100'
      end
    end
    object pnlEU: TPanel
      Left = 1
      Top = 272
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 6
      object lblEU: TLabel
        AlignWithMargins = True
        Left = 75
        Top = 15
        Width = 176
        Height = 17
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Energy Usage of its use:'
      end
      object lblEuUnit: TLabel
        AlignWithMargins = True
        Left = 469
        Top = 9
        Width = 63
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Right = 10
        Margins.Bottom = 6
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
      object edtEU: TEdit
        AlignWithMargins = True
        Left = 256
        Top = 10
        Width = 207
        Height = 25
        Hint = 
          'Enter your product'#39's energy usage during a consumer'#39's usage per ' +
          'unit with  a comma as a decimal point'
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Color = 7987076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '100'
      end
    end
    object pnlCF: TPanel
      Left = 1
      Top = 231
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 7
      object lblCF: TLabel
        AlignWithMargins = True
        Left = 52
        Top = 15
        Width = 199
        Height = 17
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Carbon FootPrint of its use:'
      end
      object lblCFUnit: TLabel
        AlignWithMargins = True
        Left = 477
        Top = 9
        Width = 36
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 6
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
      object edtCF: TEdit
        AlignWithMargins = True
        Left = 256
        Top = 10
        Width = 207
        Height = 25
        Hint = 
          'Enter your product'#39's carbon footprint during consumer usage per ' +
          'unit with  a comma as a decimal point'
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Color = 7987076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '100'
      end
    end
    object pnlCFProduce: TPanel
      Left = 1
      Top = 354
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 8
      object lblCFProduce: TLabel
        AlignWithMargins = True
        Left = 1
        Top = 15
        Width = 252
        Height = 17
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Carbon FootPrint of its production:'
      end
      object lnlCFproduceUnit: TLabel
        AlignWithMargins = True
        Left = 469
        Top = 9
        Width = 36
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Right = 10
        Margins.Bottom = 6
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
      object edtCFProduce: TEdit
        AlignWithMargins = True
        Left = 257
        Top = 5
        Width = 207
        Height = 25
        Hint = 
          'Enter your product'#39's carbon footprint during production per unit' +
          ' with  a comma as a decimal point'
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Color = 7987076
        TabOrder = 0
        Text = '100'
      end
    end
    object pnlMaxWithdraw: TPanel
      Left = 1
      Top = 190
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 9
      DesignSize = (
        575
        41)
      object lblMaxWithdrawStock: TLabel
        AlignWithMargins = True
        Left = 34
        Top = 8
        Width = 219
        Height = 17
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 6
        Alignment = taRightJustify
        Anchors = []
        Caption = 'Maximum withdrawable stock:'
      end
      object lblmaxwithdrawstockunits: TLabel
        AlignWithMargins = True
        Left = 477
        Top = 15
        Width = 35
        Height = 17
        Margins.Left = 10
        Margins.Top = 30
        Margins.Right = 10
        Margins.Bottom = 6
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
      object edtMaxWithdrawStock: TEdit
        AlignWithMargins = True
        Left = 257
        Top = 5
        Width = 207
        Height = 25
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Color = 7987076
        TabOrder = 0
        Text = '10'
      end
    end
    object pnlStock: TPanel
      Left = 1
      Top = 149
      Width = 575
      Height = 41
      Align = alTop
      TabOrder = 10
      object lblStock: TLabel
        AlignWithMargins = True
        Left = 189
        Top = 8
        Width = 47
        Height = 17
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Stock:'
      end
      object lblStockUnits: TLabel
        AlignWithMargins = True
        Left = 477
        Top = 9
        Width = 35
        Height = 17
        Margins.Left = 10
        Margins.Top = 6
        Margins.Right = 10
        Margins.Bottom = 6
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
      object edtStock: TEdit
        AlignWithMargins = True
        Left = 256
        Top = 5
        Width = 207
        Height = 25
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Color = 7987076
        TabOrder = 0
        Text = '80'
      end
    end
    object pnlDesc: TPanel
      Left = 1
      Top = 477
      Width = 575
      Height = 91
      Align = alTop
      TabOrder = 11
      object lblDesc: TLabel
        AlignWithMargins = True
        Left = 44
        Top = 8
        Width = 89
        Height = 17
        Margins.Top = 5
        Margins.Bottom = 6
        Alignment = taRightJustify
        Caption = 'Description:'
      end
      object redDesc: TRichEdit
        AlignWithMargins = True
        Left = 253
        Top = 5
        Width = 211
        Height = 79
        Hint = 
          'Describe the details regarding your product and its production. ' +
          'This is to help consumers make an informed decision.'
        Margins.Top = 2
        Color = 7987076
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Zoom = 100
      end
    end
  end
  object pnlProfileImage: TPanel
    Left = 332
    Top = 0
    Width = 105
    Height = 105
    TabOrder = 4
    object imgItem: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      Hint = 'Choose your item'#39's image'
      Center = True
      ParentShowHint = False
      ShowHint = True
      Stretch = True
      OnClick = imgItemClick
    end
  end
end
