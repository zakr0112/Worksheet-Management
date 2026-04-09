program WorkSheets;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  uDataModule in 'uDataModule.pas' {DM: TDataModule},
  uCustomerForm in 'uCustomerForm.pas' {CustomerForm},
  uCustomerManagerClass in 'uCustomerManagerClass.pas',
  uCommonDialogs in 'uCommonDialogs.pas',
  uHelperTabControl in 'uHelperTabControl.pas',
  uJobForm in 'uJobForm.pas' {JobForm},
  uMainForm in 'uMainForm.pas' {MainForm},
  uJobsManagerClass in 'uJobsManagerClass.pas',
  uCommon in 'uCommon.pas',
  uWorksheetPDF in 'uWorksheetPDF.pas',
  uCommonUTF8Helper in 'uCommonUTF8Helper.pas',
  uCommonPDFLauncher in 'uCommonPDFLauncher.pas',
  uSvgSignatureHelper in 'uSvgSignatureHelper.pas',
  uHeaderDetailsClass in 'uHeaderDetailsClass.pas',
  uCustomerPDF in 'uCustomerPDF.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
