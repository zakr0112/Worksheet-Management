// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// This was generated via Coplilot AI
// I passed it the uWorksheetPDF.pas file as the base, as this is where the PDF report was generated
// and asked if it could create a modern html style output to compliment the PDF output
// It has taken about 33 revisions to get it right, but a learning excercise

unit uWorksheetHTML;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.StrUtils, System.Math,
  System.NetEncoding, FireDAC.Stan.Param,
  Data.DB, uDataModule,
  uJobsManagerClass, uCommon, uReportAndExportHelper;

const
  THEME_A_CLEAN: string =
    'body {font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f5f7fa; color: #333;}' +
    '.container {max-width: 900px; margin: 0 auto; padding: 25px; background: #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.06); border-radius: 6px;}' +
    '.header {display: flex; align-items: center; border-bottom: 2px solid #d9e2ec; padding-bottom: 15px; margin-bottom: 25px;}' +
    '.header img {height: 60px; margin-right: 20px;}' +
    '.header-title {flex: 1; font-size: 22px; font-weight: bold; color: #334e68;}' +
    '.job-number {text-align: right; line-height: 1.1;}' +
    '.job-label {font-family: "Times New Roman", Times, serif; font-size: 18px; color: #222;}' +
    '.job-value {font-family: "Times New Roman", Times, serif; font-size: 30px; font-weight: bold; color: #d64545;}' +
    '.section {margin-bottom: 30px;}' +
    '.section-title {font-size: 18px; font-weight: bold; margin-bottom: 12px; color: #3a7bd5; border-left: 4px solid #3a7bd5; padding-left: 10px; border-bottom: 1px solid #3a7bd5; padding-bottom: 6px;}' +
    '.row {margin-bottom: 6px;}' +
    '.label {font-weight: bold; display: inline-block; width: 180px;}' +
    '.value {color: #555;}' +
    'table {width: 100%; border-collapse: collapse; margin-top: 10px;}' +
    'th, td {padding: 8px; border-bottom: 1px solid #e0e0e0;}' +
    'th {background: #eef3f8; font-weight: bold; text-align: left;}' +
    '.photo {width: 100%; margin-top: 10px; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);}' +
    '.signature-container svg {width: 300px; height: auto; border: 1px solid #ccc; border-radius: 4px; margin-top: 10px; display: block;}' +
    '.footer {margin-top: 40px; padding-top: 15px; border-top: 1px solid #d0d0d0; font-size: 12px; color: #777; text-align: center;}';

const
  THEME_B_DARK: string =
    'body {font-family: Arial, sans-serif; margin: 0; padding: 0; background: #1e1e1e; color: #e0e0e0;}' +
    '.container {max-width: 900px; margin: 0 auto; padding: 25px; background: #2a2a2a; border-radius: 6px;}' +
    '.header {display: flex; align-items: center; border-bottom: 2px solid #444; padding-bottom: 15px; margin-bottom: 25px;}' +
    '.header img {height: 60px; margin-right: 20px; filter: brightness(0.9);}' +
    '.header-title {flex: 1; font-size: 22px; font-weight: bold; color: #ffffff;}' +
    '.job-number {text-align: right; line-height: 1.1;}' +
    '.job-label {font-family: "Times New Roman", Times, serif; font-size: 18px; color: #ccc;}' +
    '.job-value {font-family: "Times New Roman", Times, serif; font-size: 30px; font-weight: bold; color: #ff6b6b;}' +
    '.section {margin-bottom: 30px;}' +
    '.section-title {font-size: 18px; font-weight: bold; margin-bottom: 12px; color: #4da3ff; border-left: 4px solid #4da3ff; padding-left: 10px; border-bottom: 1px solid #4da3ff; padding-bottom: 6px;}' +
    '.row {margin-bottom: 6px;}' +
    '.label {font-weight: bold; display: inline-block; width: 180px;}' +
    '.value {color: #ccc;}' +
    'table {width: 100%; border-collapse: collapse; margin-top: 10px;}' +
    'th, td {padding: 8px; border-bottom: 1px solid #444;}' +
    'th {background: #3a3a3a; font-weight: bold; text-align: left; color: #fff;}' +
    '.photo {width: 100%; margin-top: 10px; border-radius: 6px; box-shadow: 0 1px 4px rgba(255,255,255,0.1);}' +
    '.signature-container svg {width: 300px; height: auto; border: 1px solid #555; border-radius: 4px; margin-top: 10px; display: block;}' +
    '.footer {margin-top: 40px; padding-top: 15px; border-top: 1px solid #555; font-size: 12px; color: #aaa; text-align: center;}';

