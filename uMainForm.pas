unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Skia, FMX.Skia, FMX.StdCtrls, FMX.Controls.Presentation, uCommonDialogs,
      {$IF Defined(Android)}
    AndroidAPI.JNI.JavaTypes, AndroidAPI.JNI.Widget, AndroidAPI.Helpers, Posix.UNISTD,
  {$ENDIF}
  uCustomerForm, uDataModule, uHelperTabControl, uJobForm;

type
  TMainForm = class(TForm)
    TCMain: TTabControl;
    TILogin: TTabItem;
    TIOptions: TTabItem;
    TIAdmin: TTabItem;
    panHeaderCustList: TPanel;
    spdHome: TSpeedButton;
    svgHome: TSkSvg;
    btnCustomers: TButton;
    Button1: TButton;
    btnManageJobs: TButton;
    SkLabel1: TSkLabel;
    lblHeader: TSkLabel;
    lblAdminOptions: TLabel;
    procedure btnCustomersClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnManageJobsClick(Sender: TObject);
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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if FileExists(DBName) then
  begin
    DM.FDlocal.Close;
    DeleteFile(DBName);
  end;
  DM.CreateDB;
end;

end.
