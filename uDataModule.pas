unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.FMXUI.Error,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    FDlocal: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDGUIxErrorDialog1: TFDGUIxErrorDialog;
    FDQuery1: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  DB_NAME: string = 'WorksheetV1.sdb';
  SQL_CUSTOMERS: string =
    '''
      CREATE TABLE "customers" (
      "custid"	INTEGER NOT NULL UNIQUE,
      "custname"	TEXT NOT NULL UNIQUE,
      "custaddress"	TEXT,
      "custpostcode"	TEXT,
      "custtelephone"	TEXT,
      "custemail"	TEXT,
      "custcontact"	TEXT,
      "lastchanged"	DATETIME NOT NULL,
      PRIMARY KEY("custid" AUTOINCREMENT));
    ''';
  SQL_CUSTOMER_DATA: string =
    '''
         INSERT INTO customers (custname, custaddress, custpostcode, custtelephone, custemail, custcontact, lastchanged) VALUES
    ('Oakridge Solutions Ltd', '12 Elm Street, Manchester', 'M1 2AB', '0161 555 1234', 'info@oakridge.co.uk', 'Sarah Bennett', '2025-10-19 10:15:00'),
    ('Brightwave Media', '45 King''s Road, Brighton', 'BN1 3XY', '01273 555 6789', 'hello@brightwave.co.uk', 'James Carter', '2025-10-19 10:16:00'),
    ('Nimbus Technologies', '88 Cloud Lane, Leeds', 'LS2 8PL', '0113 555 2468', 'support@nimbus-tech.co.uk', 'Emily Watson', '2025-10-19 10:17:00'),
    ('Greenfield Logistics', 'Unit 4, Parkside Industrial Estate, Bristol', 'BS5 9TR', '0117 555 3344', 'contact@greenfieldlogistics.co.uk', 'Tom Harris', '2025-10-19 10:18:00'),
    ('Redfern & Co', '3 Market Street, York', 'YO1 7ND', '01904 555 7788', 'admin@redfernco.co.uk', 'Rachel Moore', '2025-10-19 10:19:00'),
    ('Bluebell Interiors', '27 High Street, Bath', 'BA1 1AB', '01225 555 1122', 'design@bluebellinteriors.co.uk', 'Laura Green', '2025-10-19 10:20:00'),
    ('Forge Digital', 'Studio 9, TechHub, Birmingham', 'B1 1AA', '0121 555 9988', 'team@forgedigital.co.uk', 'Daniel Price', '2025-10-19 10:21:00'),
    ('Hawthorn Engineering', 'Unit 12, Mill Lane, Sheffield', 'S1 4GH', '0114 555 6677', 'info@hawthorneng.co.uk', 'Oliver Scott', '2025-10-19 10:22:00'),
    ('Silverline Finance', 'Suite 5, 100 Queen Street, Glasgow', 'G1 3DN', '0141 555 2233', 'enquiries@silverlinefinance.co.uk', 'Sophie Adams', '2025-10-19 10:23:00'),
    ('Maple Grove Estates', '2 The Crescent, Nottingham', 'NG1 5LP', '0115 555 3344', 'sales@maplegrove.co.uk', 'George White', '2025-10-19 10:24:00'),
    ('Crimson Pixel Ltd', 'Flat 3, 18 Camden Road, London', 'NW1 9LP', '020 7946 1234', 'studio@crimsonpixel.co.uk', 'Amelia Clarke', '2025-10-19 10:25:00'),
    ('Beacon Analytics', 'Suite 10, Innovation Park, Edinburgh', 'EH3 9AB', '0131 555 7788', 'data@beaconanalytics.co.uk', 'Liam Turner', '2025-10-19 10:26:00'),
    ('Willow HR Services', 'Office 2, 5 Station Road, Reading', 'RG1 1AA', '0118 555 8899', 'hr@willowservices.co.uk', 'Grace Mitchell', '2025-10-19 10:27:00'),
    ('Ironclad Security Ltd', 'Unit 7, Forge Business Park, Newcastle', 'NE1 4ST', '0191 555 1122', 'secure@ironclad.co.uk', 'Nathan Brooks', '2025-10-19 10:28:00'),
    ('Aurora Events', 'The Loft, 22 Market Place, Oxford', 'OX1 3DU', '01865 555 6677', 'events@aurora.co.uk', 'Chloe Davies', '2025-10-19 10:29:00'),
    ('Cedar IT Solutions', '1 Tech Row, Cambridge', 'CB1 2XY', '01223 555 7788', 'support@cedarit.co.uk', 'Ben Foster', '2025-10-19 10:30:00'),
    ('Harbour Legal Group', 'Suite 3, Anchor House, Plymouth', 'PL1 2AB', '01752 555 3344', 'legal@harbourgroup.co.uk', 'Isla Morgan', '2025-10-19 10:31:00'),
    ('Falcon Creative', 'Studio 6, Design Quarter, Liverpool', 'L1 4AA', '0151 555 2233', 'hello@falconcreative.co.uk', 'Ethan Hall', '2025-10-19 10:32:00'),
    ('Elm Tree Publishing', '12 Book Lane, Durham', 'DH1 3EF', '0191 555 4455', 'info@elmtreepub.co.uk', 'Lily James', '2025-10-19 10:33:00'),
    ('Northbridge Consulting', 'Floor 4, 200 Deansgate, Manchester', 'M3 3NW', '0161 555 6677', 'contact@northbridge.co.uk', 'Jack Evans', '2025-10-19 10:34:00'),
    ('Amberlight Studios', 'Flat 2, 14 Queen''s Parade, Harrogate', 'HG1 5AG', '01423 555 7788', 'studio@amberlight.co.uk', 'Freya Robinson', '2025-10-19 10:35:00'),
    ('Thistle & Co Accountants', 'Suite 8, 33 Princes Street, Edinburgh', 'EH2 2BY', '0131 555 8899', 'accounts@thistleco.co.uk', 'Harry Walker', '2025-10-19 10:36:00'),
    ('Riverbank Architects', '21 Riverside Walk, York', 'YO10 4AB', '01904 555 2233', 'design@riverbankarch.co.uk', 'Ella Hughes', '2025-10-19 10:37:00'),
    ('Copperfield Marketing', 'Office 11, Media House, Leeds', 'LS1 2HT', '0113 555 3344', 'team@copperfield.co.uk', 'Oscar Reed', '2025-10-19 10:38:00'),
    ('Ashwood Garden Design', 'The Barn, Green Lane, Cheltenham', 'GL50 1AB', '01242 555 7788', 'info@ashwoodgardens.co.uk', 'Mia Palmer', '2025-10-19 10:39:00'),
    ('Violet Ventures', 'Unit 3, Innovation Centre, Milton Keynes', 'MK9 3PL', '01908 555 1122', 'hello@violetventures.co.uk', 'Leo Chapman', '2025-10-19 10:40:00'),
    ('Stonegate Builders', 'Plot 5, Quarry Road, Sheffield', 'S10 2AB', '0114 555 9988', 'build@stonegate.co.uk', 'Charlotte Webb', '2025-10-19 10:41:00'),
    ('Meadowlane Foods', 'Warehouse 9, Farm Park, Leicester', 'LE1 4GH', '0116 555 3344', 'orders@meadowlanefoods.co.uk', 'Jacob Knight', '2025-10-19 10:42:00'),
    ('Pinecone Software', 'Suite 2, CodeWorks, Bristol', 'BS1 5AA', '0117 555 2233', 'dev@pineconesoft.co.uk', 'Evie Russell', '2025-10-19 10:43:00'),
    ('Wrenhill Textiles', 'Mill House, Loom Street, Bradford', 'BD1 3AA', '01274 555 6677', 'sales@wrenhill.co.uk', 'Archie Bennett', '2025-10-19 10:44:00');
    ''';
var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  homeFolder, dbfile: string;
begin
  // Setup connection information depending on platform (e.g. android, windows)

  homeFolder := TPath.GetHomePath;
  {$IF DEFINED(MSWINDOWS)}
    homeFolder := TPath.Combine(homeFolder, 'WorkSheets');
    if not DirectoryExists(homeFolder) then
      CreateDir(homeFolder);
  {$ENDIF}
  dbfile := TPath.Combine(homeFolder, DB_NAME);
  FDlocal.Params.Database := dbfile;
  if not FilEexists(dbfile) then
  begin
    // If it doesn't exist, we will create the database using our database definition constants
    FDlocal.Open;
    FDLocal.ExecSQL(SQL_CUSTOMERS);
    FDLocal.Close;
  end;

end;

end.