const
  THEME_C_MINIMAL: string =
    'body {font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; margin: 0; padding: 0; background: #ffffff; color: #222;}' +
    '.container {max-width: 900px; margin: 0 auto; padding: 40px;}' +
    '.header {display: flex; align-items: center; border-bottom: 1px solid #e5e5e5; padding-bottom: 20px; margin-bottom: 30px;}' +
    '.header img {height: 55px; margin-right: 25px;}' +
    '.header-title {flex: 1; font-size: 24px; font-weight: 600; color: #111;}' +
    '.job-number {text-align: right; line-height: 1.1;}' +
    '.job-label {font-family: "Times New Roman", Times, serif; font-size: 18px; color: #111;}' +
    '.job-value {font-family: "Times New Roman", Times, serif; font-size: 30px; font-weight: bold; color: #d32f2f;}' +
    '.section {margin-bottom: 30px;}' +
    '.section-title {font-size: 20px; font-weight: 600; margin-bottom: 15px; color: #111; border-left: 3px solid #111; padding-left: 12px;}' +
    '.row {margin-bottom: 6px;}' +
    '.label {font-weight: 600; display: inline-block; width: 180px;}' +
    '.value {color: #444;}' +
    'table {width: 100%; border-collapse: collapse; margin-top: 10px;}' +
    'th, td {padding: 8px; border-bottom: 1px solid #e5e5e5;}' +
    'th {background: #fafafa; font-weight: 600; text-align: left;}' +
    '.photo {width: 100%; margin-top: 10px; border-radius: 8px;}' +
    '.signature-container svg {width: 300px; height: auto; border: 1px solid #ddd; border-radius: 4px; margin-top: 10px; display: block;}' +
    '.footer {margin-top: 40px; padding-top: 15px; border-top: 1px solid #e5e5e5; font-size: 12px; color: #777; text-align: center;}';

const
  THEME_D_ORIGINAL: string =
    'body {font-family: Arial, sans-serif; margin: 0; padding: 0; background: #fafafa; color: #333;}' +
    '.container {max-width: 900px; margin: 0 auto; padding: 20px; background: #fff;}' +
    '.header {display: flex; align-items: center; border-bottom: 2px solid #e0e0e0; padding-bottom: 15px; margin-bottom: 25px;}' +
    '.header img {height: 60px; margin-right: 20px;}' +
    '.header-title {flex: 1; font-size: 22px; font-weight: bold; color: #444;}' +
    '.job-number {text-align: right; line-height: 1.1;}' +
    '.job-label {font-family: "Times New Roman", Times, serif; font-size: 18px; font-weight: normal; color: black;}' +
    '.job-value {font-family: "Times New Roman", Times, serif; font-size: 30px; font-weight: bold; color: #d32f2f;}' +
    '.section {margin-bottom: 30px;}' +
    '.section-title {font-size: 18px; font-weight: bold; margin-bottom: 12px; color: #0078d7; border-left: 4px solid #0078d7; padding-left: 10px; border-bottom: 1px solid #0078d7; padding-bottom: 6px;}' +
    '.row {margin-bottom: 6px;}' +
    '.label {font-weight: bold; display: inline-block; width: 180px;}' +
    '.value {color: #555;}' +
    'table {width: 100%; border-collapse: collapse; margin-top: 10px;}' +
    'th, td {padding: 8px; border-bottom: 1px solid #e0e0e0;}' +
    'th {background: #f0f0f0; font-weight: bold; text-align: left;}' +
    '.photo {width: 100%; margin-top: 10px; border-radius: 6px;}' +
    '.signature-container svg {width: 300px; height: auto; border: 1px solid #ccc; border-radius: 4px; margin-top: 10px; display: block;}' +
    '.footer {margin-top: 40px; padding-top: 15px; border-top: 1px solid #d0d0d0; font-size: 12px; color: #777; text-align: center;}';

