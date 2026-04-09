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
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FMX.Types, FMX.Controls
  {$IFDEF ANDROID}
  , MobilePermissions.Model.Signature
  , MobilePermissions.Model.Dangerous
  , MobilePermissions.Model.Standard
  , MobilePermissions.Component
  {$ENDIF}
  ;

type
  TDM = class(TDataModule)
    FDlocal: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDGUIxErrorDialog1: TFDGUIxErrorDialog;
    FDQuery1: TFDQuery;
    StyleBook1: TStyleBook;
    StyleBook2: TStyleBook;
    qryExpenses: TFDQuery;
    qrySpares: TFDQuery;
    qryTime: TFDQuery;
    qryInsertSpare: TFDQuery;
    qryListCust: TFDQuery;
    {$IFDEF ANDROID}
    MobilePermissions1: TMobilePermissions;
    {$ENDIF}
    qryPDF: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDlocalAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateDB();

  end;

const
  SQL_CUSTOMERS: string =
    '''
      CREATE TABLE headerdetails (
          id INTEGER PRIMARY KEY CHECK (id = 1),
          headername TEXT NOT NULL,
          headertelephone TEXT,
          headeremail TEXT
        );
      INSERT INTO headerdetails
       (id, headername, headertelephone, headeremail)
       VALUES
       (1, 'Worksheet Manager', '0800 03482132', 'worksheetmanager@worksheet.com');

      CREATE TABLE customers (
        custid INTEGER PRIMARY KEY AUTOINCREMENT,
        custname TEXT NOT NULL UNIQUE,
        custaddress TEXT,
        custpostcode TEXT,
        custtelephone TEXT,
        custemail TEXT,
        custcontact TEXT,
        lastchanged DATETIME NOT NULL
      );
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
    const
      SQL_JOBSMASTER: string =
       '''
          CREATE TABLE jobs_master (
            jobno INTEGER PRIMARY KEY AUTOINCREMENT,
            jobtype TEXT,
            jobdate DATE,
            custname TEXT,
            address TEXT,
            postcode TEXT,
            email TEXT,
            telephone TEXT,
            callno TEXT,
            contractno TEXT,
            reason TEXT,
            workdone TEXT,
            remedial TEXT,
            referredto TEXT,
            engineername1 TEXT,
            engineername2 TEXT,
            signedby TEXT,
            signaturepathdata TEXT,
            lastchanged DATETIME
          );

          CREATE TABLE jobs_expenses (
           exid INTEGER PRIMARY KEY AUTOINCREMENT,
           jobno INTEGER NOT NULL,
           exdate DATE NOT NULL,
           exdetails TEXT NOT NULL,
           excost REAL NOT NULL,
           lastchanged DATETIME NOT NULL,
           FOREIGN KEY(jobno) REFERENCES jobs_master (jobno) on delete cascade
          );

        CREATE TABLE jobs_photos (
         jobno INTEGER NOT NULL,
         photono INTEGER NOT NULL,
         photo BLOB,
         lastchanged DATETIME,
         PRIMARY KEY(jobno, photono),
         FOREIGN KEY(jobno) REFERENCES jobs_master (jobno) on delete cascade
        );

        CREATE TABLE jobs_spareparts (
         spid INTEGER PRIMARY KEY AUTOINCREMENT,
         jobno INTEGER NOT NULL,
         partdetails TEXT NOT NULL,
         qtyused INTEGER NOT NULL,
         lastchanged DATETIME NOT NULL,
         FOREIGN KEY(jobno) REFERENCES jobs_master (jobno) on delete cascade
        );

        CREATE TABLE jobs_timerecords (
         trid INTEGER PRIMARY KEY AUTOINCREMENT,
         jobno INTEGER NOT NULL,
         logdate DATE,
         traveltime TIME,
         timearrived TIME,
         timedeparted TIME,
         timetotal TIME,
         jobtimeseconds INTEGER,
         traveltimeseconds INTEGER,
         totaltimeseconds INTEGER,
         mileage INTEGER,
         lastchanged DATETIME,
         FOREIGN KEY(jobno) REFERENCES jobs_master (jobno) on delete cascade
        );

        INSERT INTO jobs_master
        (jobtype, jobdate, custname, address, postcode, email, telephone, callno, contractno, reason, workdone, remedial, referredto, engineername1, engineername2, signedby, signaturepathdata, lastchanged)
        VALUES
        ('MAINTENANCE',  45931.0, 'Oakridge Solutions Ltd',  '12 Elm Street, Manchester',                   'M1 2AB',  'info@oakridge.co.uk',               '0161 555 1234',  'C001', 'CN1001', 'Annual service',                     'Boiler serviced and tested',                          'None',                          'N/A',      'James Carter',  'Sarah Bennett',  'Sarah Bennett', '', 45931.395833),
        ('BREAKDOWN',    45932.0, 'Brightwave Media',        '45 King''s Road, Brighton',                   'BN1 3XY', 'hello@brightwave.co.uk',            '01273 555 6789', 'C002', 'CN1002', 'Power outage',                       'Replaced fuse board',                                 'Check wiring in 6 months',      'N/A',      'Emily Watson',  'Tom Harris',     'James Carter',  '', 45932.59375),
        ('BREAKDOWN',    45933.0, 'Nimbus Technologies',     '88 Cloud Lane, Leeds',                        'LS2 8PL', 'support@nimbus-tech.co.uk',         '0113 555 2468',  'C003', 'CN1003', 'Leak reported',                      'Pipe replaced under sink',                            'Monitor for leaks',             'N/A',      'Oliver Scott',  'Rachel Moore',   '',              '', 45933.489583),
        ('OTHER',        45934.0, 'Greenfield Logistics',    'Unit 4, Parkside Industrial Estate, Bristol', 'BS5 9TR', 'contact@greenfieldlogistics.co.uk', '0117 555 3344',  'C004', 'CN1004', 'Annual compliance check',            'Tested 50 portable appliances, all passed',           'None',                          'N/A',      'Laura Green',   'Daniel Price',   '',              '', 45934.416667),
        ('OTHER',        45935.0, 'Redfern & Co',            '3 Market Street, York',                       'YO1 7ND', 'admin@redfernco.co.uk',             '01904 555 7788', 'C005', 'CN1005', 'Quarterly functional test',          '3-hour drain test completed on all emergency fittings','One failed battery pack replaced','N/A',      'Oliver Scott',  'Sophie Adams',   '',              '', 45935.645833),
        ('BREAKDOWN',    45936.0, 'Bluebell Interiors',      '27 High Street, Bath',                        'BA1 1AB', 'design@bluebellinteriors.co.uk',    '01225 555 1122', 'C006', 'CN1006', 'Blocked drain in staff kitchen',     'High-pressure jetting to clear blockage',             'None',                          'N/A',      'George White',  'Amelia Clarke',  '',              '', 45936.458333),
        ('BREAKDOWN',    45937.0, 'Forge Digital',           'Studio 9, TechHub, Birmingham',               'B1 1AA',  'team@forgedigital.co.uk',           '0121 555 9988',  'C007', 'CN1007', 'Intermittent network connection',    'Re-terminated faulty network port at desk 4',         'None',                          'N/A',      'Liam Turner',   'Grace Mitchell', '',              '', 45937.40625),
        ('MAINTENANCE',  45938.0, 'Hawthorn Engineering',    'Unit 12, Mill Lane, Sheffield',               'S1 4GH',  'info@hawthorneng.co.uk',            '0114 555 6677',  'C008', 'CN1008', 'Annual maintenance',                 'Cleaned filters and checked refrigerant levels',      'None',                          'N/A',      'Nathan Brooks', 'Chloe Davies',   '',              '', 45938.583333),
        ('BREAKDOWN',    45939.0, 'Silverline Finance',      'Suite 5, 100 Queen Street, Glasgow',          'G1 3DN',  'enquiries@silverlinefinance.co.uk', '0141 555 2233',  'C009', 'CN1009', 'Cracked socket faceplate',           'Replaced double socket with new unit',                'None',                          'N/A',      'Ben Foster',    'Isla Morgan',    '',              '', 45939.510417),
        ('MAINTENANCE',  45940.0, 'Maple Grove Estates',     '2 The Crescent, Nottingham',                  'NG1 5LP', 'sales@maplegrove.co.uk',            '0115 555 3344',  'C010', 'CN1010', 'Weekly test',                        'Tested call points and panel functions',               'None',                          'N/A',      'Ethan Hall',    'Lily James',     '',              '', 45940.375),
        ('BREAKDOWN',    45941.0, 'Crimson Pixel Ltd',       'Flat 3, 18 Camden Road, London',              'NW1 9LP', 'studio@crimsonpixel.co.uk',         '020 7946 1234',  'C011', 'CN1011', 'No heating or hot water',            'Replaced faulty pump and bled system',                'Advised system flush',          'Plumbing', 'Jack Evans',    'Freya Robinson', '',              '', 45941.6875),
        ('INSTALLATION', 45942.0, 'Beacon Analytics',        'Suite 10, Innovation Park, Edinburgh',        'EH3 9AB', 'data@beaconanalytics.co.uk',        '0131 555 7788',  'C012', 'CN1012', 'New external lighting',              'Installed 2x LED floodlights with PIR sensor',        'None',                          'N/A',      'Harry Walker',  'Ella Hughes',    '',              '', 45942.541667),
        ('BREAKDOWN',    45943.0, 'Willow HR Services',      'Office 2, 5 Station Road, Reading',           'RG1 1AA', 'hr@willowservices.co.uk',           '0118 555 8899',  'C013', 'CN1013', 'Main breaker trips intermittently',  'Identified and replaced faulty circuit breaker (MCB)','None',                          'N/A',      'Oscar Reed',    'Mia Palmer',     '',              '', 45943.489583),
        ('OTHER',        45944.0, 'Ironclad Security Ltd',   'Unit 7, Forge Business Park, Newcastle',      'NE1 4ST', 'secure@ironclad.co.uk',             '0191 555 1122',  'C014', 'CN1014', 'Camera view obstructed',             'Repositioned camera 3 and cleaned lens',              'None',                          'N/A',      'Leo Chapman',   'Charlotte Webb', '',              '', 45944.430556),
        ('BREAKDOWN',    45945.0, 'Aurora Events',           'The Loft, 22 Market Place, Oxford',           'OX1 3DU', 'events@aurora.co.uk',               '01865 555 6677', 'C015', 'CN1015', 'No hot water in kitchenette',        'Replaced failed heating element in water heater',     'None',                          'N/A',      'Jacob Knight',  'Evie Russell',   '',              '', 45945.5);

        INSERT INTO jobs_expenses (exid, jobno, exdate, exdetails, excost, lastchanged) VALUES
        (1,  1,  45931.0, 'Replacement fuse',         45.00, 45931.40625),
        (2,  2,  45932.0, 'Travel costs',             20.00, 45932.604167),
        (3,  3,  45933.0, 'Pipe sealant',             12.50, 45933.5),
        (4,  4,  45934.0, 'PAT Testing Labels Roll',  15.50, 45934.4375),
        (5,  5,  45935.0, 'Sunday Parking Surcharge',  8.50, 45935.666667),
        (6,  6,  45936.0, 'Drain Clearing Fluid',     18.99, 45936.479167),
        (7,  7,  45937.0, 'City Centre Parking',      22.00, 45937.427083),
        (8,  8,  45938.0, 'Cleaning Solvents',        12.75, 45938.604167),
        (9,  9,  45939.0, 'Parking Meter',             6.40, 45939.53125),
        (10, 10, 45940.0, 'Travel Mileage (Zone B)',  14.20, 45940.395833),
        (11, 11, 45941.0, 'Congestion Charge',        15.00, 45941.708333),
        (12, 12, 45942.0, 'Exterior Sealant',          9.95, 45942.5625),
        (13, 13, 45943.0, 'Small Parts Consumables',   5.00, 45943.5),
        (14, 14, 45944.0, 'Secure Parking',           11.50, 45944.447917),
        (15, 15, 45945.0, 'Pipe Joint Compound',       8.25, 45945.520833);

        INSERT INTO jobs_spareparts (spid, jobno, partdetails, qtyused, lastchanged) VALUES
        (1,  1,  'Fuse 13A',                            2,  45931.409722),
        (2,  2,  'Circuit breaker unit',                1,  45932.611111),
        (3,  3,  'Copper pipe 15mm',                    2,  45933.506944),
        (4,  4,  '13A Plug Fuses',                      12, 45934.440972),
        (5,  5,  'Emergency Battery Pack 4.8V',         1,  45935.673611),
        (6,  6,  '40mm Waste Pipe Coupling',            1,  45936.486111),
        (7,  7,  'CAT6 RJ45 Module',                    1,  45937.430556),
        (8,  8,  'AC Air Filter 20x20',                 2,  45938.611111),
        (9,  9,  'Double Socket Faceplate (White)',      1,  45939.534722),
        (10, 10, 'Call Point Test Key',                 1,  45940.399306),
        (11, 11, 'Grundfos 15-50 Central Heating Pump', 1,  45941.715278),
        (12, 12, '30W LED Floodlight IP65',             2,  45942.569444),
        (13, 13, '32A MCB Type B',                      1,  45943.506944),
        (14, 14, 'Lens Cleaning Cloth (Microfibre)',    1,  45944.451389),
        (15, 15, 'Immersion Heater Element 3kW',        1,  45945.527778);

        INSERT INTO jobs_timerecords (trid, jobno, logdate, traveltime, timearrived, timedeparted, timetotal, jobtimeseconds, traveltimeseconds, totaltimeseconds, mileage, lastchanged) VALUES
        (1,  1,  45931.0, 0.020833, 0.375,    0.416667, 0.041667, 3600,  1800, 5400,  12, 45931.420139),
        (2,  2,  45932.0, 0.03125,  0.5625,   0.625,    0.0625,   5400,  2700, 8100,  20, 45932.631944),
        (3,  3,  45933.0, 0.013889, 0.479167, 0.520833, 0.041667, 3600,  1200, 4800,  8,  45933.524306),
        (4,  4,  45934.0, 0.027778, 0.354167, 0.520833, 0.194444, 14400, 2400, 16800, 22, 45934.524306),
        (5,  5,  45935.0, 0.017361, 0.583333, 0.645833, 0.079861, 5400,  1500, 6900,  12, 45935.649306),
        (6,  6,  45936.0, 0.034722, 0.395833, 0.458333, 0.097222, 5400,  3000, 8400,  35, 45936.461806),
        (7,  7,  45937.0, 0.020833, 0.364583, 0.40625,  0.0625,   3600,  1800, 5400,  18, 45937.409722),
        (8,  8,  45938.0, 0.010417, 0.541667, 0.583333, 0.052083, 3600,  900,  4500,  8,  45938.586806),
        (9,  9,  45939.0, 0.03125,  0.479167, 0.510417, 0.0625,   2700,  2700, 5400,  28, 45939.513889),
        (10, 10, 45940.0, 0.013889, 0.354167, 0.375,    0.034722, 1800,  1200, 3000,  10, 45940.378472),
        (11, 11, 45941.0, 0.048611, 0.625,    0.6875,   0.111111, 5400,  4200, 9600,  45, 45941.690972),
        (12, 12, 45942.0, 0.024306, 0.458333, 0.541667, 0.107639, 7200,  2100, 9300,  20, 45942.545139),
        (13, 13, 45943.0, 0.038194, 0.427083, 0.489583, 0.100694, 5400,  3300, 8700,  32, 45943.493056),
        (14, 14, 45944.0, 0.017361, 0.395833, 0.430556, 0.052083, 3000,  1500, 4500,  14, 45944.434028),
        (15, 15, 45945.0, 0.027778, 0.458333, 0.5,      0.069444, 3600,  2400, 6000,  25, 45945.503472);
   ''';

   const svgdelete: string =
   '<?xml version="1.0" encoding="utf-8"?>' +
    '<svg width="800px" height="800px" viewBox="0 0 1024 1024" class="icon"  version="1.1" xmlns="http://www.w3.org/2000/svg"><path d="M779.5 1002.7h-535c-64.3 0-116.5-52.3-116.5-116.5V170.7h768v715.5c0 64.2-52.3 116.5-116.5 116.5zM213.3 256v630.1c0 17.2 14 31.2 31.2 31.2h534.9c17.2 0 31.2-14 31.2-31.2V256H213.3z" fill="#3688FF" /><path d="M917.3 256H106.7C83.1 256 64 236.9 64 213.3s19.1-42.7 42.7-42.7h810.7c23.6 0 42.7 19.1 42.7 42.7S940.9 256 917.3 256zM618.7 128H405.3c-23.6 0-42.7-19.1-42.7-42.7s19.1-42.7 42.7-42.7h213.3c23.6 0 42.7 19.1 42.7 42.7S642.2 128 618.7 128zM405.3 725.3c-23.6 0-42.7-19.1-42.7-42.7v-256c0-23.6 19.1-42.7 42.7-42.7S448 403 448 426.6v256c0 23.6-19.1 42.7-42.7 42.7zM618.7 725.3c-23.6 0-42.7-19.1-42.7-42.7v-256c0-23.6 19.1-42.7 42.7-42.7s42.7 19.1 42.7 42.7v256c-0.1 23.6-19.2 42.7-42.7 42.7z" fill="#5F6379" /></svg>';
var
  DM: TDM;
  DBName: string;
  SAVE_PATH: string;

procedure RequestPermissions;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  // Setup connection information depending on platform (e.g. android, windows)
  {$IF DEFINED(Android)}
    SAVE_PATH := TPath.GetHomePath;
    DBName := TPath.Combine(TPath.GetHomePath, 'WorksheetV1.sdb');
  {$ELSEIF DEFINED(MSWINDOWS)}
    SAVE_PATH := TPath.Combine(TPath.GetHomePath, 'WorkSheets');
    if not DirectoryExists(SAVE_PATH) then
      CreateDir(SAVE_PATH);
    DBName := TPath.Combine(SAVE_PATH, 'WorksheetV1.sdb');
  {$ENDIF}

  FDlocal.Params.Database := DBName;

  // If not found, we create the database
  if not FileExists(DBName) then
    CreateDB();
end;

procedure TDM.FDlocalAfterConnect(Sender: TObject);
begin
  FDLocal.ExecSQL('PRAGMA foreignkeys = ON');
end;

procedure TDM.CreateDB();
begin
  FDlocal.Open; // Database is defined as Createon open...
  FDLocal.ExecSQL(SQL_CUSTOMERS);
  FDLocal.ExecSQL(SQL_JOBSMASTER);
  FDLocal.Close;
end;

procedure RequestPermissions;
{$IFDEF ANDROID}
var
  LPermissions: TMobilePermissions;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  LPermissions := TMobilePermissions.Create(nil);
  try
    LPermissions.Dangerous.Camera := True;
    LPermissions.Dangerous.WriteExternalStorage := True;
    LPermissions.Dangerous.ReadExternalStorage := True;
    LPermissions.Apply;
  finally
    LPermissions.Free;
  end;
  {$ENDIF}
end;


end.
