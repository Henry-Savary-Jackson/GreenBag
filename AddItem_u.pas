unit AddItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, DMUnit_u, Data.Win.ADODB, PngImage ;

type
  TfrmAddItem = class(TForm)
    imgProduct: TImage;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgProductClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveChangesClick(Sender: TObject);
    function getFloatFromStr(s, valName: string): double;
  private
    { Private declarations }
  public
    { Public declarations }
    userID: string;
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
  frmYourProducts.Show;
end;

procedure TfrmAddItem.btnSaveChangesClick(Sender: TObject);
var
  sName, sDesc, category: string;
  CF, WU, EU, CFProduce, WUProduce, EUProduce, Price: double;
  pngImage: tPngImage;
  I: Integer;
begin

  if imgProduct.Picture = nil then
  begin
    showMessage('Please upload an image of your item.');
    Exit;
  end;
  pngImage := TPngImage.Create();
  pngImage.Assign(imgProduct.Picture.Graphic);



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


  CF := getFloatFromStr(edtCF.Text, 'Carbon Footprint');
  if CF = INFINITE then
    Exit;

  EU := getFloatFromStr(edtEU.Text, 'Energy Usage');
  if EU = INFINITE then
    Exit;

  WU := getFloatFromStr(edtWU.Text, 'Water Usage');
  if WU = INFINITE then
    Exit;

  CFProduce := getFloatFromStr(edtCFProduce.Text, 'Carbon footprint to produce');
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

  if itemID = '' then
  begin
    itemID := UpperCase(userID[1] + sName[1]);

    for I := 1 to 8 do
    begin
      itemID := itemID + intToStr(random(10))
    end;

    DataModule1.insertItem(itemID, sName, userID, category, sDesc, Price, CF,
      EU, WU, CFProduce, EUProduce, WUProduce, pngImage);

  end
  else
  begin
    DataModule1.updateItem(itemID, sName, userID, category, sDesc, Price, CF,
      EU, WU, CFProduce, EUProduce, WUProduce, pngImage);

  end;

  showMessage('Successfully saved changes');
  //free var from heap
  pngImage.Free;

  frmAddItem.Hide;
  frmYourProducts.Show;
end;

procedure TfrmAddItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
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
    showMessage(floattoStr(result));
  Except
    on e: EConvertError do
    begin;
      showMessage(Format('Please format your input correclty on the %s field.',
        [valName]));
      Result := INFINITE;
    end;

  end;
end;

procedure TfrmAddItem.imgProductClick(Sender: TObject);
var
  fileChooser: tOpenDialog;
  sImagePath: string;
begin
  // open filchooser
  fileChooser := tOpenDialog.Create(self);
  try
    fileChooser.Filter := 'jpg Files|*.jpg|png files|*png';
    fileChooser.InitialDir := 'C:\';

    if fileChooser.Execute(Handle) then
    begin
      sImagePath := fileChooser.FileName;
      imgProduct.Picture.LoadFromFile(sImagePath);
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
