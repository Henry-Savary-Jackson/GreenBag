unit CheckOut_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Data.win.ADODB,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage, CartItem_u,
  System.Generics.Collections, ItemContainer_u, DMUnit_u, Vcl.Buttons, Math,
  ActiveX, System.threading;

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
    Panel1: TPanel;
    btnReturn: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
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

  // prevent spamming of button while waiting for callback
  btnCheckout.Enabled := False;
  btnReturn.Enabled := False;
  try
    if items.Count = 0 then
    begin
      showMessage('Can''t checkout with an empty cart.');
      Exit;
    end;

    ttask.Run(
      procedure
      begin
        try

          CoInitialize(nil);
          try
            DataModule1.CheckoutCart(DataModule1.username,
              DataModule1.jwtToken);
            // delete the user's cart and create a new one
            DataModule1.CreateUserCart(DataModule1.username,
              DataModule1.jwtToken);

            tthread.Synchronize(nil,
              procedure
              begin
                frmCheckout.Hide;
                frmBrowse.Show;
              end);

          except
            on e: exception do
            begin
              showMessage(e.Message);
            end;

          end;
        finally
          // renable egardless of errors
          CounInitialize;
          tthread.Synchronize(nil,
            procedure
            begin
              btnCheckout.Enabled := true;
              btnReturn.Enabled := true;
            end);

        end

      end

      )

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

procedure TfrmCheckout.btnReturnClick(Sender: TObject);
begin

  // diable buttons to prevent being pressed while waiting for callback to complete
  btnCheckout.Enabled := False;
  btnReturn.Enabled := False;
  ttask.Run(
    procedure
    begin
      CoInitialize(nil);
      try
        DataModule1.CancelCart(DataModule1.username, DataModule1.jwtToken);
        DataModule1.CreateUserCart(DataModule1.username, DataModule1.jwtToken);

        tthread.Synchronize(nil,
          procedure
          begin
            items.Clear;
            updateDisplay;
          end);
      finally
        // renable them no matter what exceptions occur
        CounInitialize();
        btnCheckout.Enabled := true;
        btnReturn.Enabled := true;
      end
    end);

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
    ttask.Run(
      procedure
      begin
        CoInitialize(nil);

        try
          DataModule1.removeFromCart(shoppingCartItemID, DataModule1.jwtToken,
            DataModule1.username);

          tthread.Synchronize(nil,
            procedure
            begin
              updateDisplay;
            end);

        finally
          CounInitialize();
        end

      end);

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

  btnReturn.Enabled := False;
  btnCheckout.Enabled := False;
  ttask.Run(
    procedure
    begin

      CoInitialize(nil);

      try
        dsCartItems := DataModule1.getCartItems(DataModule1.username,
          DataModule1.jwtToken);

        try

          tthread.Synchronize(nil,
            procedure
            begin
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
            end);
        finally
          dsCartItems.Free;
        end
      finally
        CounInitialize;
        tthread.Synchronize(nil,
          procedure
          begin
            btnReturn.Enabled := true;
            btnCheckout.Enabled := true;
          end);
      end

    end);

end;

procedure TfrmCheckout.updateItemQuantity(itemID: string; iQuantity: integer;
Cost: double);
begin

  btnCheckout.Enabled := false;
  btnReturn.Enabled := false;
  ttask.Run(
    procedure
    begin

      try
        try
          CoInitialize(nil);

          DataModule1.addToCart(DataModule1.username, itemID,
            DataModule1.jwtToken, iQuantity);

          tthread.Synchronize(nil,
            procedure
            begin
              updateLabels;
            end);

        except
          on e: exception do
          begin

            showMessage(e.Message);
          end;

        end;
      finally
        CounInitialize();
        tthread.Synchronize(nil,
          procedure
          begin
            btnCheckout.Enabled := true;

            btnReturn.Enabled := true;
          end);
      end
    end);

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
