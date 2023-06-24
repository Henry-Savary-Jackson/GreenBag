unit AddItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, DMUnit_u, Data.Win.ADODB, PngImage,Vcl.Imaging.jpeg, Data.DB ;

type
  TfrmAddItem = class(TForm)
    imgItem: TImage;
    lblDesc: TLabel;
    lblCategory: TLabel;
    lblCF: TLabel;
    lblEU: TLabel;
    lblWaterUsage: TLabel;
    lblPrice: TLabel;
    lblName: TLabel;
    lblSeller: TLabel;
    btnBack: TButton;
    redDesc: TRichEdit;
    edtName: TEdit;
    edtPrice: TEdit;
    edtCF: TEdit;
    edtEU: TEdit;
    edtWU: TEdit;
    btnSaveChanges: TButton;
    cmbCategory: TComboBox;
    lblRating: TLabel;
    lblCFProduce: TLabel;
    lblEUProduce: TLabel;
    lblWUProduce: TLabel;
    edtCFProduce: TEdit;
    edtEUProduce: TEdit;
    edtWUProduce: TEdit;
    lblStock: TLabel;
    edtStock: TEdit;
    lblMaxWithdrawStock: TLabel;
    edtMaxWithdrawStock: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgItemClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveChangesClick(Sender: TObject);
    function getFloatFromStr(s, valName: string): double;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    itemID: string;
  end;

var
  frmAddItem: TfrmAddItem;

implementation

uses
  Yourproducts_u;

{$R *.dfm}

procedure TfrmAddItem.btnBackClick(Sender: TObject);
begin
  frmAddItem.Hide;
  DataModule1.lastForm.Show;
end;

procedure TfrmAddItem.btnSaveChangesClick(Sender: TObject);
var
  sName, sDesc, category: string;
  CF, WU, EU, CFProduce, WUProduce, EUProduce, Price: double;
  stock, maxWithdrawstock: double;
  I: Integer;
begin

  if imgItem.Picture = nil then
  begin
    showMessage('Please upload an image of your item.');
    Exit;
  end;

  sName := edtName.Text;

  if sName = '' then
  begin
    showMessage('Please enter the item''s name.');
    Exit;
  end;

  if length(sName) > 50 then
  begin
    showMessage('The item''s name cannot be more than 50 characters.');
    Exit;
  end;

  sDesc := redDesc.Text;
  Price := getFloatFromStr(edtPrice.Text, 'Price');
  if Price = INFINITE then
    Exit;

  stock := getFloatFromStr(edtStock.Text, 'Stock');

  maxWithdrawstock := getFloatFromStr(edtMaxWithdrawStock.Text,
    ' Max Withdrawable stock');

  if stock = INFINITE then
    Exit;

  CF := getFloatFromStr(edtCF.Text, 'Carbon Footprint');
  if CF = INFINITE then
    Exit;

  EU := getFloatFromStr(edtEU.Text, 'Energy Usage');
  if EU = INFINITE then
    Exit;

  WU := getFloatFromStr(edtWU.Text, 'Water Usage');
  if WU = INFINITE then
    Exit;

  CFProduce := getFloatFromStr(edtCFProduce.Text,
    'Carbon footprint to produce');
  if CFProduce = INFINITE then
    Exit;

  EUProduce := getFloatFromStr(edtEUProduce.Text, 'Energy Usage to produce');
  if EUProduce = INFINITE then
    Exit;

  WUProduce := getFloatFromStr(edtWUProduce.Text, 'Water Usage to produce');
  if WUProduce = INFINITE then
    Exit;

  if cmbCategory.ItemIndex = -1 then
  begin
    showMessage('Please select the item''s category.');
    Exit;
  end;

  category := cmbCategory.Items[cmbCategory.ItemIndex];

  if imgItem.Picture.Graphic = NIL then
  begin
    showMessage('Please assign a picture to this item.');
    Exit;
  end;

  try

    try

      if itemID = '' then
      begin
        itemID := UpperCase(DataModule1.userID[1] + sName[1]);

        for I := 1 to 8 do
        begin
          itemID := itemID + intToStr(random(10))
        end;

        DataModule1.insertItem(itemID, sName, DataModule1.userID, category,
          sDesc, Price, stock, maxWithdrawstock, CF, EU, WU, CFProduce,
          EUProduce, WUProduce, imgItem);

      end
      else
      begin
        DataModule1.updateItem(itemID, sName, DataModule1.userID, category,
          sDesc, Price, stock, maxWithdrawstock, CF, EU, WU, CFProduce,
          EUProduce, WUProduce, imgItem);

      end;

      showMessage('Successfully saved changes');
      // free var from heap  memory

      // naviguate back to your products
      frmAddItem.Hide;
      DataModule1.lastForm.Show;

    except
      on e: exception do
      begin
        showMessage(e.Message);
      end;

    end;
  finally
  end;

