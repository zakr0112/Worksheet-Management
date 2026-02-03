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
  FMX.Types, FMX.Controls, MobilePermissions.Model.Signature,
  MobilePermissions.Model.Dangerous, MobilePermissions.Model.Standard,
  MobilePermissions.Component;

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
    MobilePermissions1: TMobilePermissions;
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

        CREATE TABLE jobs_signatures (
         jobno INTEGER NOT NULL UNIQUE,
         signedby TEXT,
         signedat DATETIME,
         signaturepathdata TEXT,
         signaturepng BLOB,
         signaturesvg TEXT,
         lastchanged DATETIME,
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
        ('MAINTENANCE', '2025-10-01', 'Oakridge Solutions Ltd', '12 Elm Street, Manchester', 'M1 2AB', 'info@oakridge.co.uk', '0161 555 1234', 'C001', 'CN1001', 'Annual service', 'Boiler serviced and tested', 'None', 'N/A', 'James Carter', 'Sarah Bennett', 'Sarah Bennett', '', '2025-10-01 09:30:00'),
        ('Electrical Repair', '2025-10-02', 'Brightwave Media', '45 King''s Road, Brighton', 'BN1 3XY', 'hello@brightwave.co.uk', '01273 555 6789', 'C002', 'CN1002', 'Power outage', 'Replaced fuse board', 'Check wiring in 6 months', 'N/A', 'Emily Watson', 'Tom Harris', 'James Carter', '', '2025-10-02 14:15:00'),
        ('Plumbing Callout', '2025-10-03', 'Nimbus Technologies', '88 Cloud Lane, Leeds', 'LS2 8PL', 'support@nimbus-tech.co.uk', '0113 555 2468', 'C003', 'CN1003', 'Leak reported', 'Pipe replaced under sink', 'Monitor for leaks', 'N/A', 'Oliver Scott', 'Rachel Moore', '', '', '2025-10-03 11:45:00'),
        ('PAT Testing', '2025-10-04', 'Greenfield Logistics', 'Unit 4, Parkside Industrial Estate, Bristol', 'BS5 9TR', 'contact@greenfieldlogistics.co.uk', '0117 555 3344', 'C004', 'CN1004', 'Annual compliance check', 'Tested 50 portable appliances, all passed', 'None', 'N/A', 'Laura Green', 'Daniel Price',  '', '', '2025-10-04 10:00:00'),
        ('Emergency Lighting Test', '2025-10-05', 'Redfern & Co', '3 Market Street, York', 'YO1 7ND', 'admin@redfernco.co.uk', '01904 555 7788', 'C005', 'CN1005', 'Quarterly functional test', '3-hour drain test completed on all emergency fittings', 'One failed battery pack replaced', 'N/A', 'Oliver Scott', 'Sophie Adams',  '', '', '2025-10-05 15:30:00'),
        ('Plumbing Repair', '2025-10-06', 'Bluebell Interiors', '27 High Street, Bath', 'BA1 1AB', 'design@bluebellinteriors.co.uk', '01225 555 1122', 'C006', 'CN1006', 'Blocked drain in staff kitchen', 'High-pressure jetting to clear blockage', 'None', 'N/A', 'George White', 'Amelia Clarke',  '', '', '2025-10-06 11:00:00'),
        ('Network Fault Finding', '2025-10-07', 'Forge Digital', 'Studio 9, TechHub, Birmingham', 'B1 1AA', 'team@forgedigital.co.uk', '0121 555 9988', 'C007', 'CN1007', 'Intermittent network connection', 'Re-terminated faulty network port at desk 4', 'None', 'N/A', 'Liam Turner', 'Grace Mitchell',  '', '', '2025-10-07 09:45:00'),
        ('AC Service', '2025-10-08', 'Hawthorn Engineering', 'Unit 12, Mill Lane, Sheffield', 'S1 4GH', 'info@hawthorneng.co.uk', '0114 555 6677', 'C008', 'CN1008', 'Annual maintenance', 'Cleaned filters and checked refrigerant levels', 'None', 'N/A', 'Nathan Brooks', 'Chloe Davies',  '', '', '2025-10-08 14:00:00'),
        ('Socket Replacement', '2025-10-09', 'Silverline Finance', 'Suite 5, 100 Queen Street, Glasgow', 'G1 3DN', 'enquiries@silverlinefinance.co.uk', '0141 555 2233', 'C009', 'CN1009', 'Cracked socket faceplate', 'Replaced double socket with new unit', 'None', 'N/A', 'Ben Foster', 'Isla Morgan',  '', '', '2025-10-09 12:15:00'),
        ('Fire Alarm Panel Check', '2025-10-10', 'Maple Grove Estates', '2 The Crescent, Nottingham', 'NG1 5LP', 'sales@maplegrove.co.uk', '0115 555 3344', 'C010', 'CN1010', 'Weekly test', 'Tested call points and panel functions', 'None', 'N/A', 'Ethan Hall', 'Lily James',  '', '', '2025-10-10 09:00:00'),
        ('Boiler Repair', '2025-10-11', 'Crimson Pixel Ltd', 'Flat 3, 18 Camden Road, London', 'NW1 9LP', 'studio@crimsonpixel.co.uk', '020 7946 1234', 'C011', 'CN1011', 'No heating or hot water', 'Replaced faulty pump and bled system', 'Advised system flush', 'Plumbing', 'Jack Evans', 'Freya Robinson',  '', '', '2025-10-11 16:30:00'),
        ('Electrical Installation', '2025-10-12', 'Beacon Analytics', 'Suite 10, Innovation Park, Edinburgh', 'EH3 9AB', 'data@beaconanalytics.co.uk', '0131 555 7788', 'C012', 'CN1012', 'New external lighting', 'Installed 2x LED floodlights with PIR sensor', 'None', 'N/A', 'Harry Walker', 'Ella Hughes',  '', '', '2025-10-12 13:00:00'),
        ('Fuse Box Tripping', '2025-10-13', 'Willow HR Services', 'Office 2, 5 Station Road, Reading', 'RG1 1AA', 'hr@willowservices.co.uk', '0118 555 8899', 'C013', 'CN1013', 'Main breaker trips intermittently', 'Identified and replaced faulty circuit breaker (MCB)', 'None', 'N/A', 'Oscar Reed', 'Mia Palmer',  '', '', '2025-10-13 11:45:00'),
        ('CCTV Camera Adjustment', '2025-10-14', 'Ironclad Security Ltd', 'Unit 7, Forge Business Park, Newcastle', 'NE1 4ST', 'secure@ironclad.co.uk', '0191 555 1122', 'C014', 'CN1014', 'Camera view obstructed', 'Repositioned camera 3 and cleaned lens', 'None', 'N/A', 'Leo Chapman', 'Charlotte Webb',  '', '', '2025-10-14 10:20:00'),
        ('Water Heater Repair', '2025-10-15', 'Aurora Events', 'The Loft, 22 Market Place, Oxford', 'OX1 3DU', 'events@aurora.co.uk', '01865 555 6677', 'C015', 'CN1015', 'No hot water in kitchenette', 'Replaced failed heating element in water heater', 'None', 'N/A', 'Jacob Knight', 'Evie Russell',  '', '', '2025-10-15 12:00:00');

        INSERT INTO jobs_expenses (exid, jobno, exdate, exdetails, excost, lastchanged)
        VALUES
        (1, 1, '2025-10-01', 'Replacement fuse', 45.00, '2025-10-01 09:45:00'),
        (2, 2, '2025-10-02', 'Travel costs', 20.00, '2025-10-02 14:30:00'),
        (3, 3, '2025-10-03', 'Pipe sealant', 12.50, '2025-10-03 12:00:00'),
        (4, 4, '2025-10-04', 'PAT Testing Labels Roll', 15.50, '2025-10-04 10:30:00'),
        (5, 5, '2025-10-05', 'Sunday Parking Surcharge', 8.50, '2025-10-05 16:00:00'),
        (6, 6, '2025-10-06', 'Drain Clearing Fluid', 18.99, '2025-10-06 11:30:00'),
        (7, 7, '2025-10-07', 'City Centre Parking', 22.00, '2025-10-07 10:15:00'),
        (8, 8, '2025-10-08', 'Cleaning Solvents', 12.75, '2025-10-08 14:30:00'),
        (9, 9, '2025-10-09', 'Parking Meter', 6.40, '2025-10-09 12:45:00'),
        (10, 10, '2025-10-10', 'Travel Mileage (Zone B)', 14.20, '2025-10-10 09:30:00'),
        (11, 11, '2025-10-11', 'Congestion Charge', 15.00, '2025-10-11 17:00:00'),
        (12, 12, '2025-10-12', 'Exterior Sealant', 9.95, '2025-10-12 13:30:00'),
        (13, 13, '2025-10-13', 'Small Parts Consumables', 5.00, '2025-10-13 12:00:00'),
        (14, 14, '2025-10-14', 'Secure Parking', 11.50, '2025-10-14 10:45:00'),
        (15, 15, '2025-10-15', 'Pipe Joint Compound', 8.25, '2025-10-15 12:30:00');

        INSERT INTO jobs_spareparts (spid, jobno, partdetails, qtyused, lastchanged)
        VALUES
        (1, 1, 'Fuse 13A', 2, '2025-10-01 09:50:00'),
        (2, 2, 'Circuit breaker unit', 1, '2025-10-02 14:40:00'),
        (3, 3, 'Copper pipe 15mm', 2, '2025-10-03 12:10:00'),
        (4, 4, '13A Plug Fuses', 12, '2025-10-04 10:35:00'),
        (5, 5, 'Emergency Battery Pack 4.8V', 1, '2025-10-05 16:10:00'),
        (6, 6, '40mm Waste Pipe Coupling', 1, '2025-10-06 11:40:00'),
        (7, 7, 'CAT6 RJ45 Module', 1, '2025-10-07 10:20:00'),
        (8, 8, 'AC Air Filter 20x20', 2, '2025-10-08 14:40:00'),
        (9, 9, 'Double Socket Faceplate (White)', 1, '2025-10-09 12:50:00'),
        (10, 10, 'Call Point Test Key', 1, '2025-10-10 09:35:00'),
        (11, 11, 'Grundfos 15-50 Central Heating Pump', 1, '2025-10-11 17:10:00'),
        (12, 12, '30W LED Floodlight IP65', 2, '2025-10-12 13:40:00'),
        (13, 13, '32A MCB Type B', 1, '2025-10-13 12:10:00'),
        (14, 14, 'Lens Cleaning Cloth (Microfibre)', 1, '2025-10-14 10:50:00'),
        (15, 15, 'Immersion Heater Element 3kW', 1, '2025-10-15 12:40:00');

        INSERT INTO jobs_timerecords (trid, jobno, logdate, traveltime, timearrived, timedeparted, timetotal, jobtimeseconds, traveltimeseconds, totaltimeseconds, mileage, lastchanged)
        VALUES
        (1, 1, '2025-10-01', '00:30:00', '09:00:00', '10:00:00', '01:00:00', 3600, 1800, 5400, 12, '2025-10-01 10:05:00'),
        (2, 2, '2025-10-02', '00:45:00', '13:30:00', '15:00:00', '01:30:00', 5400, 2700, 8100, 20, '2025-10-02 15:10:00'),
        (3, 3, '2025-10-03', '00:20:00', '11:30:00', '12:30:00', '01:00:00', 3600, 1200, 4800, 8, '2025-10-03 12:35:00'),
        (4, 4, '2025-10-04', '00:40:00', '08:30:00', '12:30:00', '04:40:00', 14400, 2400, 16800, 22, '2025-10-04 12:35:00'),
        (5, 5, '2025-10-05', '00:25:00', '14:00:00', '15:30:00', '01:55:00', 5400, 1500, 6900, 12, '2025-10-05 15:35:00'),
        (6, 6, '2025-10-06', '00:50:00', '09:30:00', '11:00:00', '02:20:00', 5400, 3000, 8400, 35, '2025-10-06 11:05:00'),
        (7, 7, '2025-10-07', '00:30:00', '08:45:00', '09:45:00', '01:30:00', 3600, 1800, 5400, 18, '2025-10-07 09:50:00'),
        (8, 8, '2025-10-08', '00:15:00', '13:00:00', '14:00:00', '01:15:00', 3600, 900, 4500, 8, '2025-10-08 14:05:00'),
        (9, 9, '2025-10-09', '00:45:00', '11:30:00', '12:15:00', '01:30:00', 2700, 2700, 5400, 28, '2025-10-09 12:20:00'),
        (10, 10, '2025-10-10', '00:20:00', '08:30:00', '09:00:00', '00:50:00', 1800, 1200, 3000, 10, '2025-10-10 09:05:00'),
        (11, 11, '2025-10-11', '01:10:00', '15:00:00', '16:30:00', '02:40:00', 5400, 4200, 9600, 45, '2025-10-11 16:35:00'),
        (12, 12, '2025-10-12', '00:35:00', '11:00:00', '13:00:00', '02:35:00', 7200, 2100, 9300, 20, '2025-10-12 13:05:00'),
        (13, 13, '2025-10-13', '00:55:00', '10:15:00', '11:45:00', '02:25:00', 5400, 3300, 8700, 32, '2025-10-13 11:50:00'),
        (14, 14, '2025-10-14', '00:25:00', '09:30:00', '10:20:00', '01:15:00', 3000, 1500, 4500, 14, '2025-10-14 10:25:00'),
        (15, 15, '2025-10-15', '00:40:00', '11:00:00', '12:00:00', '01:40:00', 3600, 2400, 6000, 25, '2025-10-15 12:05:00');

        INSERT INTO jobs_signatures (jobno, signedby, signedat, signaturepathdata, lastchanged)
        VALUES
        (1, 'Sarah Bennett', '2025-10-01 10:00:00', 'path/to/signature1', '2025-10-01 10:00:00'),
        (2, 'James Carter', '2025-10-02 15:00:00', 'path/to/signature2', '2025-10-02 15:00:00'),
        (3, 'Rachel Moore', '2025-10-03 12:30:00', 'path/to/signature3', '2025-10-03 12:30:00'),
        (4, 'Daniel Price', '2025-10-04 12:30:00', 'path/to/signature4', '2025-10-04 12:30:00'),
        (5, 'Rachel Moore', '2025-10-05 15:30:00', 'path/to/signature5', '2025-10-05 15:30:00'),
        (6, 'Laura Green', '2025-10-06 11:00:00', 'path/to/signature6', '2025-10-06 11:00:00'),
        (7, 'Daniel Price', '2025-10-07 09:45:00', 'path/to/signature7', '2025-10-07 09:45:00'),
        (8, 'Oliver Scott', '2025-10-08 14:00:00', 'path/to/signature8', '2025-10-08 14:00:00'),
        (9, 'Sophie Adams', '2025-10-09 12:15:00', 'path/to/signature9', '2025-10-09 12:15:00'),
        (10, 'George White', '2025-10-10 09:00:00', 'path/to/signature10', '2025-10-10 09:00:00'),
        (11, 'Amelia Clarke', '2025-10-11 16:30:00', 'path/to/signature11', '2025-10-11 16:30:00'),
        (12, 'Liam Turner', '2025-10-12 13:00:00', 'path/to/signature12', '2025-10-12 13:00:00'),
        (13, 'Grace Mitchell', '2025-10-13 11:45:00', 'path/to/signature13', '2025-10-13 11:45:00'),
        (14, 'Nathan Brooks', '2025-10-14 10:20:00', 'path/to/signature14', '2025-10-14 10:20:00'),
        (15, 'Chloe Davies', '2025-10-15 12:00:00', 'path/to/signature15', '2025-10-15 12:00:00');


   ''';

   const svgdelete: string =
   '<?xml version="1.0" encoding="utf-8"?>' +
    '<svg width="800px" height="800px" viewBox="0 0 1024 1024" class="icon"  version="1.1" xmlns="http://www.w3.org/2000/svg"><path d="M779.5 1002.7h-535c-64.3 0-116.5-52.3-116.5-116.5V170.7h768v715.5c0 64.2-52.3 116.5-116.5 116.5zM213.3 256v630.1c0 17.2 14 31.2 31.2 31.2h534.9c17.2 0 31.2-14 31.2-31.2V256H213.3z" fill="#3688FF" /><path d="M917.3 256H106.7C83.1 256 64 236.9 64 213.3s19.1-42.7 42.7-42.7h810.7c23.6 0 42.7 19.1 42.7 42.7S940.9 256 917.3 256zM618.7 128H405.3c-23.6 0-42.7-19.1-42.7-42.7s19.1-42.7 42.7-42.7h213.3c23.6 0 42.7 19.1 42.7 42.7S642.2 128 618.7 128zM405.3 725.3c-23.6 0-42.7-19.1-42.7-42.7v-256c0-23.6 19.1-42.7 42.7-42.7S448 403 448 426.6v256c0 23.6-19.1 42.7-42.7 42.7zM618.7 725.3c-23.6 0-42.7-19.1-42.7-42.7v-256c0-23.6 19.1-42.7 42.7-42.7s42.7 19.1 42.7 42.7v256c-0.1 23.6-19.2 42.7-42.7 42.7z" fill="#5F6379" /></svg>';
var
  DM: TDM;
  DBName: string;

procedure RequestPermissions;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  // Setup connection information depending on platform (e.g. android, windows)
  {$IF DEFINED(Android)}
    DBName := TPath.Combine(TPath.GetHomePath, 'WorksheetV1.sdb');
  {$ELSEIF DEFINED(MSWINDOWS)}
    var homeFolder := TPath.Combine(TPath.GetHomePath, 'WorkSheets');
    if not DirectoryExists(homeFolder) then
      CreateDir(homeFolder);
    DBName := TPath.Combine(homeFolder, 'WorksheetV1.sdb');
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
begin
  // Used to simplify asking user permissions for android devices
  DM.MobilePermissions1.Dangerous.Camera := true;
  DM.MobilePermissions1.Dangerous.WriteExternalStorage := true;
  DM.MobilePermissions1.Dangerous.ReadExternalStorage := true;
  DM.MobilePermissions1.Apply;
end;

end.
