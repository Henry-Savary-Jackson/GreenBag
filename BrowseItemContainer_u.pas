unit BrowseItemContainer_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Data.Win.ADODB, DMUnit_u, Vcl.ImgList,
  System.Generics.Collections, Vcl.Imaging.pngimage, ItemContainer_u, Data.DB;

type
  tViewProcedure = procedure(itemID, sellerID: string) of object;

type
  BrowseItem = class(ItemContainer)
  public
    Constructor Create(Owner: tForm; Parent: TWinControl; ItemData: TADODataSet;
      viewProcedure: tViewProcedure);
    procedure createDesign(); override;
    procedure onViewItem(Sender: TObject);
  private
    lblPrice: TLabel;
    lblCF: TLabel;
    lblWU: TLabel;
    lblEU: TLabel;
    imgItem: TImage;
    btnViewItem: TButton;

    // user id of seller of this item
    sellerID: string;
    itemName, itemSeller: string;
    itemPrice, itemCF, itemWU, itemEU: double;
    viewProcedure: tViewProcedure;
    imageStream: TStream;

  end;

implementation

uses
  ViewItem_u, AddItem_u;

// the data argument is a dataset where it is assumed that the current record is that of this item
Constructor BrowseItem.Create(Owner: tForm; Parent: TWinControl;
  ItemData: TADODataSet; viewProcedure: tViewProcedure);
begin;

  itemID := ItemData['ItemID'];
  itemName := ItemData['ItemName'];
  itemSeller := ItemData['SellerName'];
  itemPrice := ItemData['Cost'];
  itemCF := ItemData['CF'];
  itemWU := ItemData['WU'];
  itemEU := ItemData['EU'];
  sellerID := ItemData['SellerID'];

  self.viewProcedure := viewProcedure;

  imageStream := ItemData.CreateBlobStream
    (ItemData.FieldByName('Image'), bmRead);

  Inherited Create(Owner, Parent, itemID);

end;

procedure BrowseItem.createDesign();
begin

  Width := 470;
  Height := 470;
  self.AlignWithMargins := true;
  Margins.Left := 10;
  Margins.Top := 15;
  Margins.Right := 10;
  Margins.Bottom := 10;
  Align := alLeft;
  Caption := itemName + ' by ' + itemSeller;
  TabOrder := 0;

  lblPrice := TLabel.Create(self.Owner);
  lblPrice.Parent := self;

  lblPrice.Left := 140;
  lblPrice.AlignWithMargins := true;
  lblPrice.Margins.Top := 10;
  lblPrice.Margins.Bottom := 10;
  lblPrice.Top := 220;
  lblPrice.Width := 27;
  lblPrice.Height := 13;
  lblPrice.Caption := 'Price:' + floattoStrf(itemPrice, ffCurrency, 8, 2);

  lblCF := TLabel.Create(self.Owner);
  lblCF.AlignWithMargins := true;
  lblCF.Margins.Top := 10;
  lblCF.Margins.Bottom := 10;
  lblCF.Parent := self;
  lblCF.Left := 140;
  lblCF.Top := 260;
  lblCF.Width := 82;
  lblCF.Height := 13;
  lblCF.Caption := 'Carbon Footprint:' + floattoStrf(itemCF, fffixed, 8, 2);

  lblWU := TLabel.Create(self.Owner);
  lblWU.AlignWithMargins := true;
  lblWU.Margins.Top := 10;
  lblWU.Margins.Bottom := 10;
  lblWU.Parent := self;
  lblWU.Left := 140;
  lblWU.Top := 300;
  lblWU.Width := 67;
  lblWU.Height := 13;
  lblWU.Caption := 'Water Usage:' + floattoStrf(itemWU, fffixed, 8, 2);;

  lblEU := TLabel.Create(self.Owner);
  lblEU.AlignWithMargins := true;
  lblEU.Margins.Top := 10;
  lblEU.Margins.Bottom := 10;
  lblEU.Parent := self;
  lblEU.Left := 140;
  lblEU.Top := 340;
  lblEU.Width := 71;
  lblEU.Height := 13;
  lblEU.Caption := 'Energy Usage:' + floattoStrf(itemEU, fffixed, 8, 2);;

  imgItem := TImage.Create(self.Owner);
  imgItem.Picture.LoadFromFile('cross.png');
  imgItem.Center := true;
  imgItem.Parent := self;
  imgItem.Left := 150;
  imgItem.Top := 30;
  imgItem.Width := 180;
  imgItem.Height := 180;
  imgItem.Center := true;
  imgItem.Stretch := true;

  try
    imgItem.Picture.LoadFromStream(imageStream);

  finally
    imageStream.Free;
  end;

  btnViewItem := TButton.Create(self.Owner);
  btnViewItem.Parent := self;
  btnViewItem.Left := 150;
  btnViewItem.Top := 380;
  btnViewItem.Width := 150;
  btnViewItem.Height := 50;
  btnViewItem.Caption := 'View Item';
  btnViewItem.TabOrder := 0;
  btnViewItem.OnClick := self.onViewItem;

end;

procedure BrowseItem.onViewItem(Sender: TObject);
begin

  self.viewProcedure(self.sellerID, self.itemID);

end;

end.
