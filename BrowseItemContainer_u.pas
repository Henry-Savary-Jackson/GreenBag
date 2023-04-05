unit BrowseItemContainer_u;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage,ItemContainer_u,BrowseItems_u, ViewItem_u, AddItem_u;

type
  BrowseItem = class(ItemContainer)
  public
    Constructor Create(Owner: TComponent; Parent : TWinControl; ItemID: string;iQuantity: integer) ;
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
Constructor BrowseItem.Create(Owner: TComponent; Parent : TWinControl; ItemID: string;iQuantity: integer) ;
begin;
  //
  self.itemID := ItemID;
  Inherited Create(Owner, Parent, ItemID);
end;

procedure BrowseItem.createDesign();
begin

  self.Left := 11 ;
  Top := 11;
  Width := 238;
  Height := 230 ;
  Margins.Left := 10  ;
  Margins.Top := 10 ;
  Margins.Right := 10;
  Margins.Bottom := 10;
  Align := alLeft  ;
  Caption := 'Itemname';
  TabOrder := 0  ;

  lblPrice := TLabel.Create(self.Owner);
  lblPrice.Parent := self;

  lblPrice.Left := 64;
  lblPrice.Top := 179;
  lblPrice.Width := 27;
  lblPrice.Height := 13 ;
  lblPrice.Caption := 'Price:';

  lblCF := TLabel.Create(self.Owner);
  lblCF.Parent := self;
  lblCF.Left := 56 ;
  lblCF.Top := 122 ;
  lblCF.Width := 82 ;
  lblCF.Height := 13 ;
  lblCF.Caption := 'Carbon Footprint:';

  lblWU := TLabel.Create(self.Owner);
  lblWU.Parent := self;
  lblWU.Left := 67;
  lblWU.Top := 160;
  lblWU.Width := 67;
  lblWU.Height := 13;
  lblWU.Caption := 'Water Usage:';


  lblEU := TLabel.Create(self.Owner);
  lblEU.Parent := self;
  lblEU.Left := 64;
  lblEU.Top := 141;
  lblEU.Width := 71;
  lblEU.Height := 13;
  lblEU.Caption := 'Energy Usage:';

  imgItem := TImage.Create(self.Owner);
  imgItem.Parent := self;
  imgItem.Left := 66;
  imgItem.Top := 22;
  imgItem.Width := 100;
  imgItem.Height := 94;
  imgItem.Center := True;

  btnViewItem := TButton.Create(self.Owner);
  btnViewItem.Parent := self;
  btnViewItem.Left := 74;
  btnViewItem.Top := 198 ;
  btnViewItem.Width := 75 ;
  btnViewItem.Height := 25 ;
  btnViewItem.Caption := 'View Item';
  btnViewItem.TabOrder := 0 ;
  btnViewItem.OnClick := self.viewItem ;

end;

procedure BrowseItem.viewItem(Sender : TOBject);
begin
  frmViewItem.Show;
  frmBrowse.Hide;
end;
{
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
            Left = 74
            Top = 198
            Width = 75
            Height = 25
            Caption = 'View Item'
            TabOrder = 0
            OnClick = btnViewItemClick
          end
        end
}

end.
