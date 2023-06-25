unit CartItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Samples.Spin, DMUnit_u, Data.win.adodb, Vcl.Imaging.pngimage,
  ItemContainer_u, System.Generics.Collections, Data.DB;

type
  tRemoveProcedure = procedure(itemID: string) of object;

type
  tUpdateQuantityProcedure = procedure(itemID: string; iQuantity: integer;
    Cost: double) of object;

type
  CartItem = class(ItemContainer)

  private
    grpRemoveItem: TGroupBox;
    imgRemoveItem: TImage;
    lblQuantity: TLabel;
    redItemInfo: TRichEdit;
    spnQuantity: TSpinEdit;
    iQuantity: integer;
    imageStream: TStream;

    SellerId: string;
    shoppingCartItemID: string;
    itemName, itemID, itemSeller: string;
    itemCFProduce, itemWUProduce, itemEUProduce, itemCF, itemWU, itemEU,
      itemPrice: double;
    removeProcedure: tRemoveProcedure;
    updateQuantityProcedure: tUpdateQuantityProcedure;

  public
    Constructor Create(Owner: TForm; Parent: TWinControl;
      shoppingCartItemID: string; remove: tRemoveProcedure;
      updateQuantity: tUpdateQuantityProcedure);
    procedure createDesign(); override;
    procedure onRemoveClick(Sender: tObject);
    procedure onSpnQuantityChange(Sender: tObject);
    procedure updateInfo();
    procedure UpdateRedInfo();

  public
    itemTotalPrice, itemTotalCF, itemTotalWU, itemTotalEU: double;
    maxwithdraw: integer;

  end;

implementation

Constructor CartItem.Create(Owner: TForm; Parent: TWinControl;
  shoppingCartItemID: string; remove: tRemoveProcedure;
  updateQuantity: tUpdateQuantityProcedure);
var
  sql: string;
  params: TObjectDictionary<string, variant>;
  dsResult: TADODataSet;

begin;

  self.removeProcedure := remove;
  self.updateQuantityProcedure := updateQuantity;
  self.shoppingCartItemID := shoppingCartItemID;

  sql := 'SELECT ShoppingCartItemsTB.Quantity, ShoppingCartItemsTB.ItemID , ItemTB.ItemName , ItemTB.Cost, ItemTB.MaxWithdrawableStock as MaxStock, '
    + ' ItemTB.CarbonFootprintProduction AS CFProduce , ItemTB.CarbonFootprintUsage AS CF , '
    + '  ItemTB.WaterUsageProduction AS WUProduce , ItemTB.WaterFootprintUsage AS WU , '
    + 'ItemTB.EnergyUsageProduction AS EUProduce , ItemTB.EnergyFootprintUsage AS EU '
    + ' FROM ShoppingCartItemsTB INNER JOIN ItemTB ON ItemTB.ItemID = ShoppingCartItemsTB.ItemID '
    + '  WHERE ShoppingCartItemID = :ShoppingCartItemID';

  params := TObjectDictionary<string, variant>.Create();
  params.Add('ShoppingCartItemID', self.shoppingCartItemID);

  try
    dsResult := DataModule1.runSQL(sql, params);

    if dsResult.IsEmpty then
    begin
      showMessage('Error: Item does not exist.');
      Exit;
    end;

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    self.iQuantity := dsResult['Quantity'];
    self.itemID := dsResult['ItemID'];
    self.itemPrice := dsResult['Cost'];
    self.itemName := dsResult['ItemName'];

    self.itemCF := dsResult['CF'];
    self.itemWU := dsResult['WU'];
    self.itemEU := dsResult['EU'];

    self.itemCFProduce := dsResult['CFProduce'];
    self.itemWUProduce := dsResult['WUProduce'];
    self.itemEUProduce := dsResult['EUProduce'];

    self.maxwithdraw := dsResult['MaxStock'];

    self.updateInfo;
    Inherited Create(Owner, Parent, itemID);

  finally
    if Assigned(dsResult) then
      dsResult.Free;
    params.Free;
  end;

end;

