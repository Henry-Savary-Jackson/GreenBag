unit CartItem_u;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage,ItemContainer_u;

type
  CartItem = class(ItemContainer)

  private
    grpRemoveItem: TGroupBox;
    imgRemoveItem: TImage;
    lblQuantity: TLabel;
    redItemInfo: TRichEdit ;
    spnQuantity: TSpinEdit ;
    iQuantity : integer;
  public
    Constructor Create(Owner: TForm; Parent : TWinControl; ItemID: string;iQuantity: integer) ;
    procedure createDesign(); override;
    procedure Remove(Sender: TObject); override;


  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi', [CartItem]);
end;

Constructor CartItem.Create(Owner: tForm; Parent : TWinControl; ItemID: string;iQuantity: integer) ;
begin;
  //
  self.iQuantity:= iQuantity;
  Inherited Create(Owner, Parent, ItemID);


end;

procedure CartItem.createDesign();
begin

// set container's properties
  AlignWithMargins := True;
  Width := 1150 ;
  Height := 240   ;
  Margins.Left := 5 ;
  Margins.Right := 5 ;
  Margins.Bottom := 5  ;
  Align := alTop ;
  TabOrder := 0  ;

  //lblQuantity's properties
  lblQuantity := TLabel.Create(self.Owner);
  lblQuantity.Parent := self;
  lblQuantity.Left := 570  ;
  lblQuantity.Top := 100;
  lblQuantity.Width := 46    ;
  lblQuantity.Height := 13    ;
  lblQuantity.AlignWithMargins := True ;
  lblQuantity.Margins.Right := 10;
  lblQuantity.Caption := 'Quantity:';
//
  redItemInfo := TRichEdit.Create(self.Owner);
  redItemInfo.Parent := self;

  redItemInfo.Left := 40;
  redItemInfo.Top := 40;
  redItemInfo.Width := 400;
  redItemInfo.Height := 180;
  redItemInfo.Margins.Right := 20;
  redItemInfo.AlignWithMargins := True;
  redItemInfo.Font.Charset := ANSI_CHARSET ;
  redItemInfo.Font.Color := clWindowText ;
  redItemInfo.Font.Height := 12;
  redItemInfo.Font.Name := 'Tahoma';
  redItemInfo.Font.Style := []   ;
  redItemInfo.ParentFont := True;
  redItemInfo.TabOrder := 0 ;
  redItemInfo.Zoom := 100 ;

  //grpRemoveItem's properties

  grpRemoveItem :=  TgroupBox.Create(self.Owner);
  grpRemoveItem.Parent := self;
  grpRemoveItem.AlignWithMargins := True ;
  grpRemoveItem.Left := 480  ;
  grpRemoveItem.Top := 25 ;
  grpRemoveItem.Width := 180 ;
  grpRemoveItem.Margins.Left := 20 ;
  grpRemoveItem.Margins.Top := 10 ;
  grpRemoveItem.Margins.Right := 20 ;
  grpRemoveItem.Margins.Bottom := 20 ;
  grpRemoveItem.Align := alRight;
  grpRemoveItem.Color := clScrollBar ;
  grpRemoveItem.ParentBackground := False ;
  grpRemoveItem.ParentColor := False ;
  grpRemoveItem.TabOrder := 2 ;
  grpRemoveItem.OnClick := self.Remove ;

  //imgRemoveItem's properties
  imgRemoveItem :=  TImage.Create(self.Owner);
  imgRemoveItem.Parent := grpRemoveItem;
  imgRemoveItem.AlignWithMargins := True ;
  imgRemoveItem.Left := 7 ;
  imgRemoveItem.Top := 15 ;
  imgRemoveItem.Margins.Left := 5;
  imgRemoveItem.Margins.Top := 0 ;
  imgRemoveItem.Margins.Right := 5 ;
  imgRemoveItem.Margins.Bottom := 5 ;
  imgRemoveItem.Align := alClient;
  imgRemoveItem.Center := True;
  imgRemoveItem.Picture.LoadFromFile('cross.png');
  imgRemoveItem.OnClick := self.remove ;

  spnQuantity :=  TSpinEdit.Create(self.Owner);
  spnQuantity.Parent := self;
  spnQuantity.Left := 680;
  spnQuantity.Top := 100;
  spnQuantity.Width := 80;
  spnQuantity.Height := 22 ;
  spnQuantity.MaxValue := 1000;
  spnQuantity.MinValue := 0;
  spnQuantity.TabOrder := 1;
  spnQuantity.Value := self.iQuantity ;

end;

procedure CartItem.Remove(Sender: TObject);
begin
  showMessage('Lollololll');
end;


end.

