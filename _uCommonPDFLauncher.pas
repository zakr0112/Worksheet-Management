// ---------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Changed 16.04.2026 Ensured all exceptions raised used the same begin/end and ShowException call

unit uCommonPDFLauncher;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Threading, System.Math,
  FMX.StdCtrls,  FMX.Objects,
  {$IF Defined(ANDROID)}
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
    Posix.Unistd,
  {$ENDIF}
  {$IF Defined(IOS)}
    iOSapi.Foundation, iOSapi.UIKit, Macapi.Helpers, Posix.Unistd,
  {$ENDIF}
  {$IF Defined(MACOS)}
    Macapi.Foundation, Macapi.AppKit, Macapi.Helpers, Posix.Unistd,
  {$ENDIF}
  {$IF Defined(MSWINDOWS)}
    Winapi.ShellAPI, Winapi.Windows,
  {$ENDIF}
  uCommonDialogs, uWorksheetPDF, uDataModule, uJobsManagerClass;

  // Public, called from other units...
  procedure CreateWorksheetPdfViaThread(const AJobno: Integer; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);
  procedure LaunchPDF(const AFilename: string);

(*
  // Changed 14.04.2026 Removed procedures and functions from interface section that are not required by other units
  function CreateWorksheetPdf(const AJobno: integer): string;
  function GetPDFName(const AJobno: integer): string;
*)

implementation

uses
  System.IOUtils, uReportAndExportHelper;
(*
function GetPDFName(const AJobno: integer): string;
begin
  // Used to get the fully qualified device independant file name for the pdf worksheet
  const fileName: string = Format('Worksheet%d.pdf', [AJobno]);
  {$IF DEFINED(Android)}
    Result := TPath.Combine(TPath.GetCachePath, fileName);  // Cache for FileProvider sharing
  {$ELSEIF DEFINED(MSWINDOWS)}
    var savePath := TPath.Combine(TPath.GetDocumentsPath, 'Worksheets');
    ForceDirectories(savePath);
    Result := TPath.Combine(savePath, fileName);
  {$ELSEIF DEFINED(MACOS)}
    Result := TPath.Combine(TPath.GetDocumentsPath, fileName);
  {$ELSEIF DEFINED(IOS)}
    Result := TPath.Combine(TPath.GetDocumentsPath, fileName);
  {$ELSE}
    Result := TPath.Combine(TPath.GetDocumentsPath, fileName);  // Default fallback
  {$ENDIF}
end;
*)
function CreateWorksheetPdf(const AJobno: integer): string;
begin
  var PDF_FILENAME := GetWorksheetFileName(AJobno, '.pdf'); //GetPDFName(AJobno);
  Result := PDF_FILENAME;
  var pdf := TWorksheetPDF.Create;
  try
    try
      pdf.FCurrentJob := Job;
      pdf.SetUTF8(true);
      pdf.SetAliasNbPages();
      pdf.SetTitle(Format('Worksheet%d.pdf', [AJobno]));
      pdf.SetSubject('PRIVATE AND CONFIDENTIAL');
      pdf.SetCreator('WorkSheetsFMX');
      pdf.SetAuthor('WorkSheetsFMX');
      pdf.fJobno := AJobno;
      pdf.fHeaderTitle := ReportManager.GetHeader();
      if not pdf.PrintJob then
        exit('');
      pdf.SaveToFile(PDF_FILENAME);
      if FileExists(PDF_FILENAME) then
      begin
        {$IF NOT Defined(MSWINDOWS)}
          ShowToast(Format('Worksheet PDF %d has been generated', [AJobno]));
        {$ENDIF}
      end;
    except
      on E: Exception do
      begin
        ShowException('CreateWorksheetPdf', E);
      end;
    end;
  finally
    pdf.Free;
  end;
end;

// this is the only procedure that needs exposing to other units  (just ensure required ones are above in the code!)
procedure CreateWorksheetPdfViaThread(const AJobno: Integer; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);
begin
  // Create the pdf in a thread allows a animation effect to run to show the user something is happening
  AProgressAni.Enabled := True;
  AProgressRect.Visible := True;
  TTask.Run(
    procedure
    begin
      try
        TThread.Queue(nil,
          procedure
          begin
            AProgressAni.Enabled := False;
            AProgressRect.Visible := False;
            var PDFFILE := CreateWorksheetPdf(AJobno);
            if not PDFFILE.IsEmpty then
              LaunchExternalFile(PDFFILE);
          end);
      except
        on E: Exception do
        begin
          TThread.Queue(nil,
            procedure
            begin
              AProgressAni.Enabled := False;
              AProgressRect.Visible := False;
            end);
        end;
      end;
    end
  );
end;

procedure LaunchPDF(const AFilename: String);
{$IF Defined(Android)}
var
  Intent: JIntent;
  FileObj: JFile;
  Uri: Jnet_Uri;
  Authority: JString;
{$ENDIF}
{$IF Defined(IOS)}
var
  URL: NSURL;
{$ENDIF}
{$IF Defined(MACOS)}
var
  URL: NSURL;
{$ENDIF}
begin
  if AFilename.IsEmpty then
    Exit;
  if not FileExists(AFilename) then
    Exit;
  {$IF Defined(MSWINDOWS)}
    ShellExecute(0, nil, PChar(AFilename), nil, nil, SW_SHOWNORMAL);
  {$ENDIF}
  {$IF Defined(Android)}
    FileObj := TJFile.JavaClass.init(StringToJString(AFilename));
    Authority := StringToJString(JStringToString(TAndroidHelper.Context.getPackageName) + '.provider');
    Uri := TJContent_FileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, Authority, FileObj);
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
    Intent.setDataAndType(Uri, StringToJString('application/pdf'));
    Intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    Intent.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NO_HISTORY);
    TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF}
  {$IF Defined(IOS)}
    URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStr(AFilename)));
    SharedApplication.openURL(URL);
  {$ENDIF}
  {$IF Defined(MACOS)}
    URL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(NSStr(AFilename)));
    NSWorkspace.sharedWorkspace.openURL(URL);
  {$ENDIF}
end;

end.