const
  THEME_E_MOBILE: string =
    'body {font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f2f2f2; color: #333;}' +
    '.container {max-width: 100%; margin: 0 auto; padding: 12px; background: #fff;}' +
    '.header {display: flex; align-items: center; gap: 12px; border-bottom: 1px solid #ddd; padding-bottom: 12px; margin-bottom: 18px;}' +
    '.header img {height: 48px; flex-shrink: 0;}' +
    '.header-title {flex: 1; font-size: 18px; font-weight: bold; color: #444; line-height: 1.2;}' +
    '.job-number {text-align: right; line-height: 1.1; font-size: 14px;}' +
    '.job-label {font-family: "Times New Roman", Times, serif; font-size: 16px; color: black;}' +
    '.job-value {font-family: "Times New Roman", Times, serif; font-size: 24px; font-weight: bold; color: #d32f2f;}' +
    '.section {margin-bottom: 22px;}' +
    '.section-title {font-size: 16px; font-weight: bold; margin-bottom: 10px; color: #0078d7; border-left: 4px solid #0078d7; padding-left: 8px; border-bottom: 1px solid #0078d7; padding-bottom: 4px;}' +
    '.row {margin-bottom: 6px; display: flex; flex-wrap: wrap;}' +
    '.label {font-weight: bold; width: 100%; font-size: 14px; margin-bottom: 2px;}' +
    '.value {color: #555; width: 100%; font-size: 14px;}' +
    'table {width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 14px;}' +
    'th, td {padding: 6px; border-bottom: 1px solid #e0e0e0;}' +
    'th {background: #f7f7f7; font-weight: bold; text-align: left;}' +
    '.photo {width: 100%; margin-top: 10px; border-radius: 6px;}' +
    '.signature-container svg {width: 240px; height: auto; border: 1px solid #ccc; border-radius: 4px; margin-top: 10px; display: block;}' +
    '.footer {margin-top: 30px; padding-top: 12px; border-top: 1px solid #d0d0d0; font-size: 11px; color: #777; text-align: center;}' +
    '@media (min-width: 600px) {' +
      '.container {padding: 20px;}' +
      '.header-title {font-size: 22px;}' +
      '.job-value {font-size: 30px;}' +
      '.section-title {font-size: 18px;}' +
      '.label {width: 180px; font-size: 15px;}' +
      '.value {font-size: 15px; width: calc(100% - 180px);}' +
    '}';

function CreateWorksheetHtml(const AJobNo: Integer; const AJob: TJobManager): string;

implementation

// Set of helpers for using images in html

// 1. Convert bytes → Base64 <img> tag
function BytesToBase64ImgTag(const Bytes: TBytes; const CssClass: string): string;
var
  B64: string;
begin
  if Length(Bytes) = 0 then
    Exit('');
  B64 := TNetEncoding.Base64.EncodeBytesToString(Bytes);
  Result := '<img class="' + CssClass + '" src="data:image/png;base64,' + B64 + '">';
end;

// 2. Convert a photo file → Base64 <img> tag
function ImageFileToBase64ImgTag(const Filename: string): string;
var
  Bytes: TBytes;
  B64: string;
begin
  if not FileExists(Filename) then
    Exit('');
  Bytes := TFile.ReadAllBytes(Filename);
  B64 := TNetEncoding.Base64.EncodeBytesToString(Bytes);
  Result := '<img class="photo" src="data:image/png;base64,' + B64 + '">';
