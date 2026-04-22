// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Common functions for the export and report output:

unit uReportAndExportHelper;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.Variants, System.Threading, System.Math,
  FMX.StdCtrls,  FMX.Objects, FMX.Graphics, FMX.Skia, Skia, Xml.XMLDoc, Xml.XMLIntf,
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
  {$IF Defined(MSWINDOWS)}
    Winapi.ShellAPI, Winapi.Windows,
  {$ENDIF}
  System.TypInfo, FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB,
  uCommonDialogs, uJobsManagerClass;

function secondstohuman(ASeconds: Integer; ABlankforzero: boolean = false): string;
function GetWorksheetFileName(const AJobno: integer; const AExtension: string): string;
procedure ShowWorksheetPDFThread(const AJobno: integer; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);
procedure ShowWorksheetHTMLThread(const AJobno: integer; const AJob: TJobManager; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);

var
  WorksheetFilename: string;

implementation

uses
 System.IOUtils, uWorksheetPDF, uWorksheetHTML, uDataModule;

function GetWorksheetFileName(const AJobno: integer; const AExtension: string): string;
begin
  // Used to get the fully qualified device independant file name for the worksheet
  // Allows extension with or without a leading '.' character
  var ext := Trim(AExtension);
  if ext <> '' then
  begin
    if not ext.StartsWith('.') then
      ext := '.' + ext;
  end;
  var fileName := Format('Worksheet%d%s', [AJobno, AExtension]);
  {$IF DEFINED(Android)}
    // NOTE: Using GetCachePath in android, for FileProvider sharing
    Result := TPath.Combine(TPath.GetCachePath, fileName);
  {$ELSEIF DEFINED(MSWINDOWS)}
    var savePath := TPath.Combine(TPath.GetDocumentsPath, 'Worksheets');
    ForceDirectories(savePath); // ensure output folder exists!
    Result := TPath.Combine(savePath, fileName);
  {$ENDIF}
end;

function secondstohuman(ASeconds: Integer; ABlankforzero: boolean): string;
var
  Hours, Minutes: Integer;
begin
  Hours := Floor(ASeconds / 3600);
  Minutes := Floor((ASeconds mod 3600) / 60);
  Result := Format('%d:%2.2d', [Hours, Minutes]);
  if ABlankforzero then
  begin
    if Result = '0:00' then
     Result := '';
  end;
end;

procedure LaunchExternalFile(const AFilename: String);
{$IF Defined(Android)}
var
  Intent: JIntent;
  FileObj: JFile;
  Uri: Jnet_Uri;
  Authority: JString;
{$ENDIF}
begin
  // We are only looking for .pdf and .html file extensions
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
    // Note: only checking .pdf or .html at this version
    if AFilename.ToLower.EndsWith('.pdf') then
      Intent.setDataAndType(Uri, StringToJString('application/pdf'))
    else
      Intent.setDataAndType(Uri, StringToJString('text/html'));
    Intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    Intent.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NO_HISTORY);
    TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF}
end;

function CreateWorksheetPdf(const AJobno: integer): boolean;
begin
  Result := false;
  var PDF_FILENAME := GetWorksheetFileName(AJobno, '.pdf');
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
        exit(false);
      pdf.SaveToFile(PDF_FILENAME);
      if FileExists(PDF_FILENAME) then
      begin
      {$IF NOT Defined(MSWINDOWS)}
        ShowToast(Format('Worksheet PDF %d has been generated', [AJobno])); // Takes longer under android
      {$ENDIF}
      end;
      Result := true;
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

procedure ShowWorksheetPDFThread(const AJobno: integer; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);
begin
  // Create the pdf in a thread allows a animation effect to run to show the user something is happening
  // PDF creation can take a while!
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
            if CreateWorksheetPdf(AJobno) then
              LaunchExternalFile(GetWorksheetFileName(AJobno, '.pdf'));
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

procedure ShowWorksheetHTMLThread(const AJobno: integer; const AJob: TJobManager; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);
begin
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
            CreateWorksheetHTML(AJobno, AJob);
            LaunchExternalFile(GetWorksheetFileName(AJobno, '.html'));
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

end.

