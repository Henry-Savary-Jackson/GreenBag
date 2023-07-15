unit YourProducts_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.Win.ADODB,
  Vcl.ExtCtrls,
  System.ImageList, DMUnit_u, Vcl.ImgList, Vcl.Imaging.pngimage,
  System.Generics.Collections, ProductItem_u, Vcl.Buttons;

type
  TfrmYourProducts = class(TForm)
    flpnlProducts: TFlowPanel;
    scrbxProducts: TScrollBox;
    pnlBack: TPanel;
    btnBack: TSpeedButton;
    pnlAddItem: TPanel;
    btnAddItem: TSpeedButton;
    pnlHelp: TPanel;
    spnHelp: TSpeedButton;
    procedure btnAddItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnViewItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure removeProcedure(itemID: string);
    procedure btnHelpClick(Sender: TObject);
    procedure btnLoadMoreItemsClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
    items: tObjectDictionary<string, ProductItem>;
    scrollRangeMin: integer;
    scrollRangeMax: integer;
    btnLoadMoreitems: tButton;
    procedure updateItemsDisplay;
  end;

var
  frmYourProducts: TfrmYourProducts;

implementation

uses
  Profile_u,
  Additem_u, HelpScreen_u;

{$R *.dfm}

procedure TfrmYourProducts.btnAddItemClick(Sender: TObject);
begin
  frmYourProducts.Hide;
  datamodule1.lastForm := self;
  frmAddItem.Show;
end;

procedure TfrmYourProducts.btnBackClick(Sender: TObject);
begin
  frmYourProducts.Hide;
  frmProfile.Show;
end;

procedure TfrmYourProducts.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmYourProducts.btnLoadMoreItemsClick(Sender: TObject);
begin
  //
  scrollRangeMin := scrollRangeMin + 10;
  scrollRangeMax := scrollRangeMax + 10;
  updateItemsDisplay;
end;

procedure TfrmYourProducts.btnViewItemClick(Sender: TObject);
begin
  frmYourProducts.Hide;
  datamodule1.lastForm := self;
  frmAddItem.Show;
end;

procedure TfrmYourProducts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    try
      datamodule1.CancelCart(datamodule1.CartID);

    except
      on e: exception do
      begin
        showMessage(e.Message);
      end;

    end;

  finally
    Application.Terminate;
  end;
end;

procedure TfrmYourProducts.FormShow(Sender: TObject);
begin
  if items <> nil then
  begin
    items.Free;
    items := tObjectDictionary<string, ProductItem>.Create([doOwnsValues]);
  end;
  scrollRangeMin := 0;
  scrollRangeMax := 10;
  updateItemsDisplay;
end;

procedure TfrmYourProducts.removeProcedure(itemID: string);
var
  itemToBeDeleted: ProductItem;
begin
  if MessageDlg('Are you sure you want to delete this item?', mtConfirmation,
    [mbYes, mbNo], 0, mbNo) = mryes then
  begin
    datamodule1.deleteItem(itemID);
    items.TryGetValue(itemID, itemToBeDeleted);
    itemToBeDeleted.Hide;
  end;

end;

procedure TfrmYourProducts.updateItemsDisplay;
var
  dsResult: tADODataSet;
  currentItem: ProductItem;
begin

  try

    dsResult := datamodule1.getProducts(datamodule1.userID, scrollRangeMin,
      scrollRangeMax);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    if btnLoadMoreitems <> nil then
    begin
      btnLoadMoreItems.Free;
      btnLoadMoreItems := nil;
    end;

    dsResult.First;

    while not dsResult.Eof do
    begin
      currentItem := ProductItem.Create(self, flpnlProducts, dsResult,
        self.removeProcedure);
      items.add(currentItem.itemID, currentItem);
      dsResult.Next;
    end;

    if scrollRangeMax - scrollRangeMin = dsResult.RecordCount then
    begin
      btnLoadMoreitems := tButton.Create(self.Owner);
      btnLoadMoreitems.Caption := 'load More items';
      btnLoadMoreitems.OnClick := btnLoadMoreItemsClick;
      btnLoadMoreitems.Parent := flpnlProducts;
      btnLoadMoreitems.Width := 500;
    end;

  finally
    if Assigned(dsResult) then
      dsResult.Free;

  end;

end;

end.
