object frmProfile: TfrmProfile
  Left = 0
  Top = 0
  Caption = 'Your Profile'
  ClientHeight = 725
  ClientWidth = 627
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
  object imgProfilePic: TImage
    Left = 224
    Top = 8
    Width = 105
    Height = 105
  end
  object lblUsername: TLabel
    Left = 246
    Top = 136
    Width = 83
    Height = 20
    Caption = '(Username)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
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
  object flpnlCategories: TFlowPanel
    Left = 64
    Top = 366
    Width = 443
    Height = 43
    AutoSize = True
    AutoWrap = False
    TabOrder = 1
    object btnCFCategory: TButton
      AlignWithMargins = True
      Left = 6
      Top = 9
      Width = 91
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Carbon Footprint'
      TabOrder = 0
      OnClick = categoryClickStats
    end
    object btnEUcategory: TButton
      AlignWithMargins = True
      Left = 107
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Energy Usage'
      TabOrder = 1
      OnClick = categoryClickStats
    end
    object btnSalesCategory: TButton
      AlignWithMargins = True
      Left = 192
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Sales'
      TabOrder = 2
      OnClick = categoryClickStats
    end
    object btnSpendCategory: TButton
      AlignWithMargins = True
      Left = 277
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Spending'
      TabOrder = 3
      OnClick = categoryClickStats
    end
    object btnWUCategory: TButton
      AlignWithMargins = True
      Left = 362
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Water Usage'
      TabOrder = 4
      OnClick = categoryClickStats
    end
  end
  object pnlInfo: TPanel
    AlignWithMargins = True
    Left = 175
    Top = 176
    Width = 210
    Height = 176
    AutoSize = True
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 2
    VerticalAlignment = taAlignTop
    object lblBalance: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Balance:'
      ExplicitWidth = 68
    end
    object lblRevenueTotal: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 123
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Revenue:'
      ExplicitWidth = 74
    end
    object lblSales: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 104
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Sales:'
      ExplicitWidth = 56
    end
    object lblSpendingTotal: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 28
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Spending:'
      ExplicitWidth = 75
    end
    object lblTotalCF: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 47
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Carbon Footprint:'
      ExplicitWidth = 113
    end
    object lblTotalEU: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 66
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Energy Usage:'
      ExplicitWidth = 98
    end
    object lblTotalWU: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 85
      Width = 192
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Water Usage:'
      ExplicitWidth = 94
    end
    object btnViewProducts: TButton
      AlignWithMargins = True
      Left = 9
      Top = 142
      Width = 192
      Height = 25
      Align = alTop
      Caption = 'View your products'
      TabOrder = 0
      OnClick = btnViewProductsClick
    end
  end
  object chrtStats: TChart
    Left = 0
    Top = 431
    Width = 599
    Height = 258
    Cursor = crArrow
    AllowPanning = pmHorizontal
    BackWall.Brush.Gradient.Direction = gdBottomTop
    BackWall.Brush.Gradient.EndColor = clWhite
    BackWall.Brush.Gradient.StartColor = 15395562
    BackWall.Brush.Gradient.Visible = True
    BackWall.Transparent = False
    Foot.Font.Color = clBlue
    Foot.Font.Name = 'Verdana'
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    Gradient.Visible = True
    LeftWall.Color = 14745599
    Legend.Font.Name = 'Verdana'
    Legend.ResizeChart = False
    Legend.Shadow.Transparency = 0
    Legend.Visible = False
    MarginTop = 3
    RightWall.Color = 14745599
    Title.Font.Name = 'Verdana'
    Title.Text.Strings = (
      'Your Revenue')
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Axis.Style = psDash
    BottomAxis.Grid.Color = 11119017
    BottomAxis.LabelsFormat.Font.Name = 'Verdana'
    BottomAxis.MinimumOffset = -22
    BottomAxis.TicksInner.Color = 11119017
    BottomAxis.Title.Font.Name = 'Verdana'
    DepthAxis.Axis.Color = 4210752
    DepthAxis.Grid.Color = 11119017
    DepthAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthAxis.TicksInner.Color = 11119017
    DepthAxis.Title.Font.Name = 'Verdana'
    DepthTopAxis.Axis.Color = 4210752
    DepthTopAxis.Grid.Color = 11119017
    DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthTopAxis.TicksInner.Color = 11119017
    DepthTopAxis.Title.Font.Name = 'Verdana'
    CustomAxes = <
      item
        Horizontal = False
        OtherSide = False
      end>
    LeftAxis.Axis.Color = 4210752
    LeftAxis.Grid.Color = 11119017
    LeftAxis.LabelsFormat.Font.Name = 'Verdana'
    LeftAxis.LogarithmicBase = 2.718281828459050000
    LeftAxis.TickLength = 3
    LeftAxis.TicksInner.Color = 11119017
    LeftAxis.TickOnLabelsOnly = False
    LeftAxis.Title.Font.Name = 'Verdana'
    RightAxis.Axis.Color = 4210752
    RightAxis.Grid.Color = 11119017
    RightAxis.LabelsFormat.Font.Name = 'Verdana'
    RightAxis.TicksInner.Color = 11119017
    RightAxis.Title.Font.Name = 'Verdana'
    Shadow.Visible = False
    TopAxis.Axis.Color = 4210752
    TopAxis.Grid.Color = 11119017
    TopAxis.LabelsFormat.Font.Name = 'Verdana'
    TopAxis.TicksInner.Color = 11119017
    TopAxis.Title.Font.Name = 'Verdana'
    View3DOptions.HorizOffset = -6
    View3DOptions.Zoom = 80
    Zoom.MouseButton = mbMiddle
    BevelOuter = bvNone
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      20
      15
      20)
    ColorPaletteIndex = -2
    ColorPalette = (
      7368816
      10708548
      3513587
      1330417
      11048782
      7028779
      6519581
      919731
      6144242
      10401629
      9300723
      11842740)
    object chrtLayoutStats: TChartLayout
      Left = 530
      Top = -20
      Width = 245
      Height = 356
      HorzScrollBar.Smooth = True
      HorzScrollBar.Tracking = True
      VertScrollBar.Smooth = True
      VertScrollBar.Tracking = True
      TabOrder = 0
      Visible = False
      Charts = <>
    end
    object srsStats: TBarSeries
      HoverElement = []
      Marks.DrawEvery = 5
      Marks.OnTop = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
      Data = {0000000000}
      Detail = {0000000000}
    end
  end
  object btnLeft: TButton
    Left = 184
    Top = 695
    Width = 75
    Height = 25
    Caption = '<'
    TabOrder = 4
  end
  object btnRight: TButton
    Left = 301
    Top = 695
    Width = 75
    Height = 25
    Caption = '>'
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 115
    Top = 135
    Width = 320
    Height = 120
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
end
