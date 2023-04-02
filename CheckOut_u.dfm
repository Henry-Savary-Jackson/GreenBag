object frmCheckout: TfrmCheckout
  Left = 0
  Top = 0
  Caption = 'Checkout'
  ClientHeight = 406
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblTotalCost: TLabel
    Left = 30
    Top = 342
    Width = 53
    Height = 13
    Caption = 'Total Cost:'
  end
  object lblTotalCF: TLabel
    Left = 136
    Top = 353
    Width = 113
    Height = 13
    Caption = 'Total Carbon Footprint:'
  end
  object lblTotalEU: TLabel
    Left = 300
    Top = 337
    Width = 98
    Height = 13
    Caption = 'Total Energy Usage:'
  end
  object lblTotalWU: TLabel
    Left = 441
    Top = 342
    Width = 94
    Height = 13
    Caption = 'Total Water Usage:'
  end
  object btnBack: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'back'
    TabOrder = 0
    OnClick = btnBackClick
  end
  object btnCheckout: TButton
    Left = 283
    Top = 373
    Width = 75
    Height = 25
    Caption = 'Check Out'
    TabOrder = 1
    OnClick = btnCheckoutClick
  end
  object scrbxItems: TScrollBox
    Left = 8
    Top = 56
    Width = 602
    Height = 258
    TabOrder = 2
    object flpnlItems: TFlowPanel
      Left = 0
      Top = 0
      Width = 581
      Height = 286
      AutoWrap = False
      TabOrder = 0
      object grpItem: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 4
        Width = 571
        Height = 129
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        TabOrder = 0
        object lblQuantity: TLabel
          Left = 224
          Top = 56
          Width = 46
          Height = 13
          Caption = 'Quantity:'
        end
        object redItemInfo: TRichEdit
          Left = 3
          Top = 19
          Width = 201
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Zoom = 100
        end
        object btnRemove: TButton
          Left = 476
          Top = 32
          Width = 69
          Height = 65
          TabOrder = 1
        end
        object spnQuantity: TSpinEdit
          Left = 284
          Top = 56
          Width = 41
          Height = 22
          MaxValue = 1000
          MinValue = -1
          TabOrder = 2
          Value = 0
        end
      end
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 587
        Top = 4
        Width = 571
        Height = 129
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        TabOrder = 1
        object Label1: TLabel
          Left = 224
          Top = 56
          Width = 46
          Height = 13
          Caption = 'Quantity:'
        end
        object RichEdit1: TRichEdit
          Left = 3
          Top = 19
          Width = 201
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Zoom = 100
        end
        object Button1: TButton
          Left = 476
          Top = 32
          Width = 69
          Height = 65
          TabOrder = 1
        end
        object SpinEdit1: TSpinEdit
          Left = 284
          Top = 56
          Width = 41
          Height = 22
          MaxValue = 1000
          MinValue = -1
          TabOrder = 2
          Value = 0
        end
      end
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 1168
        Top = 4
        Width = 571
        Height = 129
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        TabOrder = 2
        object Label2: TLabel
          Left = 224
          Top = 56
          Width = 46
          Height = 13
          Caption = 'Quantity:'
        end
        object RichEdit2: TRichEdit
          Left = 3
          Top = 19
          Width = 201
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Zoom = 100
        end
        object Button2: TButton
          Left = 364
          Top = 32
          Width = 69
          Height = 65
          TabOrder = 1
        end
        object SpinEdit2: TSpinEdit
          Left = 284
          Top = 56
          Width = 41
          Height = 22
          MaxValue = 1000
          MinValue = -1
          TabOrder = 2
          Value = 0
        end
      end
      object GroupBox3: TGroupBox
        AlignWithMargins = True
        Left = 1749
        Top = 4
        Width = 571
        Height = 129
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        TabOrder = 3
        object Label3: TLabel
          Left = 224
          Top = 56
          Width = 46
          Height = 13
          Caption = 'Quantity:'
        end
        object RichEdit3: TRichEdit
          Left = 3
          Top = 19
          Width = 201
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Zoom = 100
        end
        object Button3: TButton
          Left = 476
          Top = 32
          Width = 69
          Height = 65
          TabOrder = 1
        end
        object SpinEdit3: TSpinEdit
          Left = 284
          Top = 56
          Width = 41
          Height = 22
          MaxValue = 1000
          MinValue = -1
          TabOrder = 2
          Value = 0
        end
      end
    end
  end
end
