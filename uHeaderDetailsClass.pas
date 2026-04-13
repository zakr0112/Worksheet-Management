unit uHeaderDetailsClass;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
  Data.DB, uCommonDialogs;

type

  THeaderDetailsManager = class
  private
    FQry: TFDQuery;
    FName: String;
    FEmail: String;
    FPhone: String;
    FHasData: boolean;
    procedure LoadHeader;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Save;
    function GetHeader(): string;
    property Name: String read FName write FName;
    property Phone: String read FPhone write FPhone;
    property Email: String read FEmail write FEmail;
  end;

implementation

destructor THeaderDetailsManager.Destroy();
begin
  FQry.Free;
  inherited;
end;

function THeaderDetailsManager.GetHeader(): string;
begin
  result := Format('%s%s%s%s%s', [FName, sLineBreak, FPhone, sLineBreak, FEmail]);
end;

constructor THeaderDetailsManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FQry := TFDQuery.Create(nil);
  FQry.Connection := AConnection;
  LoadHeader();
end;

procedure THeaderDetailsManager.LoadHeader();
begin
  try
    FQry.Close;
    FQry.Open(
      'SELECT headername, headertelephone, headeremail ' +
      'FROM headerdetails ' +
      'WHERE id = 1'
    );
    if not FQry.IsEmpty then
    begin
      FHasData := true;
      FName := FQry.FieldByName('headername').AsString;
      FPhone := FQry.FieldByName('headertelephone').AsString;
      FEmail := FQry.FieldByName('headeremail').AsString;
    end
    else
    begin
      // set defaults...
      FHasData := false;
      FName := 'Worksheet Manager';
      FPhone := '0800 03482132';
      FEmail := 'worksheetmanager@worksheet.com';
    end;
  finally
    FQry.Close;
  end;
end;

procedure THeaderDetailsManager.Save();
begin
  FQry.Close; // just incase!
  FQry.SQL.Text :=
    'INSERT OR REPLACE INTO headerdetails ' +
    '(id, headername, headertelephone, headeremail) ' +
    'VALUES (1, :headername, :headertelephone, :headeremail)';
  FQry.ParamByName('headername').AsString := Trim(FName);
  FQry.ParamByName('headertelephone').AsString := Trim(FPhone);
  FQry.ParamByName('headeremail').AsString := Trim(FEmail);
  FQry.ExecSQL;
  ShowInfo('Report Header Information has been updated');
end;

end.
