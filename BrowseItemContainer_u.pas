unit BrowseItemContainer_u;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage,ItemContainer_u, ViewItem_u, AddItem_u;

type
  BrowseItem = class(ItemContainer)
  public
    Constructor Create(Owner: tForm; Parent : TWinControl; ItemID: string) ;
    procedure createDesign(); override;
    procedure viewItem(Sender : TObject);
  private
    lblPrice: TLabel;
    lblCF: TLabel;
    lblWU: TLabel;
    lblEU : TLabel;
    imgItem: TImage;
    btnViewItem: TButton;

    itemName, itemSeller : string;
    itemPrice, itemCF, itemWU, itemEU: double;



  end;

implementation
Constructor BrowseItem.Create(Owner: tForm; Parent : TWinControl; ItemID: string) ;
begin;
  //
  self.itemID := ItemID;
  Inherited Create(Owner, Parent, ItemID);
end;

procedure BrowseItem.createDesign();
begin

  Width := 470;
  Height := 470 ;
  self.AlignWithMargins := true;
  Margins.Left := 10  ;
  Margins.Top := 15 ;
  Margins.Right := 10;
  Margins.Bottom := 10;
  Align := alLeft  ;
  Caption := 'Itemname';
  TabOrder := 0  ;

  lblPrice := TLabel.Create(self.Owner);
  lblPrice.Parent := self;

  lblPrice.Left := 140;
  lblPrice.AlignWithMargins := True;
  lblPrice.Margins.Top:= 10;
   lblPrice.Margins.Bottom:= 10;
  lblPrice.Top := 220;
  lblPrice.Width := 27;
  lblPrice.Height := 13 ;
  lblPrice.Caption := 'Price:';

  lblCF := TLabel.Create(self.Owner);
  lblCF.AlignWithMargins := True;
  lblCF.Margins.Top:= 10;
   lblCF.Margins.Bottom:= 10;
  lblCF.Parent := self;
  lblCF.Left := 140 ;
  lblCF.Top := 260 ;
  lblCF.Width := 82 ;
  lblCF.Height := 13 ;
  lblCF.Caption := 'Carbon Footprint:';

  lblWU := TLabel.Create(self.Owner);
  lblWU.AlignWithMargins := True;
  lblWU.Margins.Top:= 10;
   lblWU.Margins.Bottom:= 10;
  lblWU.Parent := self;
  lblWU.Left := 140;
  lblWU.Top := 300;
  lblWU.Width := 67;
  lblWU.Height := 13;
  lblWU.Caption := 'Water Usage:';


  lblEU := TLabel.Create(self.Owner);
  lblEU.AlignWithMargins := True;
  lblEU.Margins.Top:= 10;
  lblEU.Margins.Bottom:= 10;
  lblEU.Parent := self;
  lblEU.Left := 140;
  lblEU.Top := 340;
  lblEU.Width := 71;
  lblEU.Height := 13;
  lblEU.Caption := 'Energy Usage:';

  imgItem := TImage.Create(self.Owner);
  imgItem.Picture.LoadFromFile('cross.png');
  imgItem.Center:= true;
  imgItem.Parent := self;
  imgItem.Left := 150;
  imgItem.Top := 40;
  imgItem.Width := 200;
  imgItem.Height := 190;
  imgItem.Center := True;

  btnViewItem := TButton.Create(self.Owner);
  btnViewItem.Parent := self;
  btnViewItem.Left := 150;
  btnViewItem.Top := 380 ;
  btnViewItem.Width := 150 ;
  btnViewItem.Height := 50 ;
  btnViewItem.Caption := 'View Item';
  btnViewItem.TabOrder := 0 ;
  btnViewItem.OnClick := self.viewItem ;

end;

procedure BrowseItem.viewItem(Sender : TOBject);
var
Owner : tForm;
begin
  frmViewItem.Show;
  self.Owner.Hide;

end;


end.