end;

// 3. Convert ANY file → Base64 <img> tag
function FileToBase64ImgTag(const Filename, CssClass: string): string;
var
  Bytes: TBytes;
begin
  if not FileExists(Filename) then
    Exit('');
  Bytes := TFile.ReadAllBytes(Filename);
  Result := BytesToBase64ImgTag(Bytes, CssClass);
end;

function HtmlEscape(const S: string): string;
begin
  Result := S.Replace('&', '&amp;')
    .Replace('<', '&lt;')
    .Replace('>', '&gt;')
    .Replace('"', '&quot;')
    .Replace(#13#10, '<br>')
    .Replace(#10, '<br>');
end;

function GetWorksheetThemeCSS(Theme: TWorksheetTheme): string;
begin
  case Theme of
    wtOriginal: Result := THEME_D_ORIGINAL;
    wtClean:    Result := THEME_A_CLEAN;
    wtDark:     Result := THEME_B_DARK;
    wtMinimal:  Result := THEME_C_MINIMAL;
    wtMobile:   Result := THEME_E_MOBILE;
  else
    Result := THEME_D_ORIGINAL;
  end;
end;

function CreateWorksheetHtml(const AJobNo: Integer; const AJob: TJobManager): string;
var
  html, filename, device: string;
  sb: TStringBuilder;
begin
  filename := GetWorksheetFileName(AJobno, '.html');
  {$IF DEFINED(ANDROID)}
      device := 'Android';
  {$ELSE}
     device := 'Win64';
  {$ENDIF}
  sb := TStringBuilder.Create;
  try
    sb.AppendLine('<!DOCTYPE html>');
    sb.AppendLine('<html lang="en">');
    sb.AppendLine('<head>');
    sb.AppendLine('<meta charset="UTF-8">');
    sb.AppendLine('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    sb.AppendLine('<meta name="author" content="Zak Richards">');
    sb.AppendLine('<meta name="generator" content="Worksheets Manager (Delphi 12.1 FMX ' + device + ' )">');
    sb.AppendLine('<meta name="created-by" content="Zak Richards">');
    sb.AppendLine('<meta name="copyright" content="© Zak Richards">');
    sb.AppendLine('<meta name="description" content="Job Worksheet generated by Zak Richards">');
    sb.AppendLine('<meta name="company" content="Zak Richards">');
    sb.AppendLine('<meta name="worksheet-jobno" content="' + AJobNo.ToString + '">');
    sb.AppendLine('<meta name="worksheet-generated" content="' + FormatDateTime('yyyy-mm-dd hh:nn', Now) + '">');
    sb.AppendLine('<title>Worksheet Manager - Job ' + AJobNo.ToString + '</title>');
    sb.AppendLine('<style>');
    sb.AppendLine(GetWorksheetThemeCSS(ReportManager.Theme));
    sb.AppendLine('</style>');
    sb.AppendLine('</head>');
    sb.AppendLine('<body>');
    sb.AppendLine('<div class="container">');

    // WEBPAGE HEADER
    sb.AppendLine('<div class="header">');
    var LOGO :=
    {$IF DEFINED(ANDROID)}
      TPath.Combine(TPath.GetDocumentsPath, 'logo.png');
    {$ELSE}
      Tpath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'logo.png');
    {$ENDIF}
    if FileExists(LOGO) then
      sb.AppendLine(FileToBase64ImgTag(LOGO, 'logo'));
    sb.AppendLine('<div class="header-title" style="text-align:center;">' + ReportManager.GetHeaderHTML() + '</div>');
    sb.AppendLine('<div class="job-number"><div class="job-label">JOB</div><div class="job-value">' + AJobNo.ToString + '</div></div>');
    sb.AppendLine('</div>');

    // JOB HEADER
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">JOB DETAILS</div>');
    sb.AppendLine('<div class="row"><span class="label">Job Type:</span><span class="value">' + HtmlEscape(AJob.JobType) + '</span></div>');
    sb.AppendLine('<div class="row"><span class="label">Job Date:</span><span class="value">' + FormatDateTime('dd/mm/yyyy', AJob.JobDate) + '</span></div>');
    sb.AppendLine('<div class="row"><span class="label">Call Number:</span><span class="value">' + HtmlEscape(AJob.CallNo) + '</span></div>');
    sb.AppendLine('<div class="row"><span class="label">Contract Number:</span><span class="value">' + HtmlEscape(AJob.ContractNo) + '</span></div>');
    sb.AppendLine('<div class="row"><span class="label">Engineers:</span><span class="value">' + HtmlEscape(AJob.EngineerName1 + IfThen(AJob.EngineerName2.IsEmpty, '', ', ' + AJob.EngineerName2)) + '</span></div>');
    sb.AppendLine('</div>');

    // CUSTOMER DETAILS
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Customer Details</div>');
    sb.AppendLine(HtmlEscape(AJob.CustName) + '<br>');
    sb.AppendLine(HtmlEscape(AJob.Address) + '<br>');
    sb.AppendLine(HtmlEscape(AJob.Postcode));
    sb.AppendLine('</div>');

    // REASON
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Reason for Visit</div>');
    sb.AppendLine(HtmlEscape(AJob.Reason));
    sb.AppendLine('</div>');

    // WORK DONE
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Work Carried Out</div>');
    sb.AppendLine(HtmlEscape(AJob.WorkDone));
    sb.AppendLine('</div>');

    // REMEDIAL
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Remedial Action / Variations</div>');
    sb.AppendLine(HtmlEscape(AJob.Remedial));
    sb.AppendLine('<div class="row"><span class="label">Referred To:</span><span class="value">' + HtmlEscape(AJob.ReferredTo) + '</span></div>');
    sb.AppendLine('</div>');

    // PARTS
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Parts / Spares Used</div>');
    sb.AppendLine('<table><tr><th>Qty</th><th>Description</th></tr>');
    DM.qryHTML.Close;
    DM.qryHTML.SQL.Text := 'SELECT qtyused, partdetails FROM jobs_spareparts WHERE jobno=:jobno ORDER BY lastchanged';
    DM.qryHTML.ParamByName('jobno').AsInteger := AJobNo;
    DM.qryHTML.Open;
    try
      while not DM.qryHTML.Eof do
      begin
        sb.AppendLine('<tr><td>' + DM.qryHTML.FieldByName('qtyused').AsString + '</td><td>' + HtmlEscape(DM.qryHTML.FieldByName('partdetails').AsString) + '</td></tr>');
        DM.qryHTML.Next;
      end;
    finally
      DM.qryHTML.Close;
    end;
    sb.AppendLine('</table></div>');

    // TIME RECORDS
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Job Time / Travel Details</div>');
    sb.AppendLine('<table>');
    sb.AppendLine('<tr><th>Date</th><th>Travel</th><th>Arrived</th><th>Departed</th><th>Site Time</th><th>Total Time</th><th>Mileage</th></tr>');
    DM.qryHTML.SQL.Text := 'SELECT * FROM jobs_timerecords WHERE jobno=:jobno ORDER BY logdate;';
    DM.qryHTML.ParamByName('jobno').AsInteger := AJobNo;
    DM.qryHTML.Open;
    try
      while not DM.qryHTML.Eof do
      begin
        sb.AppendLine('<tr>');
        sb.AppendLine('<td>' + FormatDateTime('dd/mm/yyyy', DM.qryHTML.FieldByName('logdate').AsDateTime) + '</td>');
        sb.AppendLine('<td>' + secondstohuman(DM.qryHTML.FieldByName('traveltimeseconds').AsInteger, true) + '</td>');
        sb.AppendLine('<td>' + FormatDateTime('hh:nn', DM.qryHTML.FieldByName('timearrived').AsDateTime) + '</td>');
        sb.AppendLine('<td>' + FormatDateTime('hh:nn', DM.qryHTML.FieldByName('timedeparted').AsDateTime) + '</td>');
        sb.AppendLine('<td>' + secondstohuman(DM.qryHTML.FieldByName('jobtimeseconds').AsInteger) + '</td>');
        sb.AppendLine('<td>' + secondstohuman(DM.qryHTML.FieldByName('totaltimeseconds').AsInteger) + '</td>');
        sb.AppendLine('<td>' + DM.qryHTML.FieldByName('mileage').AsString + '</td>');
        sb.AppendLine('</tr>');
        DM.qryHTML.Next;
      end;
    finally
      DM.qryHTML.Close;
    end;
    sb.AppendLine('</table></div>');

    // EXPENSES
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Job Expenses</div>');
    sb.AppendLine('<table><tr><th>Date</th><th>Details</th><th>Cost (£)</th></tr>');
    DM.qryHTML.SQL.Text := 'SELECT * FROM jobs_expenses WHERE jobno=:jobno ORDER BY exdate';
    DM.qryHTML.ParamByName('jobno').AsInteger := AJobNo;
    DM.qryHTML.Open;
    try
      while not DM.qryHTML.Eof do
      begin
        sb.AppendLine('<tr>');
        sb.AppendLine('<td>' + FormatDateTime('dd/mm/yyyy', DM.qryHTML.FieldByName('exdate').AsDateTime) + '</td>');
        sb.AppendLine('<td>' + HtmlEscape(DM.qryHTML.FieldByName('exdetails').AsString) + '</td>');
        sb.AppendLine('<td>' + FormatFloat('0.00', DM.qryHTML.FieldByName('excost').AsFloat) + '</td>');
        sb.AppendLine('</tr>');
        DM.qryHTML.Next;
      end;
    finally
      DM.qryHTML.Close;
    end;
    sb.AppendLine('</table></div>');

    // SIGNATURE
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Customer Signature</div>');
    sb.AppendLine('<div class="row"><span class="label">Signed By:</span><span class="value">' + HtmlEscape(AJob.SignedBy) + '</span></div>');
    if not AJob.SignaturePathData.IsEmpty then
    begin
      sb.AppendLine('<div class="signature-container">');
      sb.AppendLine(AJob.GetSignatureSVG);
      sb.AppendLine('</div>');
    end;
    sb.AppendLine('</div>');

    // PHOTOS
    sb.AppendLine('<div class="section">');
    sb.AppendLine('<div class="section-title">Job Photos</div>');
    DM.qryHTML.SQL.Text := 'SELECT photo, photono FROM jobs_photos WHERE jobno = :jobno ORDER BY photono LIMIT 6';
    DM.qryHTML.ParamByName('jobno').AsInteger := AJobNo;
    DM.qryHTML.Open;
    try
      var BlobField := DM.qryHTML.FieldByName('photo') as TBlobField;
      while not DM.qryHTML.Eof do
      begin
        if not BlobField.IsNull and (BlobField.BlobSize > 0) then
        begin
          var Bytes := BlobField.AsBytes;   // ← ONLY ONCE
          if Length(Bytes) > 0 then
            sb.AppendLine(BytesToBase64ImgTag(Bytes, 'photo'));
        end;
        DM.qryHTML.Next;
      end;
    finally
      DM.qryHTML.Close;
    end;
    sb.AppendLine('</div>');

    // FOOTER
    sb.AppendLine('<div class="footer">Worksheet generated for Job ' + AJobNo.ToString + ' on ' +  FormatDateTime('dd/mm/yyyy hh:nn', Now()) + '</div>');
    sb.AppendLine('</div></body></html>');
    html := sb.ToString;
    TFile.WriteAllText(filename, html, TEncoding.UTF8);
    Result := filename;
  finally
    sb.Free;
  end;
end;

end.

