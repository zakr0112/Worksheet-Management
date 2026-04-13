unit uCustomerManagerClass;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Param,
  uCommonDialogs;

type
  TCustomerManager = class
  private
    FQry: TFDQuery;

    FCustID: Integer;
    FCustName: string;
    FCustAddress: string;
    FCustPostcode: string;
    FCustTelephone: string;
    FCustEmail: string;
    FCustContact: string;
    FLastChanged: TDateTime;

    FOriginalCustName: string;
    FOriginalCustAddress: string;
    FOriginalCustPostcode: string;
    FOriginalCustTelephone: string;
    FOriginalCustEmail: string;
    FOriginalCustContact: string;
    FOriginalLastChanged: TDateTime;
    function HasChanges: Boolean;
    function IsCustomerNameUnique(const ACustName: string; const ACustID: Integer = -1): Boolean;

  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy(); override;
    property CustID: Integer read FCustID write FCustID;
    property CustName: string read FCustName write FCustName;
    property CustAddress: string read FCustAddress write FCustAddress;
    property CustPostcode: string read FCustPostcode write FCustPostcode;
    property CustTelephone: string read FCustTelephone write FCustTelephone;
    property CustEmail: string read FCustEmail write FCustEmail;
    property CustContact: string read FCustContact write FCustContact;
    property LastChanged: TDateTime read FLastChanged write FLastChanged;
    function FetchCustomerByID(ACustID: Integer): Boolean;
    function FetchCustomerByName(ACustName: String): Boolean;
    function DeleteCustomer(const ACustID: Integer = -1): boolean;
    function InsertCustomer: boolean;
    function UpdateCustomer: boolean;
    function QuickInsertCustomer(const ACustname: string): boolean;
  end;

var
  Customer: TCustomerManager;

implementation

{ TCustomerManager }

destructor TCustomerManager.Destroy;
begin
  if Assigned(FQry) then
    FQry.Free;
  inherited;
end;

constructor TCustomerManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FQry := TFDQuery.Create(nil);
  FQry.Connection := AConnection;
end;

function TCustomerManager.FetchCustomerByID(ACustID: Integer): Boolean;
begin
  Result := False;
  try
    FQry.SQL.Text := 'SELECT * FROM customers WHERE custid = :custid';
    FQry.ParamByName('custid').AsInteger := ACustID;
    FQry.Open;
    if not FQry.Eof then
    begin
      FCustName      := Trim(FQry.FieldByName('custname').AsString);
      FCustAddress   := Trim(FQry.FieldByName('custaddress').AsString);
      FCustPostcode  := Trim(FQry.FieldByName('custpostcode').AsString);
      FCustTelephone := Trim(FQry.FieldByName('custtelephone').AsString);
      FCustEmail     := Trim(FQry.FieldByName('custemail').AsString);
      FCustContact   := Trim(FQry.FieldByName('custcontact').AsString);
      FLastChanged   := Trunc(FQry.FieldByName('lastchanged').AsDateTime); // or use RoundTo if needed
      FOriginalCustName := FCustName;
      FOriginalCustAddress := FCustAddress;
      FOriginalCustPostcode := FCustPostcode;
      FOriginalCustTelephone := FCustTelephone;
      FOriginalCustEmail := FCustEmail;
      FOriginalCustContact := FCustContact;
      FOriginalLastChanged := FLastChanged;
      Result := True;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TCustomerManager.FetchCustomerByName(ACustName: String): Boolean;
begin
  // can be used for quick validation of customer name entry...
  Result := False;
  try
    FQry.SQL.Text := 'SELECT * FROM customers WHERE custname = :custname';
    FQry.ParamByName('custname').AsString := ACustName;
    FQry.Open;
    if not FQry.Eof then
    begin
      FCustId        := FQry.FieldByName('custid').AsInteger;
      FCustName      := Trim(FQry.FieldByName('custname').AsString);
      FCustAddress   := Trim(FQry.FieldByName('custaddress').AsString);
      FCustPostcode  := Trim(FQry.FieldByName('custpostcode').AsString);
      FCustTelephone := Trim(FQry.FieldByName('custtelephone').AsString);
      FCustEmail     := Trim(FQry.FieldByName('custemail').AsString);
      FCustContact   := Trim(FQry.FieldByName('custcontact').AsString);
      FLastChanged   := Trunc(FQry.FieldByName('lastchanged').AsDateTime); // or use RoundTo if needed
      FOriginalCustName := FCustName;
      FOriginalCustAddress := FCustAddress;
      FOriginalCustPostcode := FCustPostcode;
      FOriginalCustTelephone := FCustTelephone;
      FOriginalCustEmail := FCustEmail;
      FOriginalCustContact := FCustContact;
      FOriginalLastChanged := FLastChanged;
      Result := True;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TCustomerManager.InsertCustomer: boolean;
