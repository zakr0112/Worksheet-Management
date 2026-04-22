// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Changed 16.04.2026 Ensured all exceptions raised used the same begin/end and ShowException call
// Changed 16.04.2026 If Assigned not required, object.free does it automatically

unit uJobsManagerClass;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Param,
  uCommonDialogs;

type
  TJobManager = class
  private
    FQry: TFDQuery;
    FJobno: Integer;
    FJobtype: string;
    FJobdate: TDateTime;
    FCustname: string;
    FAddress: string;
    FPostcode: string;
    FTelephone: string;
    FEmail: string;
    FCallno: string;
    FContractno: string;
    FReason: string;
    FWorkdone: string;
    FRemedial: string;
    FReferredto: string;
    FEngineername1: string;
    FEngineername2: string;
    FSignedby: String;
    FSignaturepathdata: String;
    FLastchanged: TDateTime;
    FOrigJobno: Integer;
    FOrigJobtype: string;
    FOrigJobdate: TDateTime;
    FOrigCustname: string;
    FOrigAddress: string;
    FOrigPostcode: string;
    FOrigTelephone: string;
    FOrigEmail: string;
    FOrigCallno: string;
    FOrigContractno: string;
    FOrigReason: string;
    FOrigWorkdone: string;
    FOrigRemedial: string;
    FOrigReferredto: string;
    FOrigEngineername1: string;
    FOrigEngineername2: string;
    FOrigSignedby: String;
    FOrigSignaturepathdata: String;
    FOrigLastchanged: TDateTime;
    function HasChanges: Boolean;
    function GetWrappedSignatureSVG: string;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy(); override;
    property Jobno: Integer read FJobno write FJobno;
    property Jobtype: string read FJobtype write FJobtype;
    property Jobdate: TDateTime read FJobdate write FJobdate;
    property Custname: string read FCustname write FCustname;
    property Address: string read FAddress write FAddress;
    property Postcode: string read FPostcode write FPostcode;
    property Telephone: string read FTelephone write FTelephone;
    property Email: string read FEmail write FEmail;
    property Callno: string read FCallno write FCallno;
    property Contractno: string read FContractno write FContractno;
    property Reason: string read FReason write FReason;
    property Workdone: string read FWorkdone write FWorkdone;
    property Remedial: string read FRemedial write FRemedial;
    property Referredto: string read FReferredto write FReferredto;
    property Engineername1: string read FEngineername1 write FEngineername1;
    property Engineername2: string read FEngineername2 write FEngineername2;
    property Signedby: String read FSignedby write FSignedby;
    property Signaturepathdata: String read FSignaturepathdata write FSignaturepathdata;
    property Lastchanged: TDateTime read FLastchanged write FLastchanged;
    property GetSignatureSVG: string read GetWrappedSignatureSVG;
    function FetchJob(const AJobno: Integer): Boolean;
    function DeleteJob(const AJobno: Integer = -1): boolean;
    function InsertJob: boolean;
    function UpdateJob: boolean;
  end;

var
  Job: TJobManager;

implementation

{ TJobManager }

destructor TJobManager.Destroy;
begin
  // Changed 16.04.2026 If Assigned not required, object.free does it automatically
  FQry.Free;
  inherited;
end;

constructor TJobManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FQry := TFDQuery.Create(nil);
  FQry.Connection := AConnection;
end;

function TJobManager.DeleteJob(const AJobno: Integer): boolean;
begin
  Result := false;
  try
    try
      FQry.SQL.Text := 'DELETE FROM jobs_master WHERE jobno = :jobno';
      FQry.ParamByName('jobno').AsInteger := AJobno;
      FQry.ExecSQL;
      if FQry.RowsAffected < 1 then
        exit;
      Result := true;
    except
      on E: exception do
      begin
        ShowException('DeleteJob', E);
      end;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TJobManager.FetchJob(const AJobno: Integer): Boolean;
