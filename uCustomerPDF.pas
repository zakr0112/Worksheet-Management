unit uCustomerPDF;

interface

uses
  System.Classes, System.SysUtils, System.Math, System.IOUtils, System.Types, uCommon, uDatamodule, Data.DB, fpdf_ext,
  uCommonDialogs, uJobsManagerClass, uCommonUTF8Helper, System.StrUtils,
  uSvgSignatureHelper
  {$IFDEF Android}
    , Posix.Unistd
  {$ENDIF}
  ;

type
  TCustomerPDF = class(TFPDFExt)
  protected
  public
    fJobno: integer;
    fJobdate: string;
    fSignaturePath: string;
    fSignedBy: string;
    fHeaderTitle: string;
    FCurrentJob: TJobManager;
    function PrintJob(): boolean;
    procedure Header(); override;
    procedure Footer(); override;
    procedure ForcePageIfNoRoom(const ARequiredheightmm: integer);
    procedure SetTheMetaData();
    procedure SetTitleFont();
    procedure SetHeaderSection(const ASectionTitle: string);
    procedure SetDataFont();
    function secondstohuman(ASeconds: Integer; ABlankforzero: boolean = false): string;
  end;

implementation

procedure TCustomerPDF.Footer;
begin
  inherited;
  var prtdate := FormatDateTime('dd/mm/yyyy hh:nn', Now());
  SetY(-15);
  SetFont('Arial', '', 8);
  SetTextColor(0);
  SetFillColor(244, 244, 244);
  SetDrawColor(124, 124, 124);
  Cell(140, 7, Format('WORKSHEET JOB - %d (Printed %s)', [fJobNo, prtdate]), 'T', 0, 'L', false);
  Cell(50, 7, Format('[PAGE %d of {nb}]', [PageNo()]), 'T', 0, 'R', false);
end;

procedure TCustomerPDF.ForcePageIfNoRoom(const ARequiredheightmm: integer);
begin
  var spaceleft := 277.0 - GetY();
  if spaceleft < ARequiredheightmm then
    AddPage();
end;

procedure TCustomerPDF.Header();
begin
  inherited;
  SetFillColor(244, 244, 244);
  SetDrawColor(124, 124, 124);
  SetTextColor(0);
  SetFont('Arial', 'B', 14);
  SetLineWidth(0.1);
  var LOGO :=
    {$IF DEFINED(ANDROID)}
    TPath.Combine(TPath.GetDocumentsPath, 'logo.png');
    {$ELSE}
    Tpath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'logo.png');
    {$ENDIF}
  if FileExists(LOGO) then
    Image(LOGO, 10, 8, 20, 20);
  MultiCell(190, 6, FHeadertitle, '0', 'C', false);
  Ln(5);
  SetY(10.1);
  SetX(-40.0);
  SetFont('Times', '', 18);
  Cell(30, 8, 'JOB', '', 2, 'R', false);
  SetTextColor(255, 0, 0); // RED
  SetFont('Times', 'B', 30);
  Cell(30, 10, Format('%d', [fJobNo]), '', 1, 'R', false);
  Ln(5);
end;

function TCustomerPDF.PrintJob(): boolean;
var
  traveltimeseconds: integer;
  totexpenses: single;
  totalmileage: integer;
  sitetime: integer;
  tottime: integer;
  y: double;
  heightmm: integer;
  I: integer;
  work: string;
