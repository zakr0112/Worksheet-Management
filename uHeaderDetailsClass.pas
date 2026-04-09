unit uHeaderDetailsClass;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client;

type
  THeaderDetails = record
    HeaderName: string;
    HeaderTelephone: string;
    HeaderEmail: string;
  end;

  THeaderDetailsManager = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function Exists: Boolean;
    function Load(out ADetails: THeaderDetails): Boolean;
    procedure Save(const ADetails: THeaderDetails);
    procedure EnsureDefaultRow;
  end;

implementation

constructor THeaderDetailsManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function THeaderDetailsManager.Exists: Boolean;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text := 'SELECT 1 FROM headerdetails WHERE id = 1';
    Q.Open;
    Result := not Q.IsEmpty;
  finally
    Q.Free;
  end;
end;

function THeaderDetailsManager.Load(out ADetails: THeaderDetails): Boolean;
var
  Q: TFDQuery;
begin
  ADetails.HeaderName := '';
  ADetails.HeaderTelephone := '';
  ADetails.HeaderEmail := '';

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT headername, headertelephone, headeremail ' +
      'FROM headerdetails ' +
      'WHERE id = 1';
    Q.Open;

    Result := not Q.IsEmpty;
    if Result then
    begin
      ADetails.HeaderName := Q.FieldByName('headername').AsString;
      ADetails.HeaderTelephone := Q.FieldByName('headertelephone').AsString;
      ADetails.HeaderEmail := Q.FieldByName('headeremail').AsString;
    end;
  finally
    Q.Free;
  end;
end;

procedure THeaderDetailsManager.Save(const ADetails: THeaderDetails);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConnection;

    if Exists then
    begin
      Q.SQL.Text :=
        'UPDATE headerdetails ' +
        'SET headername = :headername, ' +
        '    headertelephone = :headertelephone, ' +
        '    headeremail = :headeremail ' +
        'WHERE id = 1';
    end
    else
    begin
      Q.SQL.Text :=
        'INSERT INTO headerdetails ' +
        '(id, headername, headertelephone, headeremail) ' +
        'VALUES ' +
        '(1, :headername, :headertelephone, :headeremail)';
    end;

    Q.ParamByName('headername').AsString := Trim(ADetails.HeaderName);
    Q.ParamByName('headertelephone').AsString := Trim(ADetails.HeaderTelephone);
    Q.ParamByName('headeremail').AsString := Trim(ADetails.HeaderEmail);
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure THeaderDetailsManager.EnsureDefaultRow;
var
  LDetails: THeaderDetails;
begin
  if not Exists then
  begin
    LDetails.HeaderName := 'Worksheet Manager';
    LDetails.HeaderTelephone := '0800 03482132';
    LDetails.HeaderEmail := 'worksheetmanager@worksheet.com';
    Save(LDetails);
  end;
end;

end.
