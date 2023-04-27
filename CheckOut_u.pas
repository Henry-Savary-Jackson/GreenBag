unit CheckOut_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Data.win.ADODB,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage, CartItem_u,
  System.Generics.Collections, ItemContainer_u, DMUnit_u;

type
  TfrmCheckout = class(TForm)
    btnBack: TButton;
    flpnlItems: TFlowPanel;
    btnCheckout: TButton;
    scrbxItems: TScrollBox;
    lblTotalCost: TLabel;
    lblTotalCF: TLabel;
    lblTotalEU: TLabel;
    lblTotalWU: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    items: tObjectList<CartItem>;
    PriceOrderTotal, CFOrderTotal, WUOrderTotal, EUOrderTotal: double;
    procedure removeItem(shoppingCartItemID: string);
    procedure updateItemQuantity(itemID: string; iQuantity: integer);
    procedure updateDisplay();
    procedure updateLabels();
  end;

var
  frmCheckout: TfrmCheckout;

implementation

uses
  BrowseItems_u;

{$R *.dfm}

procedure TfrmCheckout.btnBackClick(Sender: TObject);
begin
  frmCheckout.Hide;
  frmBrowse.Show;
end;

procedure TfrmCheckout.btnCheckoutClick(Sender: TObject);
begin
  try
    DataModule1.completeTransactions(DataModule1.CartID);
    DataModule1.CartID := DataModule1.CreateUserCart(DataModule1.userID);
    frmCheckout.Hide;
    frmBrowse.Show;
  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;

  end;
end;

procedure TfrmCheckout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    try
      DataModule1.CancelCart(DataModule1.CartID);

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

procedure TfrmCheckout.FormShow(Sender: TObject);
begin

  updateDisplay;

end;

procedure TfrmCheckout.removeItem(shoppingCartItemID: string);
begin
  try
    DataModule1.removeFromCart(shoppingCartItemID);
    updateDisplay;

  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;

  end;
end;

procedure TfrmCheckout.updateDisplay;
var
  item: tPair<String, integer>;
  dsCartItems: TADODataSet;
  currentItem: CartItem;
begin

  if items <> nil then
    items.Free;

  items := tObjectList<CartItem>.Create();

  dsCartItems := DataModule1.getCartItems(DataModule1.CartID);

  dsCartItems.First;

  while not dsCartItems.Eof do
  begin

    currentItem := CartItem.Create(self, flpnlItems,
      dsCartItems['ShoppingCartItemID'], self.removeItem,
      self.updateItemQuantity);
    items.Add(currentItem);

    dsCartItems.Next;
  end;

  updateLabels;

end;

procedure TfrmCheckout.updateItemQuantity(itemID: string; iQuantity: integer);
begin
  try
    DataModule1.addToCart(DataModule1.CartID, itemID, iQuantity);
    updateLabels;

  except
    on e: exception do
    begin

      showMessage(e.Message);
    end;

  end;
end;

procedure TfrmCheckout.updateLabels;
var
  item: CartItem;
begin

  CFOrderTotal := 0;
  WUOrderTotal := 0;
  EUOrderTotal := 0;
  PriceOrderTotal := 0;

  for item in items do
  begin
    CFOrderTotal := CFOrderTotal + item.itemTotalCF;
    WUOrderTotal := WUOrderTotal + item.itemTotalWU;
    EUOrderTotal := EUOrderTotal + item.itemTotalEU;
    PriceOrderTotal := PriceOrderTotal + item.itemTotalPrice;
  end;

  lblTotalCost.Caption := 'Total Cost: ' + floatTOStrf(PriceOrderTotal,
    ffCurrency, 8, 2);
  lblTotalCF.Caption := 'Total Carbon Footprint: ' + floatTOStrf(CFOrderTotal,
    fffixed, 8, 2);
  lblTotalEU.Caption := 'Total Energy Usage: ' + floatTOStrf(EUOrderTotal,
    fffixed, 8, 2);
  lblTotalWU.Caption := 'Total Water Usage: ' + floatTOStrf(WUOrderTotal,
    fffixed, 8, 2);
end;

end.
