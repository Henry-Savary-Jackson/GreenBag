object frmBrowse: TfrmBrowse
  Left = 0
  Top = 0
  Caption = 'Browse items'
  ClientHeight = 587
  ClientWidth = 677
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
  object grpMain: TGroupBox
    Left = 139
    Top = 0
    Width = 538
    Height = 587
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 145
    ExplicitWidth = 805
    object grpHeader: TGroupBox
      Left = 2
      Top = 15
      Width = 534
      Height = 131
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 0
      ExplicitWidth = 801
      DesignSize = (
        534
        131)
      object scrbxCategories: TScrollBox
        Left = 79
        Top = 48
        Width = 368
        Height = 41
        HorzScrollBar.Tracking = True
        TabOrder = 0
        object Button1: TButton
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 100
          Height = 27
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alLeft
          Caption = 'Eco-Friendly Food'
          TabOrder = 0
        end
      end
      object srchSearchItems: TSearchBox
        Left = 79
        Top = 29
        Width = 368
        Height = 21
        Anchors = []
        TabOrder = 1
        ExplicitLeft = 45
      end
    end
    object scrbxItems: TScrollBox
      Left = 2
      Top = 146
      Width = 534
      Height = 439
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 72
      ExplicitTop = 111
      ExplicitWidth = 529
      ExplicitHeight = 443
      object flpnlItems: TFlowPanel
        Left = 0
        Top = 0
        Width = 530
        Height = 252
        Align = alTop
        AutoSize = True
        TabOrder = 0
        ExplicitWidth = 525
        object GroupBox1: TGroupBox
          AlignWithMargins = True
          Left = 11
          Top = 11
          Width = 238
          Height = 230
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alLeft
          Caption = 'Itemname'
          TabOrder = 0
          object lblPrice: TLabel
            Left = 64
            Top = 179
            Width = 27
            Height = 13
            Caption = 'Price:'
          end
          object lblCF: TLabel
            Left = 56
            Top = 122
            Width = 82
            Height = 13
            Caption = 'Carbon Footprint'
          end
          object lblEU: TLabel
            Left = 64
            Top = 141
            Width = 71
            Height = 13
            Caption = 'Energy Usage:'
          end
          object lblWU: TLabel
            Left = 67
            Top = 160
            Width = 67
            Height = 13
            Caption = 'Water Usage:'
          end
          object Image1: TImage
            Left = 66
            Top = 22
            Width = 100
            Height = 94
            Center = True
          end
          object btnViewItem: TButton
            Left = 72
            Top = 198
            Width = 75
            Height = 25
            Caption = 'View Item'
            TabOrder = 0
            OnClick = btnViewItemClick
          end
        end
        object GroupBox2: TGroupBox
          AlignWithMargins = True
          Left = 269
          Top = 11
          Width = 238
          Height = 230
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alLeft
          Caption = 'Itemname'
          TabOrder = 1
          object Label1: TLabel
            Left = 64
            Top = 179
            Width = 27
            Height = 13
            Caption = 'Price:'
          end
          object Label2: TLabel
            Left = 56
            Top = 122
            Width = 82
            Height = 13
            Caption = 'Carbon Footprint'
          end
          object Label3: TLabel
            Left = 64
            Top = 141
            Width = 71
            Height = 13
            Caption = 'Energy Usage:'
          end
          object Label4: TLabel
            Left = 67
            Top = 160
            Width = 67
            Height = 13
            Caption = 'Water Usage:'
          end
          object Image2: TImage
            Left = 66
            Top = 22
            Width = 100
            Height = 94
            Center = True
          end
          object Button2: TButton
            Left = 72
            Top = 198
            Width = 75
            Height = 25
            Caption = 'View Item'
            TabOrder = 0
          end
        end
      end
    end
  end
  object grpSideBar: TGroupBox
    Left = 0
    Top = 0
    Width = 139
    Height = 587
    Align = alLeft
    TabOrder = 1
    ExplicitLeft = 2
    ExplicitTop = 15
    ExplicitHeight = 88
    object imgProfile: TImage
      Left = 30
      Top = 46
      Width = 73
      Height = 70
    end
    object btnCheckout: TButton
      Left = 30
      Top = 165
      Width = 75
      Height = 60
      Caption = 'Checkout'
      TabOrder = 0
      OnClick = btnCheckoutClick
    end
    object btnLogout: TButton
      Left = 30
      Top = 266
      Width = 75
      Height = 25
      Caption = 'Logout'
      TabOrder = 1
      OnClick = btnLogoutClick
    end
  end
end
