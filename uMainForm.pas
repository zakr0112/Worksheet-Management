unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Skia, FMX.Skia, FMX.StdCtrls, FMX.Controls.Presentation, uCommonDialogs,
      {$IF Defined(Android)}
    AndroidAPI.JNI.JavaTypes, AndroidAPI.JNI.Widget, AndroidAPI.Helpers, Posix.UNISTD,
  {$ENDIF}
  uCustomerForm, uDataModule, uHelperTabControl, uJobForm, FMX.Edit, FMX.Layouts,
  uHeaderDetailsClass;

type
  TMainForm = class(TForm)
    TCMain: TTabControl;
    TIOptions: TTabItem;
    panHeaderCustList: TPanel;
    spdHome: TSpeedButton;
    svgHome: TSkSvg;
    btnCustomers: TButton;
    btnManageJobs: TButton;
    lblHeader: TSkLabel;
    tiAdmin: TTabItem;
    tbarCustomerEdit: TToolBar;
    lblCustomerDetails: TSkLabel;
    spdbackcustomer: TSpeedButton;
    svgbackcustomer: TSkSvg;
    gpanCustomer: TGridPanelLayout;
    Label1: TLabel;
    txtHeadername: TEdit;
    Label7: TLabel;
    Label10: TLabel;
    txtHeadertelephone: TEdit;
    txtHeaderemail: TEdit;
    Label2: TLabel;
    btnSave: TButton;
    Label9: TLabel;
    btnRecreatedb: TButton;
    spdAdmin: TSpeedButton;
    SkSvg1: TSkSvg;
    procedure btnCustomersClick(Sender: TObject);
    procedure btnRecreatedbClick(Sender: TObject);
    procedure btnManageJobsClick(Sender: TObject);
    procedure spdAdminClick(Sender: TObject);
    procedure spdbackcustomerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.btnCustomersClick(Sender: TObject);
var
   frm: TCustomerForm;
begin
   frm := TCustomerForm.Create(nil);
   frm.ShowModal (
      procedure(ModalResult: TModalResult)
      begin
         // Put something here to do AFTER form has closed and come back e.g.
         // RefreshFirstPage;
      end
   );

end;

procedure TMainForm.btnManageJobsClick(Sender: TObject);
var
   frm: TJobForm;
begin
   frm := TJobForm.Create(nil);
   frm.ShowModal (
      procedure(ModalResult: TModalResult)
      begin
         // Put something here to do AFTER form has closed and come back e.g.
         // RefreshFirstPage;
      end
   );

end;

procedure TMainForm.btnRecreatedbClick(Sender: TObject);
begin
  if FileExists(DBName) then
  begin
    DM.FDlocal.Close;
    DeleteFile(DBName);
  end;
  DM.CreateDB;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
var
  Mgr: THeaderDetailsManager;
  D: THeaderDetails;
begin

  if txtHeaderName.text.IsEmpty then
  begin
    ShowWarning('You must enter the company Header name!', txtHeaderName);
    exit;
  end;
  if txtHeaderTelephone.text.IsEmpty then
  begin
    ShowWarning('You must enter the company Telephone number!', txtHeaderTelephone);
    exit;
  end;
  if txtHeaderEmail.text.IsEmpty then
  begin
    ShowWarning('You must enter the company email address!', txtHeaderEmail);
    exit;
  end;
  D.HeaderName := txtHeaderName.Text;
  D.HeaderTelephone := txtHeaderTelephone.Text;
  D.HeaderEmail := txtHeaderEmail.Text;

  Mgr := THeaderDetailsManager.Create(DM.FDlocal);
  try
    Mgr.Save(D);
    ShowMessage('Header details saved.');
  finally
    Mgr.Free;
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // TCMain change buttons and set tiOptions as visible
  TCMain.TabPosition := ttabposition.None;
  TCMain.ActiveTab := tiOptions;
end;

procedure TMainForm.spdAdminClick(Sender: TObject);
var
  Mgr: THeaderDetailsManager;
  D: THeaderDetails;
begin
  // Load the report heading details
    Mgr := THeaderDetailsManager.Create(DM.FDlocal);
  try
    Mgr.EnsureDefaultRow;
    if Mgr.Load(D) then
    begin
      txtHeaderName.Text := D.HeaderName;
      txtHeaderTelephone.Text := D.HeaderTelephone;
      txtHeaderEmail.Text := D.HeaderEmail;
    end;
  finally
    Mgr.Free;
  end;

  TCMain.TabRight(tiAdmin);
end;

procedure TMainForm.spdbackcustomerClick(Sender: TObject);
begin
  TCMain.TabLeft(tiOptions);
end;

end.
