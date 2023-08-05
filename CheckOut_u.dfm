object frmCheckout: TfrmCheckout
  Left = 0
  Top = 0
  Caption = 'Checkout'
  ClientHeight = 415
  ClientWidth = 729
  Color = 11074992
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object lblTotalCost: TLabel
    Left = 128
    Top = 326
    Width = 86
    Height = 18
    Caption = 'Total Cost:'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
  end
  object lblTotalCF: TLabel
    Left = 56
    Top = 350
    Width = 185
    Height = 18
    Caption = 'Total Carbon Footprint:'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
  end
  object lblTotalWU: TLabel
    Left = 424
    Top = 326
    Width = 152
    Height = 18
    Caption = 'Total Water Usage:'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
  end
  object lblTotalEU: TLabel
    Left = 415
    Top = 350
    Width = 161
    Height = 18
    Caption = 'Total Energy Usage:'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
  end
  object scrbxItems: TScrollBox
    Left = 72
    Top = 47
    Width = 609
    Height = 276
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object flpnlItems: TFlowPanel
      Left = 3
      Top = 3
      Width = 599
      Height = 107
      AutoSize = True
      TabOrder = 0
    end
  end
  object pnlBack: TPanel
    Left = 13
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
      ExplicitLeft = 4
      ExplicitTop = 4
    end
  end
  object pnlHelp: TPanel
    Left = 661
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8249222
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
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
      ExplicitTop = 6
    end
  end
  object pnlCheckout: TPanel
    Left = 287
    Top = 374
    Width = 106
    Height = 41
    Color = 8118149
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -16
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    object btnCheckout: TSpeedButton
      Left = 1
      Top = 1
      Width = 104
      Height = 39
      Align = alClient
      Caption = 'Check Out'
      Flat = True
      OnClick = btnCheckoutClick
      ExplicitLeft = 9
      ExplicitTop = 9
    end
  end
end