procedure CartItem.createDesign();
begin

  // set container's properties
  AlignWithMargins := True;
  Width := 1150;
  Height := 240;
  Margins.Left := 5;
  Margins.Right := 5;
  Margins.Bottom := 5;
  Align := alTop;
  TabOrder := 0;

  // lblQuantity's properties
  lblQuantity := TLabel.Create(self.Owner);
  lblQuantity.Parent := self;
  lblQuantity.Left := 570;
  lblQuantity.Top := 100;
  lblQuantity.Width := 46;
  lblQuantity.Height := 13;
  lblQuantity.AlignWithMargins := True;
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
  redItemInfo.Font.Charset := ANSI_CHARSET;
  redItemInfo.Font.Color := clWindowText;
  redItemInfo.Font.Height := 12;
  redItemInfo.Font.Name := 'Tahoma';
  redItemInfo.Font.Style := [];
  redItemInfo.ParentFont := True;
  redItemInfo.TabOrder := 0;
  redItemInfo.Zoom := 100;

  self.UpdateRedInfo;

  // grpRemoveItem's properties

  grpRemoveItem := TGroupBox.Create(self.Owner);
  grpRemoveItem.Parent := self;
  grpRemoveItem.AlignWithMargins := True;
  grpRemoveItem.Left := 480;
  grpRemoveItem.Top := 25;
  grpRemoveItem.Width := 180;
  grpRemoveItem.Margins.Left := 20;
  grpRemoveItem.Margins.Top := 10;
  grpRemoveItem.Margins.Right := 20;
  grpRemoveItem.Margins.Bottom := 20;
  grpRemoveItem.Align := alRight;
  grpRemoveItem.Color := clScrollBar;
  grpRemoveItem.ParentBackground := False;
  grpRemoveItem.ParentColor := False;
  grpRemoveItem.TabOrder := 2;
  grpRemoveItem.OnClick := self.onRemoveClick;

  // imgRemoveItem's properties
  imgRemoveItem := TImage.Create(self.Owner);
  imgRemoveItem.Parent := grpRemoveItem;
  imgRemoveItem.AlignWithMargins := True;
  imgRemoveItem.Left := 7;
  imgRemoveItem.Top := 15;
  imgRemoveItem.Margins.Left := 5;
  imgRemoveItem.Margins.Top := 0;
  imgRemoveItem.Margins.Right := 5;
  imgRemoveItem.Margins.Bottom := 5;
  imgRemoveItem.Align := alClient;
  imgRemoveItem.Center := True;
  imgRemoveItem.Picture.LoadFromFile('cross.png');
  imgRemoveItem.OnClick := self.onRemoveClick;

  spnQuantity := TSpinEdit.Create(self.Owner);
  spnQuantity.Parent := self;
  spnQuantity.Left := 680;
  spnQuantity.Top := 100;
  spnQuantity.Width := 80;
  spnQuantity.Height := 22;
  spnQuantity.MaxValue := self.maxwithdraw;
  spnQuantity.MinValue := 1;
  spnQuantity.TabOrder := 1;
  spnQuantity.Value := self.iQuantity;
  spnQuantity.OnChange := self.onSpnQuantityChange;

end;

procedure CartItem.onRemoveClick(Sender: tObject);
begin
  //
  self.removeProcedure(self.shoppingCartItemID);
end;

procedure CartItem.onSpnQuantityChange(Sender: tObject);
var
  oldQuantity: integer;
begin
  //
  oldQuantity := self.iQuantity;
  self.iQuantity := spnQuantity.Value;
  self.updateInfo;
  self.UpdateRedInfo;
  self.updateQuantityProcedure(itemID, self.iQuantity - oldQuantity, itemPrice);
end;

procedure CartItem.updateInfo;
begin
  //
  // add info to reditemInfo

  self.itemTotalPrice := iQuantity * self.itemPrice;

  self.itemTotalCF := (self.itemCF + self.itemCFProduce) * iQuantity;
  self.itemTotalWU := (self.itemWU + self.itemWUProduce) * iQuantity;
  self.itemTotalEU := (self.itemEU + self.itemEUProduce) * iQuantity;

end;

procedure CartItem.UpdateRedInfo;
begin

  redItemInfo.Lines.Clear;

  redItemInfo.Lines.Add('Name : ' + itemName + #13);
  redItemInfo.Lines.Add('Total Cost of order : ' + FloatToStrF(itemTotalPrice,
    ffCurrency, 8, 2));
  redItemInfo.Lines.Add('Total Carbon footprint of order : ' +
    FloatToStrF(itemTotalCF, ffFixed, 8, 2));
  redItemInfo.Lines.Add('Total Water usage of order : ' +
    FloatToStrF(itemTotalWU, ffFixed, 8, 2));
  redItemInfo.Lines.Add('Total Energy usage of order : ' +
    FloatToStrF(itemTotalEU, ffFixed, 8, 2));
end;

end.