begin
  Result := False;
  try
    FQry.SQL.Text := 'SELECT * FROM jobs_master WHERE jobno = :jobno';
    FQry.ParamByName('jobno').AsInteger := AJobno;
    FQry.Open;
    if not FQry.Eof then
    begin

      FJobno := FQry.FieldByName('jobno').AsInteger;
      FJobtype := Trim(FQry.FieldByName('jobtype').AsString);
      FJobdate := Trunc(FQry.FieldByName('jobdate').AsDateTime);
      FCustname  := Trim(FQry.FieldByName('custname').AsString);
      FAddress   := Trim(FQry.FieldByName('address').AsString);
      FPostcode  := Trim(FQry.FieldByName('postcode').AsString);
      FTelephone := Trim(FQry.FieldByName('telephone').AsString);
      FEmail     := Trim(FQry.FieldByName('email').AsString);
      FCallno := Trim(FQry.FieldByName('callno').AsString);
      FContractno := Trim(FQry.FieldByName('contractno').AsString);
      FReason := Trim(FQry.FieldByName('reason').AsString);
      FWorkdone := Trim(FQry.FieldByName('workdone').AsString);
      FRemedial := Trim(FQry.FieldByName('remedial').AsString);
      FReferredto := Trim(FQry.FieldByName('referredto').AsString);
      FEngineername1 := Trim(FQry.FieldByName('engineername1').AsString);
      FEngineername2 := Trim(FQry.FieldByName('engineername2').AsString);
      FSignedby := Trim(FQry.FieldByName('signedby').AsString);
      FSignaturepathdata := Trim(FQry.FieldByName('signaturepathdata').AsString);
      FLastchanged := FQry.FieldByName('lastchanged').AsDateTime;
      FOrigJobno := FJobno;
      FOrigJobtype := FJobtype;
      FOrigJobdate := FJobdate;
      FOrigCustname := FCustname;
      FOrigAddress := FAddress;
      FOrigPostcode := FPostcode;
      FOrigTelephone := FTelephone;
      FOrigEmail := FEmail;
      FOrigCallno := FCallno;
      FOrigContractno := FContractno;
      FOrigReason := FReason;
      FOrigWorkdone := FWorkdone;
      FOrigRemedial := FRemedial;
      FOrigReferredto := fReferredto;
      FOrigEngineername1 := FEngineername1;
      FOrigEngineername2 := FEngineername2;
      FOrigSignedby := FSignedby;
      FOrigSignaturepathdata := FSignaturepathdata;
      FOrigLastchanged := FLastChanged;
      Result := True;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TJobManager.GetWrappedSignatureSVG: string;
const
  svgwrapper: string =
    '<svg width="640px" height="200px" xmlns="http://www.w3.org/2000/svg" viewBox="0, 0, 640, 200" preserveAspectRatio="xMidYMid">' +
    '<path style="fill:#ffffff00;fill-opacity:0;stroke:#1a1a1a;stroke-width:2px;stoke-opacity:1" d="%s" /></svg>';
begin
  Result := '';
  if not FSignaturepathdata.IsEmpty then
  begin
    Result := Format(svgwrapper, [FSignaturepathdata]);
  end;
end;

function TJobManager.HasChanges: Boolean;
begin
  Result :=
    (FJobtype <> FOrigJobtype) or
    (FJobdate <> FOrigJobdate) or
    (FCustname <> FOrigCustname) or
    (FAddress <> FOrigAddress) or
    (FPostcode <> FOrigPostcode) or
    (FTelephone <> FOrigTelephone) or
    (FEmail <> FOrigEmail) or
    (FCallno <> FOrigCallno) or
    (FContractno <> FOrigContractno) or
    (FReason <> FOrigReason) or
    (FWorkdone <> FOrigWorkdone) or
    (FRemedial <> FOrigRemedial) or
    (FReferredto <> FOrigReferredto) or
    (FEngineername1 <> FOrigEngineername1) or
    (FEngineername1 <> FOrigEngineername1) or
    (FSignedby <> FOrigSignedby) or
    (FSignaturepathdata <> FOrigSignaturepathdata);
end;

