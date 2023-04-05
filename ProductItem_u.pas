unit ProductItem_u;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage, ItemContainer_u;

type
  ProductItem = class(ItemContainer)
  private

  public
    Constructor Create(Owner: TComponent; Parent : TWinControl; ItemID: string;iQuantity: integer) ;
    procedure createDesign(); override;
    procedure remove(Sender: TObject);override;

  end;

implementation

Constructor ProductItem.Create(Owner: TComponent; Parent : TWinControl; ItemID: string;iQuantity: integer) ;
begin
//
Inherited Create(Owner, Parent, ItemID);

end;

procedure ProductItem.createDesign();
begin
  //
end;

procedure ProductItem.remove(Sender: TObject);
begin
  //
end;

end.
