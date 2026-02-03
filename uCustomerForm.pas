unit uCustomerForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDataModule,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Layouts, FMX.TabControl, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Controls.Presentation,
  System.Rtti, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.DialogService.Async, FMX.DialogService,
    {$IF Defined(Android)}
    AndroidAPI.JNI.JavaTypes, AndroidAPI.JNI.Widget, AndroidAPI.Helpers, Posix.UNISTD,
  {$ENDIF}
  uCommonDialogs, uCustomerManagerClass, uHelperTabControl, System.Skia,
  FMX.Skia, FMX.MultiView, uJobForm, FMX.Objects;

type
  TCustomerForm = class(TForm)
    qryCustomerlist: TFDQuery;
    TCCustomers: TTabControl;
    TIcustomerlist: TTabItem;
    TIcustomerdetails: TTabItem;
    gpanCustomer: TGridPanelLayout;
    Label1: TLabel;
    txtCustname: TEdit;
    Label3: TLabel;
    memCustaddress: TMemo;
    Label5: TLabel;
    txtCustpostcode: TEdit;
    Label7: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    txtCusttelephone: TEdit;
    txtCustemail: TEdit;
    txtCustcontact: TEdit;
    LVcustomers: TListView;
    panHeaderCustList: TPanel;
    spdNew: TSpeedButton;
    svgNew: TSkSvg;
    lblHeader: TSkLabel;
    lblCustomerDetails: TSkLabel;
    spdHome: TSpeedButton;
    svgHome: TSkSvg;
    spdbackcustomer: TSpeedButton;
    svgbackcustomer: TSkSvg;
    GridPanelLayout1: TGridPanelLayout;
    btnSave: TButton;
    btnDelete: TButton;
    btnCancel: TButton;
    spdMenu: TSpeedButton;
    svgMenu: TSkSvg;
    MultiView1: TMultiView;
    gpanelSort: TGridPanelLayout;
    lblSort: TLabel;
    radSortAZ: TRadioButton;
    radSortZA: TRadioButton;
    tbarCustomerEdit: TToolBar;
    imgEdit: TImage;
    imgPdf: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LVcustomersItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure LVcustomersPullRefresh(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure spdNewClick(Sender: TObject);
    procedure spdHomeClick(Sender: TObject);
    procedure radSortAZChange(Sender: TObject);
    procedure radSortZAChange(Sender: TObject);
  private
    //
    { Private declarations }
  public
    { Public declarations }
    procedure DisplayCustomerRecord();
    procedure ClearCustomerRecord();
    procedure PopulateCustomerList(ASortAtoZ: boolean = true);
  end;

var
  CustomerForm: TCustomerForm;
  CustId: integer;
  CustName: string;

implementation

{$R *.fmx}

procedure TCustomerForm.FormCreate(Sender: TObject);
begin
  TCCustomers.TabPosition := TTabPosition.None;
  TCCustomers.ActiveTab := TICustomerList;
  Customer := TCustomerManager.Create(DM.FDlocal);
  CustID := -1;
  if not DM.FDLocal.Connected then
    DM.FDlocal.Open();
  PopulateCustomerList();
  TCCustomers.TabRight(TicustomerList);
end;

procedure TCustomerForm.FormDestroy(Sender: TObject);
begin
  // Whatever we create, we free
  if Assigned(Customer) then
    Customer.Free;
end;

procedure TCustomerForm.LVcustomersItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemIndex < 0) OR (ItemObject = NIL) then
    exit;

  // Only continue if the right hand arrow button clicked
  if ItemObject is TListItemImage then
  begin
    if itemobject.Name = 'lvoImgPdf' then
    begin
     // Showing a pdf of the customer details (including past jobs etc)
    end
    else
    begin
      // Showing the customer details for editing
      custid := LVCustomers.Items.Item[itemindex].Tag;
      if not Customer.FetchCustomerByID(custid) then
      begin
        ShowWarning('Unable to find the selected record!');
        exit;
      end;
        // Now will move to the customer record tab
        DisplayCustomerRecord;
        lblCustomerDetails.Text := 'Edit customer details';
        TCCustomers.TabRight(TIcustomerDetails);
    end;
  end;
end;

procedure TCustomerForm.LVcustomersPullRefresh(Sender: TObject);
begin
  PopulateCustomerList;
end;

procedure TCustomerForm.PopulateCustomerList(ASortAtoZ: boolean = true);
var
  LItem: TListViewItem;
