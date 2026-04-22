// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Changed 16.04.2026 Ensured all exceptions raised used the same begin/end and ShowException call

unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.UITypes, System.TypInfo,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.FMXUI.Error, FireDAC.Comp.UI,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FMX.Types, FMX.Controls, FMX.DialogService.Async, FMX.DialogService,
  {$IFDEF ANDROID}
    Posix.Unistd,
  {$ENDIF}
  uReportAndExportHelper, uCommonDialogs, uSchema;

type
  TWorksheetTheme = (
    wtOriginal,
    wtClean,
    wtDark,
    wtMinimal,
    wtMobile
  );

type
  TReportConfig = class
  private
    FQry: TFDQuery;
    FName: String;
    FEmail: String;
    FPhone: String;
    FHasData: boolean;
    FTheme: TWorksheetTheme;
    procedure LoadReportConfig;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Save;
    function GetHeader(): string;
    function GetHeaderHTML(): string;
    property Name: String read FName write FName;
    property Phone: String read FPhone write FPhone;
    property Email: String read FEmail write FEmail;
    property Theme: TWorksheetTheme read FTheme write FTheme;
  end;

type
  TDM = class(TDataModule)
    FDlocal: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDGUIxErrorDialog1: TFDGUIxErrorDialog;
    FDQuery1: TFDQuery;
    StyleBook1: TStyleBook;
    StyleBook2: TStyleBook;
    qryExpenses: TFDQuery;
    qrySpares: TFDQuery;
    qryTime: TFDQuery;
    qryInsertSpare: TFDQuery;
    qryListCust: TFDQuery;
    qryPDF: TFDQuery;
    qryHTML: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDlocalAfterConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure CreateDB();
    procedure CreateDBWithDemoData();
  public
    { Public declarations }
    procedure AskCreateDB(ADemodata: boolean = false);
  end;

const svgdelete: string =
   '<?xml version="1.0" encoding="utf-8"?>' +
    '<svg width="800px" height="800px" viewBox="0 0 1024 1024" class="icon"  version="1.1" xmlns="http://www.w3.org/2000/svg"><path d="M779.5 1002.7h-535c-64.3 0-116.5-52.3-116.5-116.5V170.7h768v715.5c0 64.2-52.3 116.5-116.5 116.5zM213.3 256v630.1c0 17.2 14 31.2 31.2 31.2h534.9c17.2 0 31.2-14 31.2-31.2V256H213.3z" fill="#3688FF" /><path d="M917.3 256H106.7C83.1 256 64 236.9 64 213.3s19.1-42.7 42.7-42.7h810.7c23.6 0 42.7 19.1 42.7 42.7S940.9 256 917.3 256zM618.7 128H405.3c-23.6 0-42.7-19.1-42.7-42.7s19.1-42.7 42.7-42.7h213.3c23.6 0 42.7 19.1 42.7 42.7S642.2 128 618.7 128zM405.3 725.3c-23.6 0-42.7-19.1-42.7-42.7v-256c0-23.6 19.1-42.7 42.7-42.7S448 403 448 426.6v256c0 23.6-19.1 42.7-42.7 42.7zM618.7 725.3c-23.6 0-42.7-19.1-42.7-42.7v-256c0-23.6 19.1-42.7 42.7-42.7s42.7 19.1 42.7 42.7v256c-0.1 23.6-19.2 42.7-42.7 42.7z" fill="#5F6379" /></svg>';

var
  DM: TDM;
  SQLITE_DATABASE: string;
  COMMON_FILE_PATH: string;
  ReportManager: TReportConfig;

procedure DeleteFilesWithSuffix(const AFolder, ASuffix: string);
procedure DeleteFilesWithExtension(const AFolder, AExtension: string);

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  // Changed 16.04.2026 If Assigned not required, object.free does it automatically
  ReportManager.Free;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
const
  DB_NAME: string = 'WorksheetsZR.sdb';
begin
  // Setup connection information depending on platform (e.g. android, windows)
  {$IF DEFINED(Android)}
    SQLITE_DATABASE := TPath.Combine(TPath.GetHomePath, DB_NAME); // default where app is
    COMMON_FILE_PATH := TPath.GetHomePath;
  {$ELSEIF DEFINED(MSWINDOWS)}
    COMMON_FILE_PATH := TPath.Combine(TPath.GetDocumentsPath, 'WorksheetsZR');
    ForceDirectories(COMMON_FILE_PATH);   // create folder if not exists
    SQLITE_DATABASE := TPath.Combine(COMMON_FILE_PATH, DB_NAME);
  {$ENDIF}
  FDlocal.Params.Database := SQLITE_DATABASE;
  // If not found, we create the database
  if not FileExists(SQLITE_DATABASE) then
    CreateDB();
  // now the report
  ReportManager := TReportConfig.Create(DM.FDlocal);
end;

procedure TDM.FDlocalAfterConnect(Sender: TObject);
begin
  FDLocal.ExecSQL('PRAGMA foreignkeys = ON');
end;

procedure TDM.CreateDBWithDemoData();
begin
  // Database is created with schema and test data
  FDlocal.Open; // this creates the database as configured as CreateOnOpen
  FDLocal.ExecSQL(SQL_SCHEMA);
  FDLocal.ExecSQL(SQL_DATA_CUSTOMERS);
  FDLocal.ExecSQL(SQL_DATA_JOBS);
  FDLocal.Close;
