unit uCommonPDFLauncher;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Threading, uWorksheetPDF, uDataModule, uCommonDialogs, uJobsManagerClass,
  uHeaderDetailsClass, FMX.StdCtrls,  FMX.Objects,
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

  procedure LaunchPDF(const AFilename: string); overload;
  procedure LaunchPDF(const AJobno: Integer); overload;
  procedure CreateWorksheetPDFThread(const AJobNo: Integer; const AProgressAni: TAniIndicator; const AProgressRect: TRectangle);
  function CreateWorksheetPdf(const AJobno: integer; AShowSavedMsg: boolean = false): boolean;
  function GetWorksheetFilename(const AJobno: Integer): string;

implementation

uses
  System.IOUtils;

function GetWorksheetFilename(const AJobno: Integer): string;
begin
  Result := TPath.Combine(PDF_PATH, Format('Worksheet %d.pdf', [AJobno]));
end;

procedure OpenFile(const AFilePath: string);
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
  FileURI: Jnet_Uri;
{$ENDIF}
{$IF Defined(MACOS) or Defined(IOS)}
var
  URL: NSURL;
{$ENDIF}
begin
  if not FileExists(AFilePath) then
    Exit;

  {$IF Defined(MSWINDOWS)}
    ShellExecute(0, nil, PChar(AFilePath), nil, nil, SW_SHOWNORMAL);
  {$ENDIF}

  {$IF Defined(ANDROID)}
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
    FileURI := TAndroidHelper.JFileToJURI(
      TJFile.JavaClass.init(StringToJString(AFilePath))
    );
    Intent.setDataAndType(FileURI, StringToJString('application/pdf'));
    Intent.setFlags(
      TJIntent.JavaClass.FLAG_ACTIVITY_NO_HISTORY or
      TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION
    );
    TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF}

  {$IF Defined(MACOS) or Defined(IOS)}
    URL := TNSURL.Wrap(
      TNSURL.OCClass.fileURLWithPath(NSStr(AFilePath))
    );
    {$IF Defined(MACOS)}
      NSWorkspace.sharedWorkspace.openURL(URL);
    {$ELSE}
      SharedApplication.openURL(URL);
    {$ENDIF}
  {$ENDIF}
end;

procedure LaunchPDF(const AFilename: string); overload;
begin
  OpenFile(Afilename);
end;

procedure LaunchPDF(const AJobno: Integer); overload;
begin
  if AJobno < 1 then
    Exit;
  OpenFile(GetWorksheetFilename(AJobno));
end;

function CreateWorksheetPdf(const AJobno: integer; AShowSavedMsg: boolean = false): boolean;
var
  pdfworksheet : TWorksheetPDF;
begin
  Result := true;
  pdfworksheet := TWorksheetPDF.Create;
  try
    try
      var PDF_FILENAME := GetWorksheetFilename(AJobno);
      pdfworksheet.FCurrentJob := Job;
      pdfworksheet.SetUTF8(true);
      pdfworksheet.SetAliasNbPages();
      pdfworksheet.SetTitle(Format('Worksheet %d.pdf', [AJobno]));
      pdfworksheet.SetSubject('PRIVATE AND CONFIDENTIAL');
      pdfworksheet.SetCreator('WorkSheetsFMX');
      pdfworksheet.SetAuthor('WorkSheetsFMX');
      pdfworksheet.fJobno := AJobNo;
      pdfworksheet.fHeaderTitle := ReportManager.GetHeader();
      if not pdfworksheet.PrintJob then
        exit(false);
      pdfworksheet.SaveToFile(PDF_FILENAME);
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
    pdfworksheet.Free;
  end;
end;

procedure CreateWorksheetPDFThread(const AJobNo: Integer;
                              const AProgressAni: TAniIndicator;
                              const AProgressRect: TRectangle);
begin
  AProgressAni.Enabled := True;
  AProgressRect.Visible := True;

  TTask.Run(
    procedure
    var
      PDFBuilt: Boolean;
    begin
      try
        PDFBuilt := CreateWorksheetPdf(AJobNo);

        TThread.Queue(nil,
          procedure
          begin
            AProgressAni.Enabled := False;
            AProgressRect.Visible := False;

            if PDFBuilt then
              LaunchPDF(AJobNo);
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

