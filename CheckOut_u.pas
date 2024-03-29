unit CheckOut_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Data.win.ADODB,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage, CartItem_u,
  System.Generics.Collections, ItemContainer_u, DMUnit_u, Vcl.Buttons, Math;

type
  TfrmCheckout = class(TForm)
    flpnlItems: TFlowPanel;
    scrbxItems: TScrollBox;
    lblTotalCost: TLabel;
    lblTotalCF: TLabel;
    lblTotalEU: TLabel;
    lblTotalWU: TLabel;
    pnlBack: TPanel;
    pnlHelp: TPanel;
    spnHelp: TSpeedButton;
    SpeedButton1: TSpeedButton;
    btnCheckout: TSpeedButton;
    pnlCheckout: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    items: tObjectList<CartItem>;
    PriceOrderTotal, CFOrderTotal, WUOrderTotal, EUOrderTotal: double;
    procedure removeItem(shoppingCartItemID: string);
    procedure updateItemQuantity(itemID: string; iQuantity: integer;
      Cost: double);
    procedure updateDisplay();
    procedure updateLabels();
  end;

var
  frmCheckout: TfrmCheckout;

implementation

uses
  BrowseItems_u, HelpScreen_u;

{$R *.dfm}

procedure TfrmCheckout.btnBackClick(Sender: TObject);
begin
  frmCheckout.Hide;
  frmBrowse.Show;
end;

procedure TfrmCheckout.btnCheckoutClick(Sender: TObject);
begin
  try
    if items.Count = 0 then
    begin
      showMessage('Can''t checkout with an empty cart.');
      Exit;
    end;

    DataModule1.CheckoutCart(DataModule1.CartID);
    // delete the user's cart and create a new one
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

procedure TfrmCheckout.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmCheckout.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Application.Terminate;

end;

procedure TfrmCheckout.FormShow(Sender: TObject);
begin

  updateDisplay;

end;

// event handler for removing an item from cart
procedure TfrmCheckout.removeItem(shoppingCartItemID: string);
begin
  try
    // change db
    DataModule1.removeFromCart(shoppingCartItemID);
    updateDisplay;

  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;

  end;
end;

// update the gui
procedure TfrmCheckout.updateDisplay;
var
  item: tPair<String, integer>;
  dsCartItems: tAdoDataSet;
  currentItem: CartItem;
begin

  if items <> nil then
    FreeAndNil(items);

  items := tObjectList<CartItem>.create();

  dsCartItems := DataModule1.getCartItems(DataModule1.CartID);

  dsCartItems.First;

  // instantiate gui for each cart item
  while not dsCartItems.Eof do
  begin

    currentItem := CartItem.create(self, flpnlItems, dsCartItems,
      self.removeItem, self.updateItemQuantity);
    items.Add(currentItem);

    dsCartItems.Next;
  end;

  updateLabels;

end;

procedure TfrmCheckout.updateItemQuantity(itemID: string; iQuantity: integer;
  Cost: double);
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

// update totals
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
    fffixed, 8, 2) + ' t/unit';
  lblTotalEU.Caption := 'Total Energy Usage: ' + floatTOStrf(EUOrderTotal,
    fffixed, 8, 2) + ' kWh/unit';
  lblTotalWU.Caption := 'Total Water Usage: ' + floatTOStrf(WUOrderTotal,
    fffixed, 8, 2) + ' L/unit';
end;

end.
