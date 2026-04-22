// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 14.04.2026
// -----------------------------------------------------------------------------

program WorksheetsZR;

uses
  System.StartUpCopy,
  FMX.Forms,
  uDataModule in 'uDataModule.pas' {DM: TDataModule},
  uMainForm in 'uMainForm.pas' {MainForm},
  uCustomerForm in 'uCustomerForm.pas' {CustomerForm},
  uCustomerManagerClass in 'uCustomerManagerClass.pas',
  uCommonDialogs in 'uCommonDialogs.pas',
  uJobForm in 'uJobForm.pas' {JobForm},
  uWorksheetPDF in 'uWorksheetPDF.pas',
  uCommonUTF8Helper in 'uCommonUTF8Helper.pas',
  uCommon in 'uCommon.pas',
  uJobsManagerClass in 'uJobsManagerClass.pas',
  uHelperTabControl in 'uHelperTabControl.pas',
  uSchema in 'uSchema.pas',
  uReportAndExportHelper in 'uReportAndExportHelper.pas',
  uWorksheetHTML in 'uWorksheetHTML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait];
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