function TJobManager.UpdateJob: Boolean;
begin
  Result := False;

  // Optional: avoid unnecessary writes
  if not HasChanges then
    Exit(True);

  try
    FQry.SQL.Text :=
      'UPDATE jobs_master SET ' +
      ' jobtype = :jobtype, ' +
      ' jobdate = :jobdate, ' +
      ' custname = :custname, ' +
      ' address = :address, ' +
      ' postcode = :postcode, ' +
      ' email = :email, ' +
      ' telephone = :telephone, ' +
      ' callno = :callno, ' +
      ' contractno = :contractno, ' +
      ' reason = :reason, ' +
      ' workdone = :workdone, ' +
      ' remedial = :remedial, ' +
      ' referredto = :referredto, ' +
      ' engineername1 = :engineername1, ' +
      ' engineername2 = :engineername2, ' +
      ' signedby = :signedby, ' +
      ' signaturepathdata = :signaturepathdata, ' +
      ' lastchanged = :lastchanged ' +
      'WHERE jobno = :jobno';

    // Bind parameters
    FQry.ParamByName('jobno').AsInteger := FJobno;
    FQry.ParamByName('jobtype').AsString := FJobtype;
    FQry.ParamByName('jobdate').AsDateTime := FJobdate;
    FQry.ParamByName('custname').AsString := FCustname;
    FQry.ParamByName('address').AsString := FAddress;
    FQry.ParamByName('postcode').AsString := FPostcode;
    FQry.ParamByName('email').AsString := FEmail;
    FQry.ParamByName('telephone').AsString := FTelephone;
    FQry.ParamByName('callno').AsString := FCallno;
    FQry.ParamByName('contractno').AsString := FContractno;
    FQry.ParamByName('reason').AsString := FReason;
    FQry.ParamByName('workdone').AsString := FWorkdone;
    FQry.ParamByName('remedial').AsString := FRemedial;
    FQry.ParamByName('referredto').AsString := FReferredto;
    FQry.ParamByName('engineername1').AsString := FEngineername1;
    FQry.ParamByName('engineername2').AsString := FEngineername2;
    FQry.ParamByName('signedby').AsString := FSignedby;
    FQry.ParamByName('signaturepathdata').AsString := FSignaturepathdata;

    // Always update lastchanged
    FLastchanged := Now;
    FQry.ParamByName('lastchanged').AsDateTime := FLastchanged;
    FQry.ExecSQL;
    Result := FQry.RowsAffected > 0;
  except
    on E: Exception do
    begin
      ShowException('UpadteJob', E);
    end;
  end;
  FQry.Close;
  FQry.SQL.Text := '';
end;

function TJobManager.InsertJob: Boolean;
begin
  Result := False;
  FQry.Close;
  try
    // Always update lastchanged before saving
    FLastchanged := Now;

    FQry.SQL.Text :=
      'INSERT INTO jobs_master (' +
      ' jobtype, jobdate, custname, address, postcode, email, telephone, ' +
      ' callno, contractno, reason, workdone, remedial, referredto, ' +
      ' engineername1, engineername2, signedby, signaturepathdata, lastchanged' +
      ') VALUES (' +
      ' :jobtype, :jobdate, :custname, :address, :postcode, :email, :telephone, ' +
      ' :callno, :contractno, :reason, :workdone, :remedial, :referredto, ' +
      ' :engineername1, :engineername2, :signedby, :signaturepathdata, :lastchanged' +
      ')';

    // Bind parameters
    FQry.ParamByName('jobtype').AsString := FJobtype;
    FQry.ParamByName('jobdate').AsDateTime := FJobdate;
    FQry.ParamByName('custname').AsString := FCustname;
    FQry.ParamByName('address').AsString := FAddress;
    FQry.ParamByName('postcode').AsString := FPostcode;
    FQry.ParamByName('email').AsString := FEmail;
    FQry.ParamByName('telephone').AsString := FTelephone;
    FQry.ParamByName('callno').AsString := FCallno;
    FQry.ParamByName('contractno').AsString := FContractno;
    FQry.ParamByName('reason').AsString := FReason;
    FQry.ParamByName('workdone').AsString := FWorkdone;
    FQry.ParamByName('remedial').AsString := FRemedial;
    FQry.ParamByName('referredto').AsString := FReferredto;
    FQry.ParamByName('engineername1').AsString := FEngineername1;
    FQry.ParamByName('engineername2').AsString := FEngineername2;
    FQry.ParamByName('signedby').AsString := FSignedby;
    FQry.ParamByName('signaturepathdata').AsString := FSignaturepathdata;
    FQry.ParamByName('lastchanged').AsDateTime := FLastchanged;
    FQry.ExecSQL;
    // Retrieve the new jobno (SQLite-specific)
    FQry.SQL.Text := 'SELECT last_insert_rowid() AS jobno';
    FQry.Open;
    if not FQry.Eof then
    begin
      FJobno := FQry.FieldByName('jobno').AsInteger;
      // Sync original values for HasChanges logic
      FOrigJobno := FJobno;
      FOrigJobtype := FJobtype;
      FOrigJobdate := FJobdate;
      FOrigCustname := FCustname;
      FOrigAddress := FAddress;
      FOrigPostcode := FPostcode;
      FOrigTelephone := FTelephone;
      FOrigEmail := FEmail;
      FOrigCallno := FCallno;
      FOrigContractno := FContractno;
      FOrigReason := FReason;
      FOrigWorkdone := FWorkdone;
      FOrigRemedial := FRemedial;
      FOrigReferredto := FReferredto;
      FOrigEngineername1 := FEngineername1;
      FOrigEngineername2 := FEngineername2;
      FOrigSignedby := FSignedby;
      FOrigSignaturepathdata := FSignaturepathdata;
      FOrigLastchanged := FLastchanged;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      ShowException('InsertJob', E);
    end;
  end;
  FQry.Close;
  FQry.SQL.Text := '';
end;

end.
