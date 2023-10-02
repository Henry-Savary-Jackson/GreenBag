unit BrowseItemContainer_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.buttons,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Data.Win.ADODB, DMUnit_u, Vcl.ImgList,
  System.Generics.Collections, Vcl.Imaging.pngimage, ItemContainer_u, Data.DB,
  activeX, System.threading;

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
    btnViewItem: tSpeedButton;
    pnlViewItem: tPanel;

    // user id of seller of this item
    sellerID: string;
    itemName, itemSeller: string;
    itemPrice, itemCF, itemWU, itemEU: double;
    // procedure to execute when the view item button is clicked
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

  // get data
  itemID := ItemData['ItemID'];
  itemName := ItemData['ItemName'];
  itemSeller := ItemData['SellerName'];
  itemPrice := ItemData['Cost'];
  itemCF := ItemData['CF'];
  itemWU := ItemData['WU'];
  itemEU := ItemData['EU'];
  sellerID := ItemData['SellerID'];

  self.viewProcedure := viewProcedure;

  Inherited Create(Owner, Parent, itemID);

end;

procedure BrowseItem.createDesign();
begin

  Width := 550;
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

  lblPrice.Left := 30;
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
  lblCF.Left := 30;
  lblCF.Top := 260;
  lblCF.Width := 82;
  lblCF.Height := 13;
  lblCF.Caption := 'Carbon Footprint:' + floattoStrf(itemCF, fffixed, 8, 2) +
    ' t/unit';

  lblWU := TLabel.Create(self.Owner);
  lblWU.AlignWithMargins := true;
  lblWU.Margins.Top := 10;
  lblWU.Margins.Bottom := 10;
  lblWU.Parent := self;
  lblWU.Left := 30;
  lblWU.Top := 300;
  lblWU.Width := 67;
  lblWU.Height := 13;
  lblWU.Caption := 'Water Usage:' + floattoStrf(itemWU, fffixed, 8, 2) +
    ' L/unit';

  lblEU := TLabel.Create(self.Owner);
  lblEU.AlignWithMargins := true;
  lblEU.Margins.Top := 10;
  lblEU.Margins.Bottom := 10;
  lblEU.Parent := self;
  lblEU.Left := 30;
  lblEU.Top := 340;
  lblEU.Width := 71;
  lblEU.Height := 13;
  lblEU.Caption := 'Energy Usage:' + floattoStrf(itemEU, fffixed, 8, 2) +
    ' kWh/unit';

  imgItem := TImage.Create(self.Owner);
  imgItem.Picture.LoadFromFile('cross.png');
  imgItem.Center := true;
  imgItem.Parent := self;
  imgItem.Left := 150;
  imgItem.Top := 40;
  imgItem.Width := 180;
  imgItem.Height := 165;
  imgItem.Center := true;
  imgItem.Stretch := true;
  // load image

  ttask.Run(
    procedure
    begin
      CoInitialize(nil);
      try
        imageStream := DataModule1.loadItemImage(itemID);
        tthread.Synchronize(nil,
          procedure
          begin
            imgItem.Picture.LoadFromStream(imageStream);
          end);
      finally
        CoUninitialize;
      end
    end);

  pnlViewItem := tPanel.Create(self.Owner);
  pnlViewItem.ParentBackground := false;
  pnlViewItem.ParentColor := false;
  pnlViewItem.Parent := self;

  pnlViewItem.Color := $0079DF84;
  pnlViewItem.Left := 150;
  pnlViewItem.Top := 380;
  pnlViewItem.Width := 180;
  pnlViewItem.Height := 50;

  btnViewItem := tSpeedButton.Create(self.Owner);
  btnViewItem.Parent := pnlViewItem;
  btnViewItem.Align := alClient;
  btnViewItem.Flat := true;
  btnViewItem.Caption := 'View Item';
  btnViewItem.OnClick := self.onViewItem;

end;

procedure BrowseItem.onViewItem(Sender: TObject);
begin

  self.viewProcedure(self.itemSeller, self.itemID);

end;

end.
