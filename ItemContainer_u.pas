unit ItemContainer_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls,Vcl.StdCtrls,Vcl.Dialogs, vcl.Forms;

type
  ItemContainer = class(TGroupBox)

  public
    itemID : string;
    Owner : tForm;
    Constructor Create(Owner: tForm; Parent : TWinControl; ItemID: string); virtual ;
    procedure createDesign(); virtual; abstract;

  end;

implementation
Constructor ItemContainer.Create(Owner: tForm; Parent : TWinControl; ItemID: string) ;
begin
  inherited Create(Owner);
  self.Owner := Owner;
  self.Parent := Parent;
  // instantiate gui
  self.createDesign;
  self.itemID := ItemID;
end;


end.
