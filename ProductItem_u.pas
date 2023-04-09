unit ProductItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, DMunit_u, Data.Win.ADODB, Vcl.ImgList, Vcl.Imaging.pngimage,
  ItemContainer_u, addItem_u, System.Generics.Collections;

type
  ProductItem = class(ItemContainer)

  private
    imgItem, imgRemoveProduct: TImage;
    grpRemoveProduct: TGroupBox;
    btnViewItem: TButton;
    lblSales, lblName, lblRevenue: TLabel;

    revenue: double;
    Sales: integer;
    name: string;

  public
    Constructor Create(Owner: tForm; Parent: TWinControl; ItemID: string);
    procedure createDesign(); override;
    procedure remove(Sender: TObject); override;
    procedure viewItem(Sender: TObject);

  end;

implementation

Constructor ProductItem.Create(Owner: tForm; Parent: TWinControl;
  ItemID: string);
var
  sql: string;
  params: tDictionary<string, Variant>;
  dsResult: tADODataset;
begin
  //
  sql := 'SELECT Name, Sales, (Sales*Cost) AS Revenue FROM ItemTB WHERE ItemID = :ItemID';

  params := tDictionary<string, Variant>.Create();
  params.Add('ItemID', ItemID);
  showMessage('lol');
  dsResult := DataModule1.runSQL(sql, params);
  showMessage('lol');
  params.Free;

//  if dsResult.FieldDefs.Find('Status') <> nil then
//  begin
//    showMessage(dsResult['Status']);
//    Exit;
//  end;

  Name := dsResult['Name'];
  Sales := dsResult['Sales'];
  revenue := dsResult['Revenue'];

  Inherited Create(Owner, Parent, ItemID);

end;

procedure ProductItem.createDesign();
begin
  //
  AlignWithMargins := True;
  Left := 11;
  Top := 11;
  Width := 790;
  Height := 190;
  Margins.Left := 10;
  Margins.Top := 10;
  Margins.Right := 10;
  Margins.Bottom := 10;
  Align := alTop;
  TabOrder := 0;

  imgItem := TImage.Create(self.Owner);
  imgItem.Parent := self;
  imgItem.Picture.LoadFromFile('cross.png');
  imgItem.Center := True;
  imgItem.Left := 70;
  imgItem.Top := 20;
  imgItem.Width := 110;
  imgItem.Height := 110;

  lblName := TLabel.Create(self.Owner);
  lblName.Parent := self;
  lblName.Left := 280;
  lblName.Top := 15;
  lblName.Width := 31;
  lblName.Height := 13;
  lblName.Caption := 'Name: ' + name;

  lblRevenue := TLabel.Create(self.Owner);
  lblRevenue.Parent := self;
  lblRevenue.Left := 280;
  lblRevenue.Top := 75;
  lblRevenue.Width := 47;
  lblRevenue.Height := 13;
  lblRevenue.Caption := 'Revenue: ' + floatToStrf(revenue, ffCurrency, 8, 2);

  lblSales := TLabel.Create(self.Owner);
  lblSales.Parent := self;
  lblSales.Left := 280;
  lblSales.Top := 135;
  lblSales.Width := 29;
  lblSales.Height := 13;
  lblSales.Caption := 'Sales: ' + intToStr(Sales);

  btnViewItem := TButton.Create(self.Owner);
  btnViewItem.Parent := self;
  btnViewItem.Left := 45;
  btnViewItem.Top := 140;
  btnViewItem.Width := 140;
  btnViewItem.Height := 50;
  btnViewItem.Caption := 'View Item';
  btnViewItem.TabOrder := 0;
  btnViewItem.OnClick := self.viewItem;

  grpRemoveProduct := TGroupBox.Create(self.Owner);
  grpRemoveProduct.Parent := self;
  grpRemoveProduct.AlignWithMargins := True;
  grpRemoveProduct.Width := 120;
  grpRemoveProduct.Margins.Left := 20;
  grpRemoveProduct.Margins.Top := 10;
  grpRemoveProduct.Margins.Right := 20;
  grpRemoveProduct.Margins.Bottom := 20;
  grpRemoveProduct.Align := alRight;
  grpRemoveProduct.Color := clScrollBar;
  grpRemoveProduct.ParentBackground := False;
  grpRemoveProduct.ParentColor := False;
  grpRemoveProduct.TabOrder := 1;
  grpRemoveProduct.OnClick := self.remove;

  imgRemoveProduct := TImage.Create(self.Owner);
  imgRemoveProduct.Parent := grpRemoveProduct;
  imgRemoveProduct.Center := True;
  imgRemoveProduct.Picture.LoadFromFile('cross.png');
  imgRemoveProduct.AlignWithMargins := True;
  imgRemoveProduct.Margins.Left := 5;
  imgRemoveProduct.Margins.Top := 0;
  imgRemoveProduct.Margins.Right := 5;
  imgRemoveProduct.Margins.Bottom := 5;
  imgRemoveProduct.Align := alClient;
  imgRemoveProduct.Center := True;
  imgRemoveProduct.OnClick := self.remove;

end;

procedure ProductItem.remove(Sender: TObject);
begin
  //
end;

procedure ProductItem.viewItem(Sender: TObject);
begin
  //
  self.Owner.Hide;
  frmAddItem.itemID := itemID;
  frmAddItem.Show;

end;

{
  object grpProduct: TGroupBox
  AlignWithMargins = True
  Left = 11
  Top = 11
  Width = 392
  Height = 104
  Margins.Left = 10
  Margins.Top = 10
  Margins.Right = 10
  Margins.Bottom = 10
  Align = alTop
  TabOrder = 0
  object Image1: TImage
  Left = 21
  Top = 14
  Width = 57
  Height = 57
  end
  object lblName: TLabel
  Left = 136
  Top = 24
  Width = 31
  Height = 13
  Caption = 'Name:'
  end
  object lblRevenue: TLabel
  Left = 136
  Top = 43
  Width = 47
  Height = 13
  Caption = 'Revenue:'
  end
  object lblSales: TLabel
  Left = 136
  Top = 75
  Width = 29
  Height = 13
  Caption = 'Sales:'
  end
  object btnViewItem: TButton
  Left = 21
  Top = 77
  Width = 75
  Height = 25
  Caption = 'View Item'
  TabOrder = 0
  OnClick = btnViewItemClick
  end
  object grpRemoveProduct: TGroupBox
  AlignWithMargins = True
  Left = 313
  Top = 25
  Width = 57
  Height = 57
  Margins.Left = 20
  Margins.Top = 10
  Margins.Right = 20
  Margins.Bottom = 20
  Align = alRight
  Color = clScrollBar
  ParentBackground = False
  ParentColor = False
  TabOrder = 1
  OnClick = imgRemoveProductClick
  object imgRemoveProduct: TImage
  AlignWithMargins = True
  Left = 7
  Top = 15
  Width = 43
  Height = 35
  Margins.Left = 5
  Margins.Top = 0
  Margins.Right = 5
  Margins.Bottom = 5
  Align = alClient
  Center = True
  Picture.Data =
  OnClick = imgRemoveProductClick
  ExplicitLeft = 9
  ExplicitTop = 17
  end
  end
  end
}

end.
