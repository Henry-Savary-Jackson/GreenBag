object frmCheckout: TfrmCheckout
  Left = 0
  Top = 0
  Caption = 'Checkout'
  ClientHeight = 406
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
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
    Width = 616
    Height = 258
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 2
    object flpnlItems: TFlowPanel
      Left = 3
      Top = 0
      Width = 583
      Height = 139
      AutoSize = True
      TabOrder = 0
    end
  end
end
