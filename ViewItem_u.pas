unit ViewItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin, DMUnit_u, System.Generics.Collections, Data.Win.ADODB,
  Vcl.Imaging.pngimage;

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
    lblStock: TLabel;
    lblMaxWithdraw: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddToCartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSendRatingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    itemID: string;
    stock: integer;
  end;

var
  frmViewItem: TfrmViewItem;

implementation

uses
  BrowseItems_u;

{$R *.dfm}

procedure TfrmViewItem.btnAddToCartClick(Sender: TObject);
var
  quantity: integer;
  cartQuantity: integer;
begin;

  quantity := spnQuantity.Value;

  if stock - quantity < 0 then
  begin
    showMessage('Not enough stock.');
    Exit;
  end;

  try
    DataModule1.addToCart(DataModule1.CartID, itemID, quantity);
    frmViewItem.Hide;
    frmBrowse.Show;

  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;

  end;
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

procedure TfrmViewItem.FormShow(Sender: TObject);
var
  dsResult: TADODataSet;
begin
  //
  dsResult := DataModule1.viewItem(itemID);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    dsResult.Free;
    Exit;
  end;

  lblName.Caption := 'Name :' + dsResult['ItemName'];
  lblSeller.Caption := 'Seller: ' + dsResult['SellerName'];
  lblPrice.Caption := 'Price: ' + floatToStrf(dsResult['Cost'],
    ffCurrency, 8, 2);

  lblStock.Caption := 'Stock: ' + inttostr(dsResult['Stock']);
  stock := dsResult['Stock'];
  lblCF.Caption := 'Carbon footprint through usage: ' +
    floatToStrf(dsResult['CarbonFootprintUsage'], fffixed, 8, 2);

  lblEU.Caption := 'Energy consumption through usage: ' +
    floatToStrf(dsResult['EnergyFootprintUsage'], fffixed, 8, 2);

  lblWU.Caption := 'Water consumption through usage:' +
    floatToStrf(dsResult['WaterFootprintUsage'], fffixed, 8, 2);

  lblCFProduce.Caption := 'Carbon footprint for production: ' +
    floatToStrf(dsResult['CarbonFootprintProduction'], fffixed, 8, 2);

  lblEUProduce.Caption := 'Energy usage for production: ' +
    floatToStrf(dsResult['EnergyUsageProduction'], fffixed, 8, 2);

  lblWUProduce.Caption := 'Water usage for production:' +
    floatToStrf(dsResult['WaterUsageProduction'], fffixed, 8, 2);

  lblRating.Caption := 'Rating: ' + inttostr(dsResult['Rating']);

  lblCategory.Caption := 'Category: ' + dsResult['Category'];

  lblMaxWithdraw.Caption := 'Maximum Stock you can withdraw at once: ' + intTostr(dsResult['MaxWithdrawableStock']);

  if dsResult['Description'] <> NULl then
    redDesc.Lines.Add(dsResult['Description']);

  btnSendRating.Enabled := dsResult['SellerID'] <> DataModule1.userID;
  btnAddToCart.Enabled := dsResult['SellerID'] <> DataModule1.userID;

  spnQuantity.Value := 1;

end;

end.
