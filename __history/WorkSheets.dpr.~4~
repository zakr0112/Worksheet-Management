program WorkSheets;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  uMainForm in 'uMainForm.pas' {MainForm},
  uDataModule in 'uDataModule.pas' {DM: TDataModule},
  uCustomerClass in 'uCustomerClass.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
