unit AddItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, DMUnit_u, Data.Win.ADODB, PngImage, Vcl.Imaging.jpeg, Data.DB,
  Vcl.Buttons;

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
    redDesc: TRichEdit;
    edtName: TEdit;
    edtPrice: TEdit;
    edtCF: TEdit;
    edtEU: TEdit;
    edtWU: TEdit;
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
    pnlHelp: TPanel;
    spnHelp: TSpeedButton;
    pnlBack: TPanel;
    SpeedButton1: TSpeedButton;
    pnlSaveChanges: TPanel;
    btnSaveChanges: TSpeedButton;
    lblCFUnit: TLabel;
    lnlCFproduceUnit: TLabel;
    lblEuUnit: TLabel;
    lblEUProduceUnit: TLabel;
    lblWuUnit: TLabel;
    lblWuProduceUnit: TLabel;
    lblmaxwithdrawstockunits: TLabel;
    lblStockUnits: TLabel;
    pnlItemInfo: TPanel;
    pnlProfileImage: TPanel;
    pnlName: TPanel;
    pnlCategory: TPanel;
    pnlPrice: TPanel;
    pnlWUProduce: TPanel;
    pnlWU: TPanel;
    pnlEUProduce: TPanel;
    pnlEU: TPanel;
    pnlCF: TPanel;
    pnlCFProduce: TPanel;
    pnlMaxWithdraw: TPanel;
    pnlStock: TPanel;
    pnlDesc: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgItemClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveChangesClick(Sender: TObject);
    function getFloatFromStr(s, valName: string): double;
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
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
  Yourproducts_u, HelpScreen_u;

{$R *.dfm}

procedure TfrmAddItem.btnBackClick(Sender: TObject);
begin
  frmAddItem.Hide;
  DataModule1.lastForm.Show;
end;

procedure TfrmAddItem.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmAddItem.btnSaveChangesClick(Sender: TObject);
var
  sName, sDesc, category: string;
  CF, WU, EU, CFProduce, WUProduce, EUProduce, Price: double;
  stock, maxWithdrawstock: double;
  I: Integer;
begin

  // gather input and do input validation
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
  if stock = INFINITE then
    Exit;

  maxWithdrawstock := getFloatFromStr(edtMaxWithdrawStock.Text,
    ' Max Withdrawable stock');
  if maxWithdrawstock = INFINITE then
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


  try

    try

      if itemID = '' then
      begin

        DataModule1.insertItem( sName, category,
          sDesc, Price, stock, maxWithdrawstock, CF, EU, WU, CFProduce,
          EUProduce, WUProduce,DataModule1.jwtToken ,imgItem);

      end
      else
      begin
        // if this is updating an existing item
        DataModule1.updateItem(itemid, sName, category,
          sDesc, Price, stock, maxWithdrawstock, CF, EU, WU, CFProduce,
          EUProduce, WUProduce,DataModule1.jwtToken,imgItem);

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

  Application.Terminate;

end;

procedure TfrmAddItem.FormShow(Sender: TObject);
var
  dsResult: tAdoDataset;
  imageStream: tStream;
  i : integer;
begin

  imgItem.Picture.Graphic := nil;
  cmbCategory.Items.Clear;

  for i := 0 to length(DataModule1.categoryList)-1 do
  begin
    cmbCategory.Items.Add(DataModule1.categoryList[i]);
  end;


  if itemID <> '' then
  begin
    dsResult := DataModule1.viewItem(self.itemID);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    edtName.Text := dsResult['ItemName'];

    if dsResult['avgRating'] = -1 then
    begin
      lblRating.Caption := 'Average Rating: No ratings';
    end
    else
    begin
      lblRating.Caption := 'Average Rating: ' +
        intToStr(dsResult['avgRating']) + '/5';
    end;

    edtPrice.Text := floatTOStrf(dsResult['Cost'], ffFixed, 8, 2);

    edtStock.Text := intToStr(dsResult['Stock']);
    if dsResult['Stock'] = 1 then
      lblStockUnits.Caption := 'unit';

    edtCF.Text := floatTOStrf(dsResult['CFUsage'], ffFixed, 8, 2);
    edtEU.Text := floatTOStrf(dsResult['EUUsage'], ffFixed, 8, 2);
    edtWU.Text := floatTOStrf(dsResult['WUUsage'], ffFixed, 8, 2);

    edtCFProduce.Text := floatTOStrf(dsResult['CFProduce'],
      ffFixed, 8, 2);
    edtEUProduce.Text := floatTOStrf(dsResult['EUProduce'],
      ffFixed, 8, 2);
    edtWUProduce.Text := floatTOStrf(dsResult['WUProduce'],
      ffFixed, 8, 2);

//    if dsResult['Description'] <> NUll then
//      redDesc.lines.Add(dsResult['Description']);

    cmbCategory.ItemIndex := cmbCategory.Items.IndexOf(dsResult['Category']);

    edtMaxWithdrawStock.Text := intToStr(dsResult['MaxWithdrawableStock']);

    if dsResult['MaxWithdrawableStock'] = 1 then
    begin
      lblmaxwithdrawstockunits.Caption := 'unit';

    end;

    DataModule1.loadItemImage(itemid, imgItem);

    dsResult.Free;
  end
  else
  begin
    edtName.Text := '';

    edtPrice.Text := '0';

    edtCF.Text := '0';

    edtEU.Text := '0';

    edtWU.Text := '0';

    edtCFProduce.Text := '0';

    edtWUProduce.Text := '0';

    edtEUProduce.Text := '0';

    edtStock.Text := '0';

    edtMaxWithdrawStock.Text := '0';

    cmbCategory.ItemIndex := -1;

    redDesc.lines.Clear;

  end;

end;

// s is the string that needs to be converted, valname is the name of the field from which this value is from. the latter variable is for more user friendly error checking.
// return INFINITE if there is an error
function TfrmAddItem.getFloatFromStr(s, valName: string): double;
begin
  try
    if s = '' then
    begin
      Result := 0.0;
      Exit;
    end;

    Result := StrToFloat(s);

    if Result < 0 then
    begin
      showMessage(Format('No negative values allowed in the %s field.',
        [valName]));
      Result := INFINITE;
    end;
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
  png: tPngimage;
begin
  // open filchooser
  fileChooser := tOpenDialog.Create(self);
  try
    fileChooser.Filter := 'png files|*.png|jpg Files|*.jpg';
    fileChooser.InitialDir := 'C:\';

    if fileChooser.Execute(Handle) then
    begin
      sImagePath := fileChooser.FileName;
      imgItem.Picture.LoadFromFile(sImagePath);

      // reduce the size of the image that is shown to save storage

      imgItem.Picture.Graphic.Assign(DataModule1.ResizeImage(imgItem,
        128, 128));
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
