// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Skia, FMX.Skia, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.DialogService.Async, FMX.DialogService, uCommonDialogs,
  {$IF Defined(Android)}
    AndroidAPI.JNI.JavaTypes, AndroidAPI.JNI.Widget, AndroidAPI.Helpers, Posix.UNISTD,
  {$ENDIF}
  uCustomerForm, uDataModule, uHelperTabControl, uJobForm, FMX.Edit, FMX.Layouts,
  MobilePermissions.Model.Signature,
  MobilePermissions.Model.Dangerous, MobilePermissions.Model.Standard,
  MobilePermissions.Component, FMX.Objects;

type
  TMainForm = class(TForm)
    TCMain: TTabControl;
    tiOptions: TTabItem;
    tiReportadmin: TTabItem;
    tbarCustomerEdit: TToolBar;
    lblDatabaseadmin: TSkLabel;
    spdbackcustomer: TSpeedButton;
    svgbackcustomer: TSkSvg;
    gpanCustomer: TGridPanelLayout;
    lblCompany: TLabel;
    txtHeadername: TEdit;
    lblTagline1: TLabel;
    lblTagline2: TLabel;
    txtHeadertelephone: TEdit;
    txtHeaderemail: TEdit;
    lblReportheader: TLabel;
    MobilePermissions1: TMobilePermissions;
    ToolBar1: TToolBar;
    lblHeader: TSkLabel;
    tiDatabase: TTabItem;
    ToolBar2: TToolBar;
    SkLabel1: TSkLabel;
    SpeedButton1: TSpeedButton;
    SkSvg2: TSkSvg;
    GridPanelLayout1: TGridPanelLayout;
    btnCreate: TButton;
    btnCreatedemo: TButton;
    GridPanelLayout2: TGridPanelLayout;
    btnManageJobs: TButton;
    btnCustomers: TButton;
    btnDBAdmin: TButton;
    btnReportAdmin: TButton;
    SkSvg3: TSkSvg;
    SkSvg4: TSkSvg;
    SkSvg5: TSkSvg;
    Layout1: TLayout;
    btnSave: TButton;
    GridPanelLayout3: TGridPanelLayout;
    Layout2: TLayout;
    Image1: TImage;
    Layout3: TLayout;
    Image2: TImage;
    Layout4: TLayout;
    Image3: TImage;
    radDefault: TRadioButton;
    radDark: TRadioButton;
    radMinimal: TRadioButton;
    Label1: TLabel;
    procedure btnCustomersClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnManageJobsClick(Sender: TObject);
    procedure spdbackcustomerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCreatedemoClick(Sender: TObject);
    procedure btnDBAdminClick(Sender: TObject);
    procedure btnReportAdminClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure radDefaultClick(Sender: TObject);
    procedure radDarkClick(Sender: TObject);
    procedure radMinimalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // TCMain change buttons and set tiOptions as visible
  TCMain.TabPosition := ttabposition.None;
  TCMain.ActiveTab := tiOptions;
  MobilePermissions1.Dangerous.Camera := true;
  MobilePermissions1.Dangerous.WriteExternalStorage := true;
  MobilePermissions1.Dangerous.ReadExternalStorage := true;
  MobilePermissions1.Apply;
end;

procedure TMainForm.Image1Click(Sender: TObject);
begin
  radDefault.IsChecked := true;
  ReportManager.Theme := wtOriginal;
end;

procedure TMainForm.Image2Click(Sender: TObject);
begin
  radDark.IsChecked := true;
  ReportManager.Theme := wtDark;
end;

procedure TMainForm.Image3Click(Sender: TObject);
begin
  radMinimal.IsChecked := true;
  ReportManager.Theme := wtMinimal;
end;

procedure TMainForm.radDarkClick(Sender: TObject);
begin
  ReportManager.Theme := wtDark;
end;

procedure TMainForm.radDefaultClick(Sender: TObject);
begin
  ReportManager.Theme := wtOriginal;
end;

procedure TMainForm.radMinimalClick(Sender: TObject);
begin
  ReportManager.Theme := wtMinimal;
end;

procedure TMainForm.btnCustomersClick(Sender: TObject);
begin
  var frm := TCustomerForm.Create(nil);
  frm.ShowModal (
    procedure(ModalResult: TModalResult)
      begin
      end
  );
end;

procedure TMainForm.btnDBAdminClick(Sender: TObject);
begin
  TCMain.TabRight(tiDatabase);
end;

procedure TMainForm.btnManageJobsClick(Sender: TObject);
begin
  var frm := TJobForm.Create(nil);
  frm.ShowModal (
    procedure(ModalResult: TModalResult)
      begin
      end
    );
end;

procedure TMainForm.btnReportAdminClick(Sender: TObject);
begin
  txtHeaderName.Text:= ReportManager.Name;
  txtHeaderTelephone.Text := ReportManager.Phone;
  txtHeaderEmail.Text := ReportManager.Email;
  case ReportManager.Theme of
    wtDark: radDark.IsChecked := true;
    wtMinimal: radMinimal.IsChecked := true;
  else
    radDefault.IsChecked := true;
  end;
  TCMain.TabRight(tiReportadmin);
end;

procedure TMainForm.btnCreateClick(Sender: TObject);
begin
  DM.AskCreateDB(false); // create schema only
end;

procedure TMainForm.btnCreatedemoClick(Sender: TObject);
begin
  DM.AskCreateDB(true); // create with demo data
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
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
  ReportManager.Name := txtHeaderName.Text;
  ReportManager.Phone := txtHeaderTelephone.Text;
  ReportManager.Email := txtHeaderEmail.Text;
  ReportManager.Save;
end;

procedure TMainForm.spdbackcustomerClick(Sender: TObject);
begin
  TCMain.TabLeft(tiOptions);
end;

end.