begin
  Result := true;
  traveltimeseconds := 0;
  totalmileage := 0;
  sitetime := 0;
  tottime := 0;

  // ===========================================================================
  // MAIN DETAILS processing...
  // ===========================================================================
  try
    try
      fJobdate := FormatDateTime('dd/mm/yyyy', FCurrentJob.JobDate);
      AddPage();
      SetDrawColor(90, 90, 90); // Border
      SetFillColor(186, 186, 186);
      SetLineWidth(0.1);
      SetHeaderSection('JOB DETAILS');
      SetTitleFont();
      Cell(30, 6, 'JOB TYPE', 'LTRB', 0, 'L', false);
      SetDataFont();
      Cell(65, 6, FCurrentJob.JobType, 'LTRB', 0, 'L', false);
      SetTitleFont();
      Cell(35, 6, 'JOB DATE', 'LTRB', 0, 'L', false);
      SetDataFont();
      Cell(60, 6, fJobdate, 'LTRB', 1, 'L', false);
      SetTitleFont();
      Cell(30, 6, 'CALL NUMBER', 'LTRB', 0, 'L', false);
      SetDataFont();
      Cell(65, 6, FCurrentJob.CallNo, 'LTRB', 0, 'L', false);
      SetTitleFont();
      Cell(35, 6, 'CONTRACT NUMBER', 'LTRB', 0, 'L', false);
      SetDataFont();
      Cell(60, 6, FCurrentJob.ContractNo, 'LTRB', 1, 'L', false);
      SetTitleFont();
      Cell(30, 6, 'ENGINEERS', 'LTRB', 0, 'L', false);
      SetDataFont();
      Cell(160, 6, Format('%s%s', [FCurrentJob.EngineerName1, IfThen(FCurrentJob.EngineerName2.IsEmpty, '', ', ' + FCurrentJob.EngineerName2)]), 'LTRB', 1, 'L', false);
      //Cell(160, 6, Format('%s %s', [FCurrentJob.EngineerName1, FCurrentJob.EngineerName2]), 'LTRB', 1, 'L', false);
      //Cell(95, 6, FCurrentJob.EngineerName2, 'LTRB', 1, 'L', false);
      Ln(5);
      SetHeaderSection('CUSTOMER DETAILS');
      SetDataFont();
      work := Trim(FCurrentJob.CustName + sLineBreak + FCurrentJob.Address + sLineBreak + FCurrentJob.Postcode);
      MultiCell(190, 6, work, 'LTRB', 'L', false);
      Ln(5);
      SetHeaderSection('REASON FOR VISIT');
      SetDataFont();
      MultiCell(190, 6, SanitiseInput(FCurrentJob.Reason), 'LTRB', 'L', false);
      Ln(5);
      SetHeaderSection('WORK CARRIED OUT');
      SetDataFont();
      MultiCell(190, 6, SanitiseInput(FCurrentJob.WorkDone), 'LTRB', 'L', false);
      Ln(5);
      SetHeaderSection('REMEDIAL ACTION / VARIATIONS');
      SetDataFont();
      MultiCell(190, 6, SanitiseInput(FCurrentJob.Remedial), 'LTRB', 'L', false);
      SetTitleFont();
      Cell(55, 6, 'REFERRED TO (IF APPLICABLE)', 'LTRB', 0, 'L', false);
      SetDataFont();
      Cell(135, 6, FCurrentJob.ReferredTo, 'LTRB', 2, 'L', false);
      Ln(5);
    except
      on E: Exception do
      begin
        ShowError('PDFMainSection ' + sLinebreak +  E.Message);
        exit(false);
      end;
    end;
  finally
    DM.qryPDF.Close;
  end;

  // ===========================================================================
  // Now the spare parts...
  // ===========================================================================
  try
    try
      SetHeaderSection('PARTS / SPARES USED');
      SetTitleFont();
      Cell(20, 8, 'QTY USED', 'LTRB', 0, 'C', false);
      Cell(170, 8, 'DESCRIPTION & SIZE', 'LTRB', 1, 'L', false);
      SetDataFont();
      DM.qryPDF.Open(Format('SELECT jobno, qtyused, partdetails FROM jobs_spareparts WHERE jobno = %d ORDER BY lastchanged', [fJobno]));
      while not DM.qryPDF.eof do
      begin
        Cell(20, 6, DM.qryPDF.FieldByName('qtyused').AsString, 'LRTB', 0, 'L', false);
        Cell(170, 6, DM.qryPDF.FieldByName('partdetails').AsString, 'LRTB', 1, 'L', false);
        DM.qryPDF.Next;
      end;
      DM.qryPDF.Close;
      Ln(5);
    except
      on E: Exception do
      begin
        ShowError('PDFSpareparts' + sLineBreak + E.Message);
        exit(false);
      end;
    end;
  finally
    DM.qryPDF.Close;
  end;

  // ===========================================================================
  // Time...
  // ===========================================================================
  try
    try
      DM.qryPDF.Open(Format('SELECT * FROM jobs_timerecords WHERE jobno = %d ORDER BY logdate ASC', [fJobno]));
      heightmm := 6 + 8 + 7 + (DM.qryPDF.RecordCount * 6);
      ForcePageIfNoRoom(heightmm);
      SetHeaderSection('JOB TIME / TRAVEL DETAILS');
      SetTitleFont();
      Cell(27, 4, 'TRAVEL', 'LR', 0, 'L', false);
      Cell(27, 4, 'TRAVEL', 'LR', 0, 'C', false);
      Cell(27, 4, 'TIME', 'LR', 0, 'C', false);
      Cell(27, 4, 'TIME', 'LR', 0, 'C', false);
      Cell(27, 4, 'TOTAL', 'LR', 0, 'C', false);
      Cell(27, 4, 'TOTAL', 'LR', 0, 'C', false);
      Cell(28, 4, 'TOTAL', 'LR', 1, 'C', false);
      Cell(27, 4, 'DATE', 'LRB', 0, 'L', false);
      Cell(27, 4, 'TIME', 'LRB', 0, 'C', false);
      Cell(27, 4, 'ARRIVED', 'LRB', 0, 'C', false);
      Cell(27, 4, 'DEPARTED', 'LRB', 0, 'C', false);
      Cell(27, 4, 'SITE TIME', 'LRB', 0, 'C', false);
      Cell(27, 4, 'JOB TIME', 'LRB', 0, 'C', false);
      Cell(28, 4, 'MILEAGE', 'LRB', 1, 'C', false);
      SetDataFont();
      while not DM.qryPDF.eof do
      begin
        traveltimeseconds := traveltimeseconds + DM.qryPDF.FieldByName('traveltimeseconds').AsInteger;
        totalmileage := totalmileage + DM.qryPDF.FieldByName('mileage').AsInteger;
        sitetime := sitetime + DM.qryPDF.FieldByName('jobtimeseconds').AsInteger;
        tottime := tottime + DM.qryPDF.FieldByName('totaltimeseconds').AsInteger;
        Cell(27, 6, FormatDateTime('dd/mm/yyyy', DM.qryPDF.FieldByName('logdate').AsDateTime), 'TLRB', 0, 'L', false);
        Cell(27, 6, secondstohuman(DM.qryPDF.FieldByName('traveltimeseconds').AsInteger, true), 'TLRB', 0, 'C', false);
        Cell(27, 6, FormatDateTime('hh:nn', DM.qryPDF.FieldByName('timearrived').AsDateTime), 'TLRB', 0, 'C', false);
        Cell(27, 6, FormatDateTime('hh:nn', DM.qryPDF.FieldByName('timedeparted').AsDateTime), 'TLRB', 0, 'C', false);
        Cell(27, 6, secondstohuman(DM.qryPDF.FieldByName('jobtimeseconds').AsInteger), 'TLRB', 0, 'C', false);
        Cell(27, 6, secondstohuman(DM.qryPDF.FieldByName('totaltimeseconds').AsInteger), 'TLRB', 0, 'C', false);
        if DM.qryPDF.FieldByName('mileage').AsInteger > 0 then
          Cell(28, 6, DM.qryPDF.FieldByName('mileage').AsString, 'TLRB', 1, 'C', false)
        else
          Cell(28, 6, '', 'TLRB', 1, 'C', false);
        DM.qryPDF.Next;
      end;
      if DM.qryPDF.RecordCount > 0 then
      begin
        Cell(27, 6, 'TOTALS', 'TLRB', 0, 'L', false);
        Cell(27, 6, secondstohuman(traveltimeseconds, true), 'TLRB', 0, 'C', false);
        Cell(54, 6, '', 'TLRB', 0, 'C', false);
        Cell(27, 6, secondstohuman(sitetime, false), 'TLRB', 0, 'C', false);
        Cell(27, 6, secondstohuman(tottime, false), 'TLRB', 0, 'C', false);
        if totalmileage > 0 then
          Cell(28, 6, IntToStr(totalmileage), 'TLRB', 1, 'C', false)
        else
          Cell(28, 6, '', 'TLRB', 1, 'C', false);
      end;
      Ln(5);
    except
      on E: Exception do
      begin
        ShowError('PDFTime' + sLineBreak + E.Message);
        exit(false);
      end;
    end;
  finally
    DM.qryPDF.Close;
  end;

  // ===========================================================================
  // Expenses...
  // ===========================================================================

  try
    try
      DM.qryPDF.Open(Format('SELECT * FROM jobs_expenses WHERE jobno = %d ORDER BY exdate ASC, lastchanged ASC', [fJobno]));
      heightmm := 6 + 8 + 7 + (DM.qryPDF.RecordCount * 6);
      totexpenses := 0.00;
      ForcePageIfNoRoom(heightmm);
      SetHeaderSection('JOB EXPENSES');
      SetTitleFont();
      Cell(30, 4, 'DATE', 'LRB', 0, 'L', false);
      Cell(130, 4, 'EXPENSE DETAILS', 'LRB', 0, 'L', false);
      Cell(30, 4, 'COST £', 'LRB', 1, 'R', false);
      SetDataFont();
      while not DM.qryPDF.eof do
      begin
        totexpenses := totexpenses + DM.qryPDF.FieldByName('excost').AsFloat;
        Cell(30, 6, FormatDateTime('dd/mm/yyyy', DM.qryPDF.FieldByName('exdate').AsDateTime), 'TLRB', 0, 'L', false);
        Cell(130, 6, DM.qryPDF.FieldByName('exdetails').AsString, 'TLRB', 0, 'L', false);
        Cell(30, 6, FormatFloat('0.00', DM.qryPDF.FieldByName('excost').AsFloat), 'TLRB', 1, 'R', false);
        DM.qryPDF.Next;
      end;
      if DM.qryPDF.RecordCount > 0 then
      begin
        Cell(160, 6, 'TOTAL EXPENSES ', 'TLRB', 0, 'R', false);
        Cell(30, 6, FormatFloat('0.00', totexpenses), 'TLRB', 1, 'R', false);
      end;
      Ln(5);
    except
      on E: Exception do
      begin
        ShowError('PDFExpenses' + sLineBreak + E.Message);
        exit(false);
      end;
    end;
  finally
    DM.qryPDF.Close;
  end;

  // ===========================================================================
  // Signature processing...
  // ===========================================================================
  try
    try
      if fCurrentJob.Signaturepathdata.IsEmpty then
      begin
        ForcePageIfNoRoom(14);
        SetHeaderSection('CUSTOMER SIGNATURE');
        SetTitleFont();
        Cell(50, 6, 'NAME OF PERSON SIGNING', 'LTRB', 0, 'L', false);
        SetDataFont();
        if fCurrentJob.Signedby.IsEmpty then
          Cell(140, 6, 'NOT SIGNED', 'LTRB', 1, 'L', false)
        else
          Cell(140, 6, FCurrentJob.Signedby, 'LTRB', 1, 'L', false);
      end
      else
      begin
        ForcePageIfNoRoom(50);
        SetHeaderSection('CUSTOMER SIGNATURE');
        SetTitleFont();
        Cell(50, 6, 'NAME OF PERSON SIGNING', 'LTRB', 0, 'L', false);
        SetDataFont();
        if fCurrentJob.Signedby.IsEmpty then
          Cell(140, 6, 'NOT SIGNED', 'LTRB', 1, 'L', false)
        else
          Cell(140, 6, FCurrentJob.Signedby, 'LTRB', 1, 'L', false);
        Cell(190, 38, '', 'LTRB', 1, 'L', false);
        y := GetY();
        // convert save then display the signature!
        if not Job.Signaturepathdata.IsEmpty then
        begin
          // we have data, so hopefully can convert to a png!

          var SignatureFilename := TPath.Combine(PDF_PATH, Format('%d_signature.png', [Job.Jobno]));
          // consider changing to a function to avoid checks for FileExists?
          ExportSignatureAsPNG(Job.SignatureSVG, SignatureFilename);
          if FileExists(SignatureFilename) then
          begin
            Image(SignatureFilename, 30, y - 32, 90);
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        ShowError('PDFSignatures' + sLineBreak + E.Message);
        exit(false);
      end;
    end;
  finally
    DM.qryPDF.Close;
  end;

  // ===========================================================================
  // Photo processing...
  // ===========================================================================
  try
    try
      var photofile: string;
      for I := 1 to 6 do
      begin
        photofile := TPath.Combine(PDF_PATH, Format('pdf_photo_%d.png', [I]));
        if FileExists(photofile) then
          DeleteFile(photofile);
      end;
      DM.qryPDF.Close;
      I := 1;  // determines photo count as 1 3 5 require a new page!
      DM.qryPDF.Open(Format('SELECT photo, photono FROM jobs_photos WHERE jobno = %d ORDER BY photono LIMIT 6', [fJobno]));
      while not DM.qryPDF.Eof do
      begin
        if not DM.qryPDF.FieldByName('photo').IsNull then
        begin
          try
            photofile := TPath.Combine(PDF_PATH, Format('pdf_photo_%d.png', [DM.qryPDF.FieldByName('photono').AsInteger]));
            (DM.qryPDF.FieldByName('photo') as TBlobField).SaveToFile(photofile);
            case I of
              1, 3, 5:
                begin
                  AddPage();
                  SetHeaderSection('JOB PHOTOS');
                  if FileExists(photofile) then
                    Image(photofile, 10.5, 50.5, 188, 110);
                end;
              2, 4, 6:
                if FileExists(photofile) then
                  Image(photofile, 10.5, 166.5,  188, 110);
            end;
            Inc(I);
          except
            ShowToast('whopops');
          end;
        end;
        DM.qryPDF.Next;
      end;
    except
      on E: Exception do
      begin
        ShowError('PDFPhotos' + sLineBreak + E.Message);
        exit(false);
      end;
    end;
  finally
    DM.qryPDF.Close;
  end;

end;

function TCustomerPDF.secondstohuman(ASeconds: Integer; ABlankforzero: boolean): string;
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

procedure TCustomerPDF.SetDataFont();
begin
  SetFont('Arial', 'B', 10);
  SetFillColor(255); // white
  SetDrawColor(136); // Border
end;

procedure TCustomerPDF.SetHeaderSection(const ASectionTitle: string);
begin
  SetFont('Times','B', 12);
  SetFillColor(220); // white
  SetDrawColor(136); // Border   greyish
  Cell(190, 6, ASectionTitle, 'LTRB', 1, 'L', true);
end;

procedure TCustomerPDF.SetTheMetaData;
begin
  self.SetSubject('WORKSHEET PRIVATE AND CONFIDENTIAL');
  self.SetUTF8(true);
  self.SetAliasNbPages();
  self.SetCreator('WorksheetsFMX');
  self.SetAuthor('WorksheetsFMX');
end;

procedure TCustomerPDF.SetTitleFont();
begin
  SetFont('Times', '', 9);
  SetFillColor(255); // white
  SetDrawColor(136);
  SetTextColor(0);
end;

end.