begin
  if ASortAtoZ then
    qryCustomerList.SQL.Text := 'SELECT * FROM customers ORDER BY custname ASC;'
  else
    qryCustomerList.SQL.Text := 'SELECT * FROM customers ORDER BY custname DESC;';
  qryCustomerList.Open();
  // Read all the customers and display them
  LVCustomers.BeginUpdate;
  try
    LVCustomers.Items.Clear;
    while not qryCustomerList.eof do
    begin
      // Add cust details to the list view
      LItem := LVCustomers.Items.Add;
      LItem.Tag := qryCustomerList.FieldByName('custid').AsInteger;
      LITem.Data['lvoCustname'] := qryCustomerList.FieldByName('custname').AsString;
      LITem.Data['lvoContact'] := qryCustomerList.FieldByName('custcontact').AsString;
      LITem.Data['lvoPhone'] := qryCustomerList.FieldByName('custtelephone').AsString;
      LItem.Text := qryCustomerList.FieldByName('custname').AsString;
      LITem.Data['lvoImgEdit'] := imgEdit.Bitmap;
      LITem.Data['lvoImgPdf'] := imgPdf.Bitmap;
      qryCustomerList.Next;
    end;
  finally
    LVcustomers.EndUpdate;
    qryCustomerList.Close;
  end;
end;

procedure TCustomerForm.radSortAZChange(Sender: TObject);
begin
  // Customer Sort (A-Z)
  PopulateCustomerList;
end;

procedure TCustomerForm.radSortZAChange(Sender: TObject);
begin
  PopulateCustomerList(false);
end;

procedure TCustomerForm.spdHomeClick(Sender: TObject);
begin
    Close;
end;

procedure TCustomerForm.spdNewClick(Sender: TObject);
begin
  // This is giong to launch the blank customer form ready for a new customer
  lblCustomerDetails.Text := 'Add a new customer';
  ClearCustomerRecord;
  TCCustomers.TabRight(TICustomerDetails);
end;

procedure TCustomerForm.btnCancelClick(Sender: TObject);
begin
  // Go back to the list
  CustId := -1;
  Custname := '';
  TCCustomers.TabLeft(TIcustomerList); // Using helper
  ClearCustomerRecord();
end;

procedure TCustomerForm.btnDeleteClick(Sender: TObject);
var
  MSG: string;
begin
  // Confirm they want to delete the current record
  if CustID = -1 then
    exit;
  MSG := Format('Are you sure you want to delete %s?', [custname]);
  TDialogService.MessageDialog(MSG, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure (const AResult: TModalResult) begin
      if AResult = mrYes then
      begin
        try
          if Customer.DeleteCustomer(custid) then
          begin
          // This will show a message toast in android to say the record has been deleted
            ShowToast(Format('%s Record Deleted', [custname]));
            PopulateCustomerList();
            TCCustomers.TabLeft(TIcustomerList);
            ClearCustomerRecord();
          end;
        except
          on E: exception do
          begin
            ShowWarning('Unexpected Error when deleting customer record'+ sLineBreak+ E.Message);
          end;
        end;
      end;
    end);
end;

procedure TCustomerForm.btnSaveClick(Sender: TObject);
begin
  // Save the updated customer record (or an insert of a new one)
  if CustID > 0 then
  begin
    // Updating existing record
    if txtCustName.text.IsEmpty then
    begin
      ShowWarning('You must enter the customer name!', txtCustName);
      exit;
    end;
    // Set the customer class with existing details
    Customer.CustID := CustID;
    Customer.CustName := txtCustName.Text;
    Customer.CustAddress := memCustaddress.Text;
    Customer.CustPostcode := txtCustpostcode.Text;
    Customer.CustTelephone := txtCusttelephone.Text;
    Customer.CustEmail := txtCustEmail.Text;
    Customer.CustContact := txtCustcontact.Text;
    if Customer.UpdateCustomer then
    begin
      ShowToast(Format('%s Record Saved', [custname]));
      PopulateCustomerList();
      TCCustomers.TabLeft(TIcustomerList);
      ClearCustomerRecord();
    end;
  end
  else
  begin
    // Inserting a new record
    Customer.CustName := txtCustName.Text;
    Customer.CustAddress := memCustaddress.Text;
    Customer.CustPostcode := txtCustpostcode.Text;
    Customer.CustTelephone := txtCusttelephone.Text;
    Customer.CustEmail := txtCustEmail.Text;
    Customer.CustContact := txtCustcontact.Text;
    if Customer.InsertCustomer then
    begin
      ShowToast(Format('%s Record Inserted', [custname]));
      PopulateCustomerList();
      TCCustomers.TabLeft(TIcustomerList);
      ClearCustomerRecord();
    end;
  end;
end;

procedure TCustomerForm.ClearCustomerRecord();
begin
  // Clear the record details
  txtCustname.Text := '';
  memCustaddress.Text := '';
  txtCustpostcode.Text := '';
  txtCusttelephone.Text := '';
  txtCustemail.Text := '';
  txtCustcontact.Text := '';
end;

procedure TCustomerForm.DisplayCustomerRecord();
begin
  // Display the record details
  ClearCustomerRecord();
  txtCustname.Text := Customer.CustName;
  memCustaddress.Text := Customer.CustAddress;
  txtCustpostcode.Text := Customer.CustPostcode;
  txtCusttelephone.Text := Customer.CustTelephone;
  txtCustemail.Text := Customer.CustEmail;
  txtCustcontact.Text := Customer.CustContact;
end;

end.