begin
  Result := false;
  if not IsCustomerNameUnique(CustName) then
  begin
    ShowWarning('Another customer already uses this name.');
    Exit;
  end;
  try
    try
      FQry.SQL.Text :=
        'INSERT INTO customers (custname, custaddress, custpostcode, custtelephone, custemail, custcontact, lastchanged) ' +
        'VALUES (:custname, :custaddress, :custpostcode, :custtelephone, :custemail, :custcontact, :lastchanged)';
      FQry.ParamByName('custname').AsString := FCustName;
      FQry.ParamByName('custaddress').AsString := FCustAddress;
      FQry.ParamByName('custpostcode').AsString := FCustPostcode;
      FQry.ParamByName('custtelephone').AsString := FCustTelephone;
      FQry.ParamByName('custemail').AsString := FCustEmail;
      FQry.ParamByName('custcontact').AsString := FCustContact;
      FQry.ParamByName('lastchanged').AsDateTime := FLastChanged;
      FQry.ExecSQL;
      if FQry.RowsAffected > 0 then
        Result := true;
    except
      on E: exception do
      begin
        ShowWarning('Unexpected Error when adding customer record'+ sLineBreak+ E.Message);
      end;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TCustomerManager.QuickInsertCustomer(const ACustname: string): boolean;
begin
  Result := false;
  try
    FQry.SQL.Text := 'INSERT INTO customers (custname, lastchanged) VALUES (:custname, :lastchanged);';
    FQry.ParamByName('custname').AsString := ACustname;
    FQry.ParamByName('lastchanged').AsDateTime := Now;
    FQry.ExecSQL;
    Result := FQry.RowsAffected > 0;
  except
    on E: exception do
    begin
      ShowWarning('Unexpected Error when adding customer record'+ sLineBreak+ E.Message);
    end;
  end;
  FQry.SQL.Clear;
end;

function TCustomerManager.UpdateCustomer: boolean;
begin
  Result := false;
  if not Customer.HasChanges then
    begin
      ShowInfo('No changes detected. Update skipped.');
      Exit;
    end;
  if not IsCustomerNameUnique(CustName, CustID) then
  begin
    ShowWarning('Another customer already uses this name.');
    Exit;
  end;
  try
    try
      FQry.SQL.Text :=
        'UPDATE customers SET custname = :custname, custaddress = :custaddress, custpostcode = :custpostcode, ' +
        'custtelephone = :custtelephone, custemail = :custemail, custcontact = :custcontact, lastchanged = :lastchanged ' +
        'WHERE custid = :custid';
      FQry.ParamByName('custid').AsInteger := FCustID;
      FQry.ParamByName('custname').AsString := FCustName;
      FQry.ParamByName('custaddress').AsString := FCustAddress;
      FQry.ParamByName('custpostcode').AsString := FCustPostcode;
      FQry.ParamByName('custtelephone').AsString := FCustTelephone;
      FQry.ParamByName('custemail').AsString := FCustEmail;
      FQry.ParamByName('custcontact').AsString := FCustContact;
      FQry.ParamByName('lastchanged').AsDateTime := FLastChanged;
      FQry.ExecSQL;
      if FQry.RowsAffected > 0 then
        Result := true;
    except
      on E: exception do
      begin
        ShowWarning('Unexpected Error when updating customer record'+ sLineBreak+ E.Message);
      end;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TCustomerManager.DeleteCustomer(const ACustID: Integer = -1): boolean;
begin
  Result := false;
  try
    try
      FQry.SQL.Text := 'DELETE FROM customers WHERE custid = :custid';
      FQry.ParamByName('custid').AsInteger := ACustID;
      FQry.ExecSQL;
      if FQry.RowsAffected < 1 then
        exit;
      Result := true;
    except
      on E: exception do
      begin
        ShowWarning('Unexpected Error when deleting customer record'+ sLineBreak+ E.Message);
      end;
    end;
  finally
    FQry.close;
    FQry.SQL.Text := '';
  end;
end;

function TCustomerManager.HasChanges: Boolean;
begin
  Result :=
    (FCustName <> FOriginalCustName) or
    (FCustAddress <> FOriginalCustAddress) or
    (FCustPostcode <> FOriginalCustPostcode) or
    (FCustTelephone <> FOriginalCustTelephone) or
    (FCustEmail <> FOriginalCustEmail) or
    (FCustContact <> FOriginalCustContact);
end;

function TCustomerManager.IsCustomerNameUnique(const ACustName: string; const ACustID: Integer): Boolean;
begin
  try
    if ACustID > 0 then
    begin
      // Exclude current record when checking for duplicates
      FQry.SQL.Text := 'SELECT COUNT(*) FROM customers WHERE LOWER(custname) = :custname AND custid <> :custid';
      FQry.ParamByName('custid').AsInteger := ACustID;
    end
    else
    begin
      // For inserts, just check for any match
      FQry.SQL.Text := 'SELECT COUNT(*) FROM customers WHERE LOWER(custname) = :custname';
    end;
    FQry.ParamByName('custname').AsString := LowerCase(Trim(ACustName));
    FQry.Open;
    Result := FQry.Fields[0].AsInteger = 0;
  finally
    FQry.Close;
    FQry.SQL.Text := '';
  end;
end;

end.