end;

procedure TfrmAddItem.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfrmAddItem.FormShow(Sender: TObject);
var
  dsResult: tAdoDataset;
  dsCategories: tAdoDataset;
  imageStream : tStream;
begin

  cmbCategory.Items.Clear;

  dsCategories := DataModule1.getCategories;

  dsCategories.First;

  while not dsCategories.Eof do
  begin
    cmbCategory.Items.Add(dsCategories['Category']);
    dsCategories.Next;
  end;

  dsCategories.Free;

  if itemID <> '' then
  begin
    dsResult := DataModule1.viewItem(self.itemID);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    edtName.Text := dsResult['ItemName'];

    lblSeller.Caption := 'Seller: ' + dsResult['SellerName'];
    lblRating.Caption := 'Rating: ' + intToStr(dsResult['Rating']);

    edtPrice.Text := floatTOStrf(dsResult['Cost'], ffFixed, 8, 2);

    edtStock.Text := intToStr(dsResult['Stock']);

    edtCF.Text := floatTOStrf(dsResult['CarbonFootprintUsage'], ffFixed, 8, 2);
    edtEU.Text := floatTOStrf(dsResult['EnergyFootprintUsage'], ffFixed, 8, 2);
    edtWU.Text := floatTOStrf(dsResult['WaterFootprintUsage'], ffFixed, 8, 2);

    edtCFProduce.Text := floatTOStrf(dsResult['CarbonFootprintUsage'],
      ffFixed, 8, 2);
    edtEUProduce.Text := floatTOStrf(dsResult['EnergyFootprintUsage'],
      ffFixed, 8, 2);
    edtWUProduce.Text := floatTOStrf(dsResult['WaterFootprintUsage'],
      ffFixed, 8, 2);

    if dsResult['Description'] <> NUll then
      redDesc.lines.Add(dsResult['Description']);

    cmbCategory.ItemIndex := cmbCategory.Items.IndexOf(dsResult['Category']);

    edtMaxWithdrawStock.Text := inttostr(dsResult['MaxWithdrawableStock']);

    imageStream :=   dsResult.CreateBlobStream( dsResult.FieldByName('Image'), bmRead);
    try
      imgItem.Picture.LoadFromStream(imageStream);

    finally
      imageStream.Free;
    end;

    dsResult.Free;
  end;

end;

function TfrmAddItem.getFloatFromStr(s, valName: string): double;
begin
  try
    if s = '' then
    begin
      Result := 0.0;
      Exit;
    end;
    Result := StrToFloat(s);
  Except
    on e: EConvertError do
    begin;
      showMessage(Format('Please format your input correclty on the %s field.',
        [valName]));
      Result := INFINITE;
    end;

  end;
end;

procedure TfrmAddItem.imgItemClick(Sender: TObject);
var
  fileChooser: tOpenDialog;
  sImagePath: string;
begin
  // open filchooser
  fileChooser := tOpenDialog.Create(self);
  try
    fileChooser.Filter := 'jpg Files|*.jpg|png files|*.png';
    fileChooser.InitialDir := 'C:\';

    if fileChooser.Execute(Handle) then
    begin
      sImagePath := fileChooser.FileName;
      imgItem.Picture.LoadFromFile(sImagePath);
    end
    else
    begin
      showMessage('Please choose a file');
    end;
  finally
    fileChooser.Free;
  end;

end;

end.
