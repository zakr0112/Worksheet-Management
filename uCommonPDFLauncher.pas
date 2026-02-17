unit uCommonPDFLauncher;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uWorksheetPDF, uDataModule, uCommonDialogs, uJobsManagerClass,
  {$IFDEF Android}
    Androidapi.JNI.GraphicsContentViewText,
    Androidapi.JNI.Embarcadero,
    Androidapi.JNI.Net,
    Androidapi.JNI.JavaTypes,
    Androidapi.JNI.Support,
    Androidapi.JNI.App,
    Androidapi.JNI.Os,
    Androidapi.JNIBridge,
    Androidapi.JNI.Provider,
    Androidapi.Helpers,
    FMX.Platform.Android,
    FMX.Helpers.Android,
    Posix.Unistd;
  {$ENDIF}
  {$IF Defined(IOS)}
    iOSapi.Foundation, iOSapi.UIKit, Macapi.Helpers, Posix.Unistd;
  {$ENDIF}
  {$IF Defined(MACOS)}
    Macapi.Foundation, Macapi.AppKit, Macapi.Helpers, Posix.Unistd;
  {$ENDIF}
  {$IF Defined(MSWINDOWS)}
    Winapi.ShellAPI, Winapi.Windows;
  {$ENDIF}

  function PDFRebuildRequired(ADatetime: TDateTime; AFilename: string): Boolean;
  procedure LaunchPDF(const AFilename: string); overload;
  procedure LaunchPDF(const AJobno: Integer); overload;
  function CreateWorksheetPdf(const AJobno: integer; AShowSavedMsg: boolean = false): boolean;
  function GetWorksheetFilename(const AJobno: Integer): string;

implementation

uses
  System.IOUtils;

function GetWorksheetFilename(const AJobno: Integer): string;
begin
  Result := TPath.Combine(SAVE_PATH, Format('Worksheet %d.pdf', [AJobno]));
end;

function PDFRebuildRequired(ADatetime: TDateTime; AFilename: string): Boolean;
var
  FileDateTime: TDateTime;
begin
  // Check if the file exists
  if not TFile.Exists(AFilename) then
  begin
    Result := True;  // File doesn't exist, needs to be created
    Exit;
  end;
  // Get the last modified datetime of the file
  FileDateTime := TFile.GetLastWriteTime(AFilename);
  // Check if the file's last modified datetime is earlier than the given datetime
  Result := FileDateTime < ADateTime;
end;

procedure LaunchPDF(const AFilename: string); overload;
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
  FileURI: Jnet_Uri;
  PDFFilePath: string;
{$ENDIF}
{$IF Defined(MACOS)}
var
  URL: NSURL;
{$ENDIF}
{$IF Defined(IOS)}
var
  URL: NSURL;
{$ENDIF}
begin
  if not FileExists(AFilename) then
    exit;
  {$IF Defined(MSWINDOWS)}
    ShellExecute(0, nil, PChar(AFilename), nil,  nil, SW_SHOWNORMAL);
  {$ENDIF}
  {$IF Defined(ANDROID)}
    PDFFilePath := TPath.Combine(TPath.GetDocumentsPath, AFilename);
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
    FileURI := TAndroidHelper.JFileToJURI(TJFile.JavaClass.init(StringToJString(PDFFilePath)));
    Intent.setDataAndType(FileURI, StringToJString('application/pdf'));
    Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NO_HISTORY or TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF}
  {$IF Defined(MACOS)}
    URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStr(TPath.Combine(TPath.GetDocumentsPath, AFilename))));
    NSWorkspace.sharedWorkspace.openURL(URL);
  {$ENDIF}
  {$IF Defined(IOS)}
    URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStr(TPath.Combine(TPath.GetDocumentsPath, AFilename))));
    SharedApplication.openURL(URL);
  {$ENDIF}
end;

procedure LaunchPDF(const AJobno: Integer); overload;
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
  FileURI: Jnet_Uri;
{$ENDIF}
{$IF Defined(MACOS)}
var
  URL: NSURL;
{$ENDIF}
{$IF Defined(IOS)}
var
  URL: NSURL;
{$ENDIF}
begin
  if AJobno < 1 then
    exit;

  var PDFFilePath := GetWorksheetFilename(AJobno);
  {$IF Defined(MSWINDOWS)}
    ShellExecute(0, nil, PChar(PDFFilePath), nil,  nil, SW_SHOWNORMAL);
  {$ENDIF}
  {$IF Defined(ANDROID)}
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
    FileURI := TAndroidHelper.JFileToJURI(TJFile.JavaClass.init(StringToJString(PDFFilePath)));
    Intent.setDataAndType(FileURI, StringToJString('application/pdf'));
    Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NO_HISTORY or TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF}
  {$IF Defined(MACOS)}
    URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStr(TPath.Combine(TPath.GetDocumentsPath, AFilename))));
    NSWorkspace.sharedWorkspace.openURL(URL);
  {$ENDIF}
  {$IF Defined(IOS)}
    URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStr(TPath.Combine(TPath.GetDocumentsPath, AFilename))));
    SharedApplication.openURL(URL);
  {$ENDIF}
end;

//function CreateWorksheetPdf(const AJobno: integer; AShowSavedMsg: boolean = false): boolean; overload;

function CreateWorksheetPdf(const AJobno: integer; AShowSavedMsg: boolean = false): boolean;
var
pdfsqlite : TWorksheetPDF;
begin
  Result := true;
  pdfsqlite := TWorksheetPDF.Create;
  try
    try
      var PDF_FILENAME := GetWorksheetFilename(AJobno);
      pdfsqlite.FCurrentJob := Job;
      pdfsqlite.SetUTF8(true);
      pdfsqlite.SetAliasNbPages();
      pdfsqlite.SetTitle(Format('Worksheet %d.pdf', [AJobno]));
      pdfsqlite.SetSubject('PRIVATE AND CONFIDENTIAL');
      pdfsqlite.SetCreator('WorkSheetsFMX');
      pdfsqlite.SetAuthor('WorkSheetsFMX');
      pdfsqlite.fJobno := AJobNo;
      if not pdfsqlite.PrintJob then
        exit(false);
      pdfsqlite.SaveToFile(PDF_FILENAME);
      if FileExists(PDF_FILENAME) then
      begin
        {$IF NOT Defined(MSWINDOWS)}
          ShowToast(Format('Worksheet PDF %d has been generated', [AJobno]));
        {$ENDIF}
      end;
    except
      on E: Exception do
      begin
        ShowError('CreateWorksheetPdf' + slinebreak + E.Message);
      end;
    end;
  finally
    pdfsqlite.Free;
  end;
end;

end.

