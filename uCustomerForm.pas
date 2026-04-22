// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Changed 16.04.2026 Ensured all exceptions raised used the same begin/end and ShowException call
// Changed 16.04.2026 If Assigned not required, object.free does it automatically

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
  System.Skia, FMX.Skia, FMX.MultiView, FMX.Objects,
  uCommonDialogs, uCustomerManagerClass, uHelperTabControl, uJobForm, uJobsManagerClass;

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
    spdHome: TSpeedButton;
    svgHome: TSkSvg;
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
    imgEdit: TImage;
    imgPdf: TImage;
    TCCustedit: TTabControl;
    tiEdit: TTabItem;
    tiPreviousJobs: TTabItem;
    tbarCustomerEdit: TToolBar;
    lblCustomerDetails: TSkLabel;
    spdbackcustomer: TSpeedButton;
    svgbackcustomer: TSkSvg;
    LVZJobs: TListView;
    qryListJobs: TFDQuery;
    rectProgress: TRectangle;
    aniProgress: TAniIndicator;
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
    procedure LVZJobsPullRefresh(Sender: TObject);
    procedure LVZJobsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    procedure PopulateJobHistory;
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
  JobNo: integer;

implementation

{$R *.fmx}

uses uReportAndExportHelper;

procedure TCustomerForm.FormDestroy(Sender: TObject);
begin
  // Changed 16.04.2026 If Assigned not required, object.free does it automatically
  Customer.Free;
  Job.Free;
end;

procedure TCustomerForm.FormCreate(Sender: TObject);
begin
  Job := TJobManager.Create(DM.FDlocal);
  TCCustomers.TabPosition := TTabPosition.None;
  TCCustomers.ActiveTab := TICustomerList;
  Customer := TCustomerManager.Create(DM.FDlocal);
  CustID := -1;
  if not DM.FDLocal.Connected then
    DM.FDlocal.Open();
  PopulateCustomerList();
  TCCustomers.TabRight(TicustomerList);
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
     // TODO: Showing a pdf of the customer details (including past jobs etc)
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
        PopulateJobHistory();
        lblCustomerDetails.Text := 'Edit ' + Customer.CustName;
        TCCustedit.TabPosition := TTabPosition.Top;
        TCCustedit.ActiveTab := tiEdit;
        TCCustomers.TabRight(TIcustomerDetails);
    end;
  end;
end;

procedure TCustomerForm.LVcustomersPullRefresh(Sender: TObject);
begin
  PopulateCustomerList;
end;

procedure TCustomerForm.LVZJobsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemIndex < 0) OR (ItemObject = NIL) then
    exit;

  if ItemObject is TListItemImage then
  begin
    JobNo := LVZJobs.Items.Item[itemindex].Tag;
    if itemobject.Name = 'lvoImgPdf' then
    begin
      if not Job.FetchJob(JobNo) then
      begin
        ShowWarning('Unable to find the selected job record!');
        exit;
      end;
      ShowWorksheetPDFThread(JobNo, aniProgress, rectProgress);
    end;
  end;
end;

procedure TCustomerForm.LVZJobsPullRefresh(Sender: TObject);
begin
  PopulateJobHistory();
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
//      LITem.Data['lvoImgPdf'] := imgPdf.Bitmap;
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
  TCCustedit.TabPosition := TTabPosition.None;
  TCCustedit.ActiveTab := tiEdit;
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
begin
  // Confirm they want to delete the current record
  if CustID = -1 then
    exit;
  var MSG := Format('Are you sure you want to delete %s?', [custname]);
  TDialogService.MessageDialog(MSG, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure (const AResult: TModalResult) begin
      if AResult = mrYes then
      begin
        try
          if Customer.DeleteCustomer(custid) then
          begin
            ShowToast(Format('%s Record Deleted', [custname]));
            PopulateCustomerList();
            TCCustomers.TabLeft(TIcustomerList);
            ClearCustomerRecord();
          end;
        except
          on E: exception do
          begin
            ShowException('DeleteCustomer', E);
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
  // clear jobhistory
  LVZJobs.BeginUpdate;
  try
    LVZJobs.Items.Clear;
  finally
    LVZJobs.EndUpdate;
  end;
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

procedure TCustomerForm.PopulateJobHistory();
begin
  qryListjobs.Close;
  qryListjobs.SQL.Text :=
    'SELECT jobno, custname, jobtype, jobdate, reason ' +
    'FROM jobs_master ' +
    'WHERE custname = :custname ' +
    'ORDER BY jobdate DESC';
  qryListjobs.ParamByName('custname').AsString := Customer.CustName;
  qryListjobs.Open;
  LVZJobs.BeginUpdate;
  try
    LVZJobs.Items.Clear;
    while not qryListjobs.Eof do
    begin
      with LVZJobs.Items.Add do
      begin
        Tag := qryListjobs.FieldByName('jobno').AsInteger;
        Data['lvoJobno'] := Format('%.*d', [5, qryListjobs.FieldByName('jobno').AsInteger]);
        Data['lvoReason'] := qryListjobs.FieldByName('reason').AsString.Substring(0, 50);
        Data['lvoJobtype'] := qryListjobs.FieldByName('jobtype').AsString;
        if qryListjobs.FieldByName('jobdate').IsNull then
          Data['lvoJobdate'] := 'dd/mm/yyyy'
        else
          Data['lvoJobdate'] := DateToStr(qryListjobs.FieldByName('jobdate').AsDateTime);
        Data['lvoImgPdf'] := imgPdf.Bitmap;
      end;
      qryListjobs.Next;
    end;
  finally
    LVZJobs.EndUpdate;
    qryListjobs.Close;
  end;
end;

end.
