unit ItemContainer_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls,Vcl.StdCtrls,Vcl.Dialogs;

type
  ItemContainer = class(TGroupBox)

  public
    itemID : string;
    Constructor Create(Owner: TComponent; Parent : TWinControl; ItemID: string) ;virtual ;
    procedure createDesign(); virtual;
    procedure remove(Sender: TObject); virtual;

  end;

implementation
Constructor ItemContainer.Create(Owner: TComponent; Parent : TWinControl; ItemID: string) ;
begin
  inherited Create(Owner);
  self.Parent := Parent;
  self.createDesign;
  self.itemID := ItemID;
end;

procedure ItemContainer.createDesign();
begin
  //
end;

procedure ItemContainer.remove(Sender: TObject);
begin
  //
end;

end.