end;

procedure TDM.AskCreateDB(ADemodata: boolean);
begin
  var MSG := 'WARNING!' + sLineBreak + 'This will DESTROY all existing data' + sLineBreak;
  if ADemodata then
    MSG := MSG + 'Do you wish to delete the database and recreate with default data ?'
  else
    MSG := MSG + 'Do you wish to delete the database ?';
  TDialogService.MessageDialog(Msg, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        // Delete the existing database!
        if FileExists(SQLITE_DATABASE) then
        begin
          FDlocal.Close; // ensure it is closed!
          try
            TFile.Delete(SQLITE_DATABASE);
          except
            on E: Exception do
            begin
              ShowException('Delete Existing Database', E);
              exit;
            end;
          end;
        end;
        // Now delete stray .pdf / signatures
        DeleteFilesWithSuffix(COMMON_FILE_PATH, 'signature.png');
        DeleteFilesWithExtension(COMMON_FILE_PATH, '.pdf');
        if ADemodata then
        begin
          CreateDBWithDemoData();
          ShowInfo('The database schema has been created with demonstration data');
        end
        else
        begin
          CreateDB();
          ShowInfo('The database schema has been created');
        end;
      end;
    end
  );
end;

procedure TDM.CreateDB();
begin
  FDlocal.Open; // this creates the database
  FDLocal.ExecSQL(SQL_SCHEMA); // Now create the default schema
  FDLocal.Close;
end;

procedure DeleteFilesWithExtension(const AFolder, AExtension: string);
var
  Files: TArray<string>;
  FileName: string;
  Ext: string;
begin
  // Normalise extension (".pdf" or "pdf" both accepted)
  Ext := AExtension.Trim;
  if (Ext <> '') and (Ext[1] <> '.') then
    Ext := '.' + Ext;
  // Get all matching files in the folder
  Files := TDirectory.GetFiles(AFolder, '*' + Ext, TSearchOption.soTopDirectoryOnly);
  for FileName in Files do
  begin
    try
      TFile.Delete(FileName);
    except
      on E: Exception do
      begin
        ShowException('DeleteFilesWithExtension', E);
      end;
    end;
  end;
end;

procedure DeleteFilesWithSuffix(const AFolder, ASuffix: string);
var
  Files: TArray<string>;
  FileName: string;
  Pattern: string;
begin
  // Normalise suffix (no wildcard needed from caller)
  Pattern := '*' + ASuffix.Trim;
  Files := TDirectory.GetFiles(AFolder, Pattern, TSearchOption.soTopDirectoryOnly);
  for FileName in Files do
  begin
    try
      TFile.Delete(FileName);
    except
      on E: Exception do
      begin
        ShowException('DeleteFilesWithSuffix', E);
      end;
    end;
  end;
end;

{ TReportConfig }

constructor TReportConfig.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FQry := TFDQuery.Create(nil);
  FQry.Connection := AConnection;
  LoadReportConfig();
end;

destructor TReportConfig.Destroy;
begin
  FQry.Free;
  inherited;
end;

function TReportConfig.GetHeader: string;
begin
  result := Format('%s%s%s%s%s', [FName, sLineBreak, FPhone, sLineBreak, FEmail]);
end;

function TReportConfig.GetHeaderHTML: string;
begin
  result := Format('%s<br>%s<br>%s', [FName, FPhone, FEmail]);
end;

procedure TReportConfig.LoadReportConfig;
begin
  try
    FQry.Close;
    FQry.Open('SELECT * FROM reportconfig WHERE id = 1');
    if not FQry.IsEmpty then
    begin
      FHasData := true;
      FName := FQry.FieldByName('headername').AsString;
      FPhone := FQry.FieldByName('headertelephone').AsString;
      FEmail := FQry.FieldByName('headeremail').AsString;
    // Load theme
      var S := FQry.FieldByName('csstheme').AsString;
      if S <> '' then
        FTheme := TWorksheetTheme(GetEnumValue(TypeInfo(TWorksheetTheme), S))
      else
        FTheme := wtOriginal;
    end
    else
    begin
      // set defaults...
      FHasData := false;
      FName := 'Your Company Name Here';
      FPhone := 'Tag Line or Telephone';
      FEmail := 'Tag Line or Email';
      FTheme := wtOriginal;
    end;
  finally
    FQry.Close;
  end;
end;

procedure TReportConfig.Save;
begin
  FQry.Close; // just incase!
  FQry.SQL.Text := 'INSERT OR REPLACE INTO reportconfig (id, headername, headertelephone, headeremail, csstheme) VALUES (1, :headername, :headertelephone, :headeremail, :csstheme)';
  FQry.ParamByName('headername').AsString := Trim(FName);
  FQry.ParamByName('headertelephone').AsString := Trim(FPhone);
  FQry.ParamByName('headeremail').AsString := Trim(FEmail);
  FQry.ParamByName('csstheme').AsString := GetEnumName(TypeInfo(TWorksheetTheme), Ord(FTheme));
  FQry.ExecSQL;
  ShowInfo('Report Configuration has been updated');
end;

end.
