unit ProductItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, DMunit_u, Data.Win.ADODB, Vcl.ImgList, Vcl.Imaging.pngimage,
  ItemContainer_u, addItem_u, System.Generics.Collections, Data.DB;

type
  tRemoveProcedure = procedure(itemID: string) of object;

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
    // any code that needs to be executed by the parent screen
    // when a delete button is clicked is linked to the varaible
    removeProcedure: tRemoveProcedure;
    imageStream: TStream;

  public
    Constructor Create(Owner: tForm; Parent: TWinControl; itemID: string;
      removeProcedure: tRemoveProcedure);
    procedure createDesign(); override;
    procedure viewItem(Sender: tObject);
    // event handling code for the remove button
    procedure onRemoveClick(Sender: tObject);

  end;

implementation

Constructor ProductItem.Create(Owner: tForm; Parent: TWinControl;
  itemID: string; removeProcedure: tRemoveProcedure);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataset;
begin
  self.removeProcedure := removeProcedure;
  //
  sql := 'SELECT ItemName, Sales, Image FROM ItemTB WHERE ItemID = :ItemID';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);
  try
    dsResult := DataModule1.runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    Name := dsResult['ItemName'];
    Sales := dsResult['Sales'];
    // calculate revenue

    imageStream := dsResult.CreateBlobStream
      (dsResult.FieldByName('Image'), bmRead);

    dsResult.Free;

    sql := 'SELECT IIF(SUM(Cost) IS NULL, 0, SUM(Cost)) AS ItemRevenue FROM TransactionItemTB WHERE ItemID = :ItemID';

    dsResult := DataModule1.runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    revenue := dsResult['ItemRevenue'];

    Inherited Create(Owner, Parent, itemID);

  finally
    if Assigned(dsResult) then
      dsResult.Free;
    params.Free;
  end;

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
  imgItem.Stretch := True;

  try
    imgItem.Picture.LoadFromStream(imageStream);

  finally
    imageStream.Free;
  end;

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
  grpRemoveProduct.OnClick := self.onRemoveClick;

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
  imgRemoveProduct.OnClick := self.onRemoveClick;

end;

procedure ProductItem.onRemoveClick(Sender: tObject);
begin
  self.removeProcedure(self.itemID);
end;

procedure ProductItem.viewItem(Sender: tObject);
begin
  //
  self.Owner.Hide;
  DataModule1.lastForm := self.Owner;
  frmAddItem.itemID := itemID;
  frmAddItem.Show;

end;

end.
