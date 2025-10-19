unit uCustomerClass;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TCustomer = class
  public
    CustID: Integer;
    CustName: string;
    CustAddress: string;
    CustPostcode: string;
    CustTelephone: string;
    CustEmail: string;
    CustContact: string;
    LastChanged: TDateTime;
  end;

  TCustomerManager = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    function GetCustomerByID(ACustID: Integer): TCustomer;
    function GetAllCustomers: TList<TCustomer>;
    procedure InsertCustomer(Customer: TCustomer);
    procedure UpdateCustomer(Customer: TCustomer);
    procedure DeleteCustomer(Customer: TCustomer);
  end;

implementation

{ TCustomerManager }

constructor TCustomerManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TCustomerManager.GetCustomerByID(ACustID: Integer): TCustomer;
var
  qry: TFDQuery;
begin
  Result := nil;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConnection;
    qry.SQL.Text := 'SELECT * FROM customers WHERE custid = :custid';
    qry.ParamByName('custid').AsInteger := ACustID;
    qry.Open;
    if not qry.Eof then
    begin
      Result := TCustomer.Create;
      Result.CustID := qry.FieldByName('custid').AsInteger;
      Result.CustName := qry.FieldByName('custname').AsString;
      Result.CustAddress := qry.FieldByName('custaddress').AsString;
      Result.CustPostcode := qry.FieldByName('custpostcode').AsString;
      Result.CustTelephone := qry.FieldByName('custtelephone').AsString;
      Result.CustEmail := qry.FieldByName('custemail').AsString;
      Result.CustContact := qry.FieldByName('custcontact').AsString;
      Result.LastChanged := qry.FieldByName('lastchanged').AsDateTime;
    end;
  finally
    qry.Free;
  end;
end;

function TCustomerManager.GetAllCustomers: TList<TCustomer>;
var
  qry: TFDQuery;
  customer: TCustomer;
begin
  Result := TList<TCustomer>.Create;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConnection;
    qry.SQL.Text := 'SELECT * FROM customers ORDER BY custname';
    qry.Open;
    while not qry.Eof do
    begin
      customer := TCustomer.Create;
      customer.CustID := qry.FieldByName('custid').AsInteger;
      customer.CustName := qry.FieldByName('custname').AsString;
      customer.CustAddress := qry.FieldByName('custaddress').AsString;
      customer.CustPostcode := qry.FieldByName('custpostcode').AsString;
      customer.CustTelephone := qry.FieldByName('custtelephone').AsString;
      customer.CustEmail := qry.FieldByName('custemail').AsString;
      customer.CustContact := qry.FieldByName('custcontact').AsString;
      customer.LastChanged := qry.FieldByName('lastchanged').AsDateTime;
      Result.Add(customer);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TCustomerManager.InsertCustomer(Customer: TCustomer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConnection;
    qry.SQL.Text :=
      'INSERT INTO customers (custname, custaddress, custpostcode, custtelephone, custemail, custcontact, lastchanged) ' +
      'VALUES (:custname, :custaddress, :custpostcode, :custtelephone, :custemail, :custcontact, :lastchanged)';
    qry.ParamByName('custname').AsString := Customer.CustName;
    qry.ParamByName('custaddress').AsString := Customer.CustAddress;
    qry.ParamByName('custpostcode').AsString := Customer.CustPostcode;
    qry.ParamByName('custtelephone').AsString := Customer.CustTelephone;
    qry.ParamByName('custemail').AsString := Customer.CustEmail;
    qry.ParamByName('custcontact').AsString := Customer.CustContact;
    qry.ParamByName('lastchanged').AsDateTime := Customer.LastChanged;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TCustomerManager.UpdateCustomer(Customer: TCustomer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConnection;
    qry.SQL.Text :=
      'UPDATE customers SET custname = :custname, custaddress = :custaddress, custpostcode = :custpostcode, ' +
      'custtelephone = :custtelephone, custemail = :custemail, custcontact = :custcontact, lastchanged = :lastchanged ' +
      'WHERE custid = :custid';
    qry.ParamByName('custid').AsInteger := Customer.CustID;
    qry.ParamByName('custname').AsString := Customer.CustName;
    qry.ParamByName('custaddress').AsString := Customer.CustAddress;
    qry.ParamByName('custpostcode').AsString := Customer.CustPostcode;
    qry.ParamByName('custtelephone').AsString := Customer.CustTelephone;
    qry.ParamByName('custemail').AsString := Customer.CustEmail;
    qry.ParamByName('custcontact').AsString := Customer.CustContact;
    qry.ParamByName('lastchanged').AsDateTime := Customer.LastChanged;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TCustomerManager.DeleteCustomer(Customer: TCustomer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConnection;
    qry.SQL.Text := 'DELETE FROM customers WHERE custid = :custid';
    qry.ParamByName('custid').AsInteger := Customer.CustID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

end.
