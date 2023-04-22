unit CheckOut_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Data.win.ADODB,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage, CartItem_u,
  System.Generics.Collections, ItemContainer_u;

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
    userID: string;
    Cart: tObjectDictionary<string, integer>;
    items: tObjectList<CartItem>;
    PriceOrderTotal, CFOrderTotal ,  WUOrderTotal, EUOrderTotal : double;
    procedure removeItem(itemID: string);
    procedure updateItemQuantity(itemID : string; iQuantity: integer);
    procedure updateDisplay();
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
  frmCheckout.Hide;
  frmBrowse.Cart := self.Cart;
  frmBrowse.Show;
end;

procedure TfrmCheckout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmCheckout.FormShow(Sender: TObject);
begin
updateDisplay;


end;

procedure TfrmCheckout.removeItem(itemID: string);
begin
  //
  Cart.Remove(itemID);
  updateDisplay;
end;

procedure TfrmCheckout.updateDisplay;
var
  item: tPair<String, integer>;
  currentItem : CartItem;
begin
  //
  if Cart = nil then
  begin
    Exit;
  end;

  if items <> nil then
    items.Free;

  items := tObjectList<CartItem>.create();

  CFOrderTotal := 0;
  WUOrderTotal := 0;
  EUOrderTotal := 0;
  PriceOrderTotal := 0;

  for item in Cart do
  begin
    currentItem := CartItem.create(self, flpnlItems, item.Key, item.Value, self.removeItem, self.updateItemQuantity);
    CFOrderTotal := CFOrderTotal + currentItem.itemTotalCF;
    WUOrderTotal := WUOrderTotal + currentItem.itemTotalWU;
    EUOrderTotal := EUOrderTotal + currentItem.itemTotalEU;
    PriceOrderTotal := PriceOrderTotal + currentItem.itemTotalPrice;
    items.Add(currentItem);
  end;

  lblTotalCost.Caption:= 'Total Cost: '+ floatTOStrf(PriceOrderTotal, ffCurrency, 8,2);
  lblTotalCF.Caption := 'Total Carbon Footprint: '+ floatTOStrf(CFOrderTotal, fffixed, 8,2);
  lblTotalEU.Caption := 'Total Energy Usage: '+ floatTOStrf(EUOrderTotal, fffixed, 8,2);
  lblTotalWU.Caption := 'Total Water Usage: '+ floatTOStrf(WUOrderTotal, fffixed, 8,2);

end;

procedure TfrmCheckout.updateItemQuantity(itemID: string; iQuantity: integer);
begin
self.Cart.AddOrSetValue(itemID, iQuantity);
end;

end.
