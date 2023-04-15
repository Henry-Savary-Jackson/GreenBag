unit ViewItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin, DMUnit_u, System.Generics.Collections, Data.Win.ADODB;

type
  TfrmViewItem = class(TForm)
    btnBack: TButton;
    Image1: TImage;
    btnAddToCart: TButton;
    redDesc: TRichEdit;
    lblDesc: TLabel;
    lblCategory: TLabel;
    lblCFProduce: TLabel;
    lblEUProduce: TLabel;
    lblWUProduce: TLabel;
    lblPrice: TLabel;
    lblName: TLabel;
    lblSeller: TLabel;
    spnQuantity: TSpinEdit;
    lblQuantity: TLabel;
    lblRating: TLabel;
    trcRating: TTrackBar;
    lblYourRating: TLabel;
    btnSendRating: TButton;
    lblCF: TLabel;
    lblEU: TLabel;
    lblWU: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddToCartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSendRatingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    userID: string;
    itemID: string;
    Cart: tObjectDictionary<string, integer>;
  end;

var
  frmViewItem: TfrmViewItem;

implementation

uses
  BrowseItems_u;

{$R *.dfm}

procedure TfrmViewItem.btnAddToCartClick(Sender: TObject);
var
quantity : integer;
cartQuantity : integer;
begin;

  quantity := spnQuantity.Value;

  if cart = nil then
    showMessage('NullPointerexception');


  if not cart.ContainsKey(itemId) then
  begin
    Cart.Add(itemID, quantity);
  end
  else
  begin
    cart.TryGetValue(itemid, cartquantity);
    cart.AddOrSetValue(itemid, cartQuantity + quantity );
  end;
  frmViewItem.Hide;
  frmBrowse.Show;
end;

procedure TfrmViewItem.btnBackClick(Sender: TObject);
begin
  frmViewItem.Hide;
  frmBrowse.Show;
end;

procedure TfrmViewItem.btnSendRatingClick(Sender: TObject);
var
  rating: integer;

begin
  rating := trcRating.Position;
  DataModule1.sendRating(itemID, rating);
  showMessage('Your feedback has been sent.');
end;

procedure TfrmViewItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmViewItem.FormShow(Sender: TObject);
var
  dsResult: TADODataSet;
begin
  //
  dsResult := DataModule1.viewItem(itemID);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    ShowMessage(dsResult['Status']);
    dsResult.Free;
    Exit;
  end;

  lblName.Caption := 'Name :' + dsResult['ItemName'];
  lblSeller.Caption := 'Seller: ' + dsResult['SellerName'];
  lblPrice.Caption := 'Price: ' + floatToStrf(dsResult['Cost'],
    ffCurrency, 8, 2);

  lblCF.Caption := 'Carbon footprint through usage: ' +
    floatToStrf(dsResult['CarbonFootprintUsage'] , fffixed, 8, 2);

  lblEU.Caption := 'Energy consumption through usage: ' +
    floatToStrf(dsResult['EnergyFootprintUsage'] ,fffixed, 8, 2);

  lblWU.Caption := 'Water consumption through usage:' +
    floatToStrf(dsResult['WaterFootprintUsage'] , fffixed, 8, 2);

  lblCFProduce.Caption := 'Carbon footprint for production: ' +
    floatToStrf(dsResult['CarbonFootprintProduction'] , fffixed, 8, 2);

  lblEUProduce.Caption := 'Energy usage for production: ' +
    floatToStrf(dsResult['EnergyUsageProduction'] , fffixed, 8, 2);

  lblWUProduce.Caption := 'Water usage for production:' +
    floatToStrf(dsResult['WaterUsageProduction'] , fffixed, 8, 2);

  lblRating.Caption := 'Rating: ' + inttosTR(dsResult['Rating']);

  lblCategory.Caption := 'Category: ' + dsResult['Category'];

  redDesc.Text := dsResult['Description'];

  btnSendRating.Enabled := dsResult['SellerID'] <> userID;
  btnAddToCart.Enabled := dsResult['SellerID'] <>userID;

  spnQuantity.Value := 1;


end;

end.
