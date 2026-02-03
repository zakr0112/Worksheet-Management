unit uJobForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Platform,
  uDataModule,  FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Skia, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Edit, FMX.Layouts, FMX.MultiView, FMX.Skia, FMX.ListView,
  FMX.TabControl, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
      {$IF Defined(Android)}
    AndroidAPI.JNI.JavaTypes, AndroidAPI.JNI.Widget, AndroidAPI.Helpers, Posix.UNISTD,
  {$ENDIF}
  uCommonDialogs, uCustomerManagerClass, uHelperTabControl, uJobsManagerClass,
  FMX.Objects, FMX.DateTimeCtrls, FMX.ListBox, uCommon, FMX.DialogService, FMX.DialogService.Async,
  FMX.ComboEdit, FMX.MediaLibrary, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions;

type
  TJobForm = class(TForm)
    TCJobs: TTabControl;
    TIjoblist: TTabItem;
    LVZJobs: TListView;
    panHeaderCustList: TPanel;
    spdNew: TSpeedButton;
    svgNew: TSkSvg;
    lblHeader: TSkLabel;
    spdHome: TSpeedButton;
    svgHome: TSkSvg;
    spdMenu: TSpeedButton;
    svgMenu: TSkSvg;
    MVDrawerJOB: TMultiView;
    gpanelSort: TGridPanelLayout;
    lblSort: TLabel;
    radSortJobnoHL: TRadioButton;
    radSortJobnoLH: TRadioButton;
    TIjobdetails: TTabItem;
    qryListJobs: TFDQuery;
    radSortCustAZ: TRadioButton;
    radSortCustZA: TRadioButton;
    TIJobsEdit: TTabItem;
    tbarJobsEdit: TToolBar;
    spdJobsBack: TSpeedButton;
    svgJobsBack: TSkSvg;
    lblJobEditHeader: TSkLabel;
    txtJobno: TText;
    ToolBar1: TToolBar;
    spdDeleteJob: TSpeedButton;
    spdSaveJob: TSpeedButton;
    sklLastchanged: TSkLabel;
    gridpanMain: TGridPanelLayout;
    VertScrollBox1: TVertScrollBox;
    layForScrollJobs: TLayout;
    TCJobDetails: TTabControl;
    TIReason: TTabItem;
    memReason: TMemo;
    tiWork: TTabItem;
    memWorkdone: TMemo;
    tiRemedial: TTabItem;
    memRemedial: TMemo;
    Layout5: TLayout;
    Text4: TText;
    txtReferred: TEdit;
    tiSpareparts: TTabItem;
    LBSpares: TListBox;
    GridPanelLayout3: TGridPanelLayout;
    Text10: TText;
    Text12: TText;
    txtSpareqty: TEdit;
    txtSparedetails: TEdit;
    spdInsertspare: TSpeedButton;
    SkSvg2: TSkSvg;
    tiTime: TTabItem;
    LBTime: TListBox;
    GridPanelLayout2: TGridPanelLayout;
    Text2: TText;
    Text5: TText;
    Text6: TText;
    Text8: TText;
    Text9: TText;
    dtDate: TDateEdit;
    teTravel: TTimeEdit;
    teArr: TTimeEdit;
    teDep: TTimeEdit;
    txtMileage: TEdit;
    spdSaveTime: TSpeedButton;
    svgSaveTime: TSkSvg;
    TIExpenses: TTabItem;
    LBExpenses: TListBox;
    GridPanelLayout1: TGridPanelLayout;
    lblDetailsExp: TText;
    lblCostExp: TText;
    txtDetailsExp: TEdit;
    txtCostExp: TEdit;
    spdSaveExpenses: TSpeedButton;
    svgSaveExpenses: TSkSvg;
    lblDateExp: TText;
    dtDateExp: TDateEdit;
    tiPhotos: TTabItem;
    GPLjobs: TGridPanelLayout;
    rectMainphoto: TRectangle;
    imgMainphoto: TImage;
    layImage1: TLayout;
    rectImage1: TRectangle;
    imgThumb1: TImage;
    layControls1: TLayout;
    imgCamera1: TSkSvg;
    imgAlbum1: TSkSvg;
    imgDelete1: TSkSvg;
    layImage2: TLayout;
    rectImage2: TRectangle;
    imgThumb2: TImage;
    layControls2: TLayout;
    imgCamera2: TSkSvg;
    imgAlbum2: TSkSvg;
    imgDelete2: TSkSvg;
    layImage3: TLayout;
    rectImage3: TRectangle;
    imgThumb3: TImage;
    layControls3: TLayout;
    imgCamera3: TSkSvg;
    imgAlbum3: TSkSvg;
    imgDelete3: TSkSvg;
    layImage4: TLayout;
    rectImage4: TRectangle;
    imgThumb4: TImage;
    layControls4: TLayout;
    imgCamera4: TSkSvg;
    imgAlbum4: TSkSvg;
    imgDelete4: TSkSvg;
    layImage5: TLayout;
    rectImage5: TRectangle;
    imgThumb5: TImage;
    layControls5: TLayout;
    imgCamera5: TSkSvg;
    imgAlbum5: TSkSvg;
    imgDelete5: TSkSvg;
    layImage6: TLayout;
    rectImage6: TRectangle;
    imgThumb6: TImage;
    layControls6: TLayout;
    imgCamera6: TSkSvg;
    imgAlbum6: TSkSvg;
    imgDelete6: TSkSvg;
    tiSignatures: TTabItem;
    Image2: TImage;
    Layout10: TLayout;
    txtPersonsigning: TEdit;
    Text7: TText;
    btnClearSignature: TButton;
    RoundRectSignatureCust: TRoundRect;
    PathSignatureCust: TPath;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    SkSvg1: TSkSvg;
    SkLabel1: TSkLabel;
    gridpanDetails: TGridPanelLayout;
    lblJobdate: TText;
    lblCallno: TText;
    lblContract: TText;
    dtJobdate: TDateEdit;
    txtCallno: TEdit;
    txtContract: TEdit;
    lblJobtype: TText;
    lblEngineer1: TText;
    txtEngineer1: TEdit;
    cbeJobtype: TComboBox;
    Text3: TText;
    txtEngineer2: TEdit;
    gridpanCust: TGridPanelLayout;
    Text1: TText;
    lblEmail1: TText;
    lblMobile: TText;
    txtEmail: TEdit;
    txtTelephone: TEdit;
    layoutCust: TLayout;
    txtCustname: TEdit;
    lblPostcode: TText;
    txtPostcode: TEdit;
    memAddress: TMemo;
    GridPanelLayout8: TGridPanelLayout;
    Text22: TText;
    Text23: TText;
    Text24: TText;
    dtNewDate: TDateEdit;
    txtNewCallNo: TEdit;
    txtNewContract: TEdit;
    Text25: TText;
    Text26: TText;
    txtNewEngineer1: TEdit;
    cbeNewJobtype: TComboBox;
    Text27: TText;
    txtNewEngineer2: TEdit;
    Text11: TText;
    cbCustomers: TComboEdit;
    ToolBar3: TToolBar;
    spdAddJob: TSpeedButton;
    Text13: TText;
    memNewReason: TMemo;
    spdCancel: TSpeedButton;
    ActionList1: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    qrySavePhoto: TFDQuery;
    OpenDialog1: TOpenDialog;
    qryJobphotos: TFDQuery;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    procedure spdHomeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure radSortJobnoHLClick(Sender: TObject);
    procedure spdNewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LVZJobsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure spdbackjoblistClick(Sender: TObject);
    procedure RoundRectSignatureCustMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure RoundRectSignatureCustMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Single);
    procedure btnClearSignatureClick(Sender: TObject);
    procedure DoLBExpensesDeleteClick(Sender: TObject);
    procedure LVZJobsPullRefresh(Sender: TObject);
    procedure DoLBSparesDeleteClick(Sender: TObject);
    procedure DoLBTimeDeleteClick(Sender: TObject);
    procedure spdInsertspareClick(Sender: TObject);
    procedure spdSaveExpensesClick(Sender: TObject);
    procedure spdSaveTimeClick(Sender: TObject);
    procedure spdSaveJobClick(Sender: TObject);
    procedure spdAddJobClick(Sender: TObject);
    procedure spdDeleteJobClick(Sender: TObject);
    procedure sklLastchangedClick(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    //These are manually assigned so that i can add the event in multiple places
    procedure LoadFromLibraryClick(Sender: TObject);
    procedure ImageCameraClick(Sender: TObject);
    procedure ShowPictureClick(Sender: TObject);
    procedure DeletePictureClick(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
  private
    procedure PopulateJobsList;
    procedure DisplayJobRecord;
    procedure ClearJobRecord;
    procedure ShowExpenses;
    procedure ClearExpenses;
    procedure ShowSpares;
    procedure ClearSpares;
    procedure DeleteSparesRecord(const AItem: TListBoxItem);
    procedure ShowTime;
    procedure ClearTime;
    procedure DeleteTimeRecord(const AItem: TListBoxItem);
    procedure DeleteExpensesRecord(const AItem: TListBoxItem);
    procedure InsertSpareRecord;
    procedure InsertExpenseRecord;
    procedure InsertTimeRecord;
    procedure LoadCustomers;
    procedure AskInsertCustomer(const ACustName: string);
    procedure AskDeleteJob();
    procedure SavePhoto(const AJobNo, APhotoNo: integer; Image: TBitMap);
    procedure UnselectThumbFill;
    procedure ClearDisplayedPhotos;
    procedure ShowJobPhotos;
    procedure DeleteJobphoto(const AJobno, APhoto: integer);

    var
      FThumbs: array[1..6] of TImage;   // used for images
      FRects: array[1..6] of TRectangle; // used for images   
  public
    { Public declarations }
  end;

  function FindItemParent(OBJ: TFMXObject; ParentClass: TCLASS): TFMXObject;

var
  JobForm: TJobForm;
  jobno: integer;

  CurrentImageTag: integer;  // Used for currently clicked image

implementation

{$R *.fmx}

uses System.DateUtils, System.Math;

procedure TJobForm.FormDestroy(Sender: TObject);
begin
  // Whatever we create, we free
  if Assigned(Job) then
    Job.Free;
  if Assigned(Customer) then
    Customer.Free;
end;

procedure TJobForm.FormCreate(Sender: TObject);
begin
  RoundRectSignatureCust.AutoCapture := true;
  StyleComboBox(cbeJobtype, 18, TAlphaColors.White);
  StyleComboBox(cbeNewJobtype, 18, TAlphaColors.White);

    // preserve font styling for sklLastchanged
  sklLastchanged.StyledSettings := sklLastchanged.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];

  Job := TJobManager.Create(DM.FDlocal);
  TCJobs.TabPosition := TTabPosition.None;
  TCJobs.ActiveTab := TIJobList;
  if not DM.FDLocal.Connected then
    DM.FDlocal.Open();
  PopulateJobsList();

  // used for photo management to save duplicate code!
  FThumbs[1] := imgThumb1;
  FThumbs[2] := imgThumb2;
  FThumbs[3] := imgThumb3;
  FThumbs[4] := imgThumb4;
  FThumbs[5] := imgThumb5;
  FThumbs[6] := imgThumb6;

  FRects[1] := rectImage1;
  FRects[2] := rectImage2;
  FRects[3] := rectImage3;
  FRects[4] := rectImage4;
  FRects[5] := rectImage5;
  FRects[6] := rectImage6;

  CurrentImageTag := 0;  // default, we set when clicked later in code
  
end;

procedure TJobForm.btnClearSignatureClick(Sender: TObject);
begin
  PathSignatureCust.Data.Clear;
end;

procedure TJobForm.DeleteSparesRecord(const AItem: TListBoxItem);
begin
  var spid := AItem.Tag;
  var MSG := 'Do you really want to delete the spare part? ';
  TDialogService.MessageDialog(MSG, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure (const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        try
          DM.FDlocal.ExecSQL(format('DELETE FROM jobs_spareparts WHERE spid = %d;', [spid]));
          ShowSpares;
        except
          on E: Exception do
          begin
            ShowException('Delete Part', E);
          end;

        end;
      end;
    end);
end;

procedure TJobForm.DeleteTimeRecord(const AItem: TListBoxItem);
begin
  var trid := AItem.Tag;
  var MSG := 'Do you really want to delete the time record? ';
  TDialogService.MessageDialog(MSG, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure (const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        try
          DM.FDlocal.ExecSQL(format('DELETE FROM jobs_timerecords WHERE trid = %d;', [trid]));
          ShowTime;
        except
          on E: Exception do
          begin
            ShowException('Delete Time Record', E);
          end;

        end;
      end;
    end);
end;

procedure TJobForm.DeleteExpensesRecord(const AItem: TListBoxItem);
begin
  var exid := AItem.Tag;
  var MSG := 'Do you really want to delete the expense record? ';
  TDialogService.MessageDialog(MSG, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure (const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        try
          DM.FDlocal.ExecSQL(format('DELETE FROM jobs_expenses WHERE exid = %d;', [exid]));
          ShowExpenses;
        except
          on E: Exception do
          begin
            ShowException('Delete Expense Record', E);
          end;

        end;
      end;
    end);
end;

procedure TJobForm.DisplayJobRecord;
begin
  txtJobno.Text := Format('%.*d', [5, job.Jobno]);
  txtCustname.Text := Job.Custname;
  memAddress.Text := Job.Address;
  txtPostcode.Text := Job.Postcode;
  txtEmail.Text := Job.Email;
  txtTelephone.Text := Job.Telephone;
  dtJobdate.Date := Job.Jobdate;
  cbeJobtype.ItemIndex := cbeJobtype.Items.IndexOf(Job.Jobtype);
  txtCallno.Text := Job.Callno;
  txtContract.Text := Job.Contractno;
  txtEngineer1.Text := Job.Engineername1;
  txtEngineer2.Text := Job.Engineername2;
  memReason.Text := Job.Reason;
  memWorkdone.Text := Job.Workdone;
  txtReferred.Text := Job.Referredto;
  memRemedial.Text := Job.Remedial;
  txtPersonsigning.Text := Job.Signedby;
  PathSignatureCust.Data.Data := Job.Signaturepathdata;

    // sets the last changed date with my actual styling
  with sklLastchanged do
  begin
    TextSettings.Font.Size := 18;
    TextSettings.FontColor := TAlphaColors.White;
    Text := 'Last changed: ' + FormatDateTime('dd/mm/yyyy hh:nn', Job.Lastchanged);
  end;
end;

procedure TJobForm.ClearJobRecord;
begin
  txtJobno.Text := '';
  txtCustname.Text := '';
  memAddress.Text := '';
  txtPostcode.Text := '';
  txtEmail.Text := '';
  txtTelephone.Text := '';
  dtJobdate.Date := now();
  cbeJobtype.ItemIndex := -1;
  txtCallno.Text := '';
  txtContract.Text := '';
  txtEngineer1.Text := '';
  txtEngineer2.Text := '';
  memReason.Text := '';
  memWorkdone.Text := '';
  txtReferred.Text := '';
  memRemedial.Text := '';
  PathSignatureCust.Data.Clear;
  txtPersonsigning.Text := '';
end;

procedure TJobForm.AskInsertCustomer(const ACustName: string);
begin
  var Msg := Format('Customer "%s" does not exist in the database.' + sLineBreak + 'Do you wish to insert the customer for future use?', [ACustName]);
  TDialogService.MessageDialog(
    Msg,
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        Customer.QuickInsertCustomer(ACustName);
      end;
    end
  );
end;

procedure TJobForm.sklLastchangedClick(Sender: TObject);
begin
  // Last changed date
  with sklLastchanged do
  begin
    TextSettings.Font.Size := 18;
    TextSettings.FontColor := TAlphaColors.White;
    Text := FormatDateTime('dd/mm/yyyy hh:nn', Job.Lastchanged);
  end;
end;


procedure TJobForm.spdAddJobClick(Sender: TObject);
begin
  // Verify entry
  if dtNewdate.IsEmpty then
  begin
    ShowWarning('A Job date must be entered!', dtNewdate);
    exit;
  end;

  if cbeNewJobtype.ItemIndex < 0 then
  begin
    ShowWarning('A Job Type must be entered!', cbeNewJobtype);
    exit;
  end;

  if cbCustomers.Text.IsEmpty then
  begin
    ShowWarning('A customer name must be entered!', cbCustomers);
    exit;
  end;

  // Now we validate that the customer exists...
  if Customer.FetchCustomerByName(Trim(cbCustomers.Text)) then
  begin
    // the customer has selected an existing customer, so we set the job details accordoingly
    Job.Custname := Customer.CustName;
    Job.Address := Customer.CustAddress;
    Job.Postcode := Customer.CustPostcode;
    Job.Email := Customer.CustEmail;
    Job.Telephone := Customer.CustTelephone;
  end
  else
  begin
    // The user has entered a new customer, ask if they wish to save the customer details?
    Customer.CustName := Trim(cbCustomers.Text);
    AskInsertCustomer(Trim(cbCustomers.Text));
    Job.Custname := Trim(cbCustomers.Text); // incase they said no!
  end;
  Job.Jobdate := dtNewdate.Date;
  Job.Jobtype := cbeNewJobtype.Text;
  Job.Callno := Trim(txtNewCallno.Text);
  Job.Contractno := Trim(txtNewContract.Text);
  Job.Engineername1 := Trim(txtNewEngineer1.Text);
  Job.Engineername2 := Trim(txtNewEngineer2.Text);
  Job.Reason := Trim(memNewReason.Text);
  var success := Job.InsertJob;
  if success then
  begin
    // We fetch the saved job!
    DisplayJobRecord;
    TCJobs.TabRight(TIJobsEdit);

  end;
end;

procedure TJobForm.spdbackjoblistClick(Sender: TObject);
begin
  // Go back to the list
  jobno := -1;
  TCJobs.TabLeft(TIJobList); // Using helper
  ClearJobRecord();
end;

procedure TJobForm.spdHomeClick(Sender: TObject);
begin
  Close;
end;

procedure TJobForm.spdInsertspareClick(Sender: TObject);
begin
  InsertSpareRecord;
end;

procedure TJobForm.InsertSpareRecord;
begin
  var Qty := StrToIntDef(txtSpareQty.Text.Trim, 0);
  if Qty < 1 then
  begin
    ShowWarning('A valid quantity greater than zero must be entered!', txtSpareQty);
    Exit;
  end;

  if txtSpareDetails.Text.Trim = '' then
  begin
    ShowWarning('Spare part details must be entered!', txtSpareDetails);
    Exit;
  end;

  try
    DM.FDLocal.ExecSQL(
      'INSERT INTO jobs_spareparts (jobno, partdetails, qtyused, lastchanged) ' +
      'VALUES (:jobno, :partdetails, :qtyused, :lastchanged)',
      [ jobno,
        txtSpareDetails.Text.Trim,
        Qty,
        Now ]
    );

    ClearSpares;
    ShowSpares;
  except
    on E: Exception do
      ShowException('Save spare part', E);
  end;
end;

procedure TJobForm.ImageCameraClick(Sender: TObject);
var
  Service: IFMXCameraService;
begin
  RequestPermissions();
  UnselectThumbFill();
  CurrentImageTag := TComponent(Sender).Tag;
  FRects[CurrentImageTag].Fill.Color := TAlphaColors.Lightskyblue;//.Cornflowerblue;
  imgMainphoto.Bitmap.Assign(FThumbs[CurrentImageTag].Bitmap);
  if TPlatformServices.Current.SupportsPlatformService(IFMXCameraService, Service) then
  begin
    TakePhotoFromCameraAction1.Execute;
  end
  else
    ShowMessage('This device does not support the camera service');

  
end;

procedure TJobForm.UnselectThumbFill();
begin
  // Reset the background colour as no image control selected...
  for var I := 1 to 6 do
    FRects[I].Fill.Color := TAlphaColors.Lightslategray;
end;

procedure TJobForm.InsertExpenseRecord;
var
  CostPrice: double;
begin

  if dtDateExp.Date = 0 then
  begin
    ShowWarning('The date for this expense must be provided!', dtDateExp);
    Exit;
  end;

  if txtDetailsExp.Text.IsEmpty then
  begin
    ShowWarning('Details of this expense must be entered!', txtDetailsExp);
    Exit;
  end;

  // This is where costprice gets set as a double (float)...
  if not TryStrToFloat(txtCostExp.Text, CostPrice) then
  begin
    ShowWarning('A valid numeric cost must be entered!', txtCostExp);
    Exit;
  end;

  if (CostPrice < 0.00) or (CostPrice > 99999.99) then
  begin
    ShowWarning('Cost must be between 0.00 and 99999.99!', txtCostExp);
    Exit;
  end;

  try
    DM.FDLocal.ExecSQL(
      'INSERT INTO jobs_expenses (jobno, exdate, exdetails, excost, lastchanged) ' +
      'VALUES (:jobno, :exdate, :exdetails, :excost, :lastchanged)',
      [ jobno,
        dtDateExp.Date,
        txtDetailsExp.Text.Trim,
        CostPrice,
        Now ]
    );

    ClearExpenses;
    ShowExpenses;
  except
    on E: Exception do
      ShowException('Save Expenses', E);
  end;
end;


procedure TJobForm.InsertTimeRecord;
var
  TravelTime,
  ArrTime,
  DepTime: TTime;
begin

  if dtDate.Date = 0 then
  begin
    ShowWarning('The date for this time/travel entry must be provided!', dtDate);
    Exit;
  end;

  var totJob := 0;
  var totTravel := 0;

  if not teTravel.IsEmpty then
    totTravel := GetSeconds(teTravel.Time);

  if (not teArr.IsEmpty) and (not teDep.IsEmpty) then
    totJob := SecondsBetween(teArr.Time, teDep.Time);

  var totAll := totJob + totTravel;

  TravelTime := IfThen(teTravel.IsEmpty, 0, teTravel.Time);
  ArrTime    := IfThen(teArr.IsEmpty,    0, teArr.Time);
  DepTime    := IfThen(teDep.IsEmpty,    0, teDep.Time);

  try
    DM.FDLocal.ExecSQL(
      'INSERT INTO jobs_timerecords (jobno, logdate, traveltime, timearrived, timedeparted, mileage, jobtimeseconds, traveltimeseconds, totaltimeseconds, lastchanged) ' +
      'VALUES (:jobno, :logdate, :traveltime, :timearrived, :timedeparted, :mileage, :jobtimeseconds, :traveltimeseconds, :totaltimeseconds, :lastchanged)',
      [ jobno,
        dtDate.Date,
        TravelTime,
		    ArrTime,
		    DepTime,
		    txtMileage.Text,
		    totJob,
		    totTravel,
		    totAll,
        Now ]
    );

    ClearTime;
    ShowTime;
  except
    on E: Exception do
      ShowException('Save Time/Travel', E);
  end;
end;

procedure TJobForm.spdNewClick(Sender: TObject);
begin
  if not Assigned(Customer) then
    Customer := TCustomerManager.Create(DM.FDlocal);

  ClearJobRecord;
  if cbCustomers.items.Count < 1 then
    LoadCustomers;

  TCJobs.TabRight(TIjobdetails);
end;

procedure TJobForm.spdSaveExpensesClick(Sender: TObject);
begin
  InsertExpenseRecord;
end;

procedure TJobForm.spdSaveJobClick(Sender: TObject);
var
  success: boolean;
begin
  // Validate entries
  if dtJobdate.IsEmpty then
  begin
    ShowWarning('A Job date must be entered!', dtJobdate);
    exit;
  end;
    if cbeJobtype.ItemIndex < 0 then
  begin
    ShowWarning('A Job Type must be entered!', cbeJobtype);
    exit;
  end;
  if txtCustname.Text.IsEmpty then
  begin
    ShowWarning('A customer name must be entered!', txtCustname);
    exit;
  end;

  Job.Custname := Trim(txtCustname.Text);
  Job.Address := Trim(memAddress.Text);
  Job.Postcode := Trim(txtPostcode.Text);
  Job.Email := Trim(txtEmail.Text);
  Job.Telephone := Trim(txtTelephone.Text);
  Job.Jobdate := dtJobdate.Date;
  Job.Jobtype := cbeJobtype.Text;
  Job.Callno := Trim(txtCallno.Text);
  Job.Contractno := Trim(txtContract.Text);
  Job.Engineername1 := Trim(txtEngineer1.Text);
  Job.Engineername2 := Trim(txtEngineer2.Text);
  Job.Reason := Trim(memReason.Text);
  Job.Workdone := Trim(memWorkdone.Text);
  Job.Referredto := Trim(txtReferred.Text);
  Job.Remedial := Trim(memRemedial.Text);
  Job.Signedby := Trim(txtPersonsigning.Text);
  Job.Signaturepathdata := pathsignaturecust.Data.Data;

  if Job.jobno < 0 then
    success := Job.InsertJob
  else
    success := Job.UpdateJob;
  if success then
  begin
    Job.FetchJob(Job.Jobno);
  with sklLastchanged do
  begin
    TextSettings.Font.Size := 18;
    TextSettings.FontColor := TAlphaColors.White;
    Text := 'Last changed: ' + FormatDateTime('dd/mm/yyyy hh:nn', Job.Lastchanged);
  end;
    PopulateJobsList();
    TCJobs.SetActiveTabWithTransitionAsync(TIjoblist, TTabTransition.Slide, TTabTransitionDirection.Reversed,
      procedure()
      begin
        ShowToast(format('Job %d details have been saved!', [Job.Jobno]));
      end)
  end;
end;

procedure TJobForm.spdSaveTimeClick(Sender: TObject);
begin
  InsertTimeRecord;
end;

procedure TJobForm.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  if not Assigned(Image) then
    exit;
  SavePhoto(job.Jobno, CurrentImageTag, Image);
  FThumbs[CurrentImageTag].Bitmap.Assign(Image);
  imgMainPhoto.Bitmap.Assign(Image);
end;

procedure TJobForm.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  // If an image has been loaded, we need to display it and save it to the DB
  if not Assigned(Image) then
    exit;

  SavePhoto(job.Jobno, CurrentImageTag, Image);
  FThumbs[CurrentImageTag].Bitmap.Assign(Image);
  imgMainPhoto.Bitmap.Assign(Image); // display the resized image
end;

procedure TJobForm.SavePhoto(const AJobNo, APhotoNo: integer; Image: TBitMap);

  // Resize the image (if required), and then save to the DB
  procedure ResizeBitmap(source: TBitMap; MaxSize: integer = 1024);
  var
    Ratio: single;
    NewWidth, NewHeight: integer;
    BitmapScaled: TBitMap;
  begin
    if (Source.Width <= MaxSize) and (Source.Height <= MaxSize) then
      exit;
    if Source.Width > Source.Height then
    begin
      Ratio := MaxSize / Source.Width;
      NewWidth := MaxSize;
      NewHeight := Round(Source.Height * Ratio);
    end
    else
    begin
      Ratio := MaxSize / Source.Height;
      NewWidth := Round(Source.Width * Ratio);
      NewHeight := MaxSize;
    end;
    BitmapScaled := TBitmap.Create(NewWidth, NewHeight);
    try
      BitmapScaled.Clear(0);
      BitmapScaled.Canvas.BeginScene;
      try
        BitmapScaled.Canvas.DrawBitmap(Source, RectF(0, 0, Source.Width, Source.Height), RectF(0, 0, NewWidth, NewHeight), 1);
      finally
        BitmapScaled.Canvas.EndScene;
      end;
      Source.Assign(BitmapScaled);
    finally
      BitmapScaled.Free;
    end;
  end;

var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Stream.Position := 0;
    try
      ResizeBitmap(Image);
      Image.SaveToStream(Stream);
      qrySavePhoto.SQL.Text := 'REPLACE INTO jobs_photos (jobno, photono, photo, lastchanged) VALUES (:jobno, :photono, :photo, :lastchanged);';
      qrySavePhoto.ParamByName('jobno').AsInteger := job.Jobno;
      qrySavePhoto.ParamByName('photono').AsInteger := CurrentImageTag;
      qrySavePhoto.ParamByName('photo').LoadFromStream(Stream, ftBlob);
      qrySavePhoto.ParamByName('lastchanged').AsDateTime := Now();
      qrySavePhoto.ExecSQL; // Execute the query
    except
      on E: Exception do
      begin 
      ShowException('Save photo', E);
      end;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TJobForm.AskDeleteJob();
begin
  var workjob := job.Jobno;
  var Msg := Format('Do you wish to delete the job %d ?', [workjob]);
  TDialogService.MessageDialog(
    Msg,
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        if job.DeleteJob(job.jobno) then
        begin
          PopulateJobsList();
          TCJobs.SetActiveTabWithTransitionAsync(TIjoblist, TTabTransition.Slide, TTabTransitionDirection.Reversed,
            procedure()
            begin
              ShowToast(format('Job %d details have been deleted!', [workjob]));
            end)
        end;

      end;
    end
  );
end;

procedure TJobForm.spdDeleteJobClick(Sender: TObject);
begin
  // Delete a record
  AskDeleteJob;
end;

procedure TJobForm.LVZJobsItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
  if (ItemIndex < 0) OR (ItemObject = NIL) then
    exit;

  // Only continue if the right hand arrow button clicked
  if ItemObject is TListItemAccessory then
  begin
    ClearJobRecord;
    jobno := LVZJobs.Items.Item[itemindex].Tag;
    if not Job.FetchJob(jobno) then
    begin
      ShowWarning('Unable to find the selected record!');
      exit;
    end;
    DisplayJobRecord;
    ShowExpenses;
    ShowSpares;
    ShowTime;
    ShowJobPhotos;
    TCJobDetails.TabIndex := 0; // Always show the reason tab first on job edit
    TCJobs.TabRight(TIJobsEdit);
  end;
end;

procedure TJobForm.LVZJobsPullRefresh(Sender: TObject);
begin
  PopulateJobsList();
end;

procedure TJobForm.PopulateJobsList();
begin
  qryListjobs.Open();
  LVZJobs.BeginUpdate;
  try
    LVZJobs.Items.Clear;
    while not qryListjobs.Eof do
    begin
      with LVZJobs.Items.Add do
      begin
        Tag := qryListjobs.FieldByName('jobno').AsInteger;
        Data['lvoJobno'] := Format('%.*d', [5, qryListjobs.FieldByName('jobno').AsInteger]);
        Data['lvoCustname'] := qryListjobs.FieldByName('custname').AsString;
        Data['lvoJobtype'] := qryListjobs.FieldByName('jobtype').AsString;
        if qryListjobs.FieldByName('jobdate').IsNull then
          Data['lvoJobdate'] := 'dd/mm/yyyy'
        else
          Data['lvoJobdate'] := DateToStr(qryListjobs.FieldByName('jobdate').AsDateTime);
       // Data['lvoPdf'] := imgPdf.Bitmap;
       // Data['lvoEdit'] := imgEdit.Bitmap;
      end;
      qryListjobs.Next;
    end;
  finally
    LVZJobs.EndUpdate;
    qryListjobs.Close;
    MVDrawerJob.HideMaster;
  end;
end;

procedure TJobForm.radSortJobnoHLClick(Sender: TObject);
begin
  case (Sender AS TRadioButton).Tag of
    1: qryListJobs.SQL.Text := 'SELECT jobno, custname, jobtype, jobdate FROM jobs_master ORDER BY jobno;';
    2: qryListJobs.SQL.Text := 'SELECT jobno, custname, jobtype, jobdate FROM jobs_master ORDER BY custname;';
    3: qryListJobs.SQL.Text := 'SELECT jobno, custname, jobtype, jobdate FROM jobs_master ORDER BY custname DESC;';
  else
    qryListJobs.SQL.Text := 'SELECT jobno, custname, jobtype, jobdate FROM jobs_master ORDER BY jobno DESC;';
  end;
  MVDrawerJob.HideMaster;
  PopulateJobsList();
end;

procedure TJobForm.RoundRectSignatureCustMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if ssLeft in Shift then
    PathSignatureCust.Data.MoveTo(PointF(X, Y));
end;

procedure TJobForm.RoundRectSignatureCustMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  if ssLeft in Shift then
  begin
    PathSignatureCust.Data.LineTo(PointF(X, Y));
    RoundRectSignatureCust.Repaint;
  end;
end;

procedure TJobForm.ClearTime;
begin
  dtdate.Date := now;
  teArr.DateTime := 0.0;
  teDep.DateTime := 0.0;
  teTravel.DateTime := 0.0;
  txtMileage.Text := '';
  dtdate.IsEmpty := true;
  teArr.IsEmpty := true;
  teDep.IsEmpty := true;
  teTravel.IsEmpty := true;
end;

procedure TJobForm.ClearExpenses;
begin
  dtDateExp.Date := Date;
  txtDetailsExp.Text := '';
  txtCostExp.Text := '';
end;

procedure TJobForm.ShowExpenses;
var
  LBI: TListBoxItem;
  SVG: TSkSVG;
  LBL: TLabel;
  BTNDELETE: TSpeedButton;
  recid: Integer;
begin
  ClearExpenses;
  DM.qryExpenses.Open(format('SELECT * FROM jobs_expenses WHERE jobno = %d ORDER BY exdate ASC, lastchanged ASC', [jobno]));
  LBExpenses.BeginUpdate;
  try
    LBExpenses.Items.Clear;
    while not DM.qryExpenses.Eof do
    begin
      recid := DM.qryExpenses.FieldByName('exid').AsInteger;

      LBI := TListBoxItem.Create(LBExpenses);
      LBI.Parent := LBExpenses;
      LBI.StyleLookup := 'customitem';
      LBI.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
      LBI.Height := 40;
      LBI.Tag := recid;

      BTNDELETE := TSpeedButton.Create(LBI);
      BTNDELETE.StyleLookup := 'transparentcirclebuttonstyle';
      BTNDELETE.Parent := LBI;
      BTNDELETE.Tag := recid;
      BTNDELETE.Align := TAlignLayout.MostRight;
      BTNDELETE.Margins.Top := 1;
      BTNDELETE.Margins.Right := 8;
      BTNDELETE.Margins.Left := 8;
      BTNDELETE.Margins.Bottom := 1;
      BTNDELETE.Width := 40;
      BTNDELETE.OnClick := DoLBExpensesDeleteClick;
      BTNDELETE.HitTest := true;

      SVG := TSkSVG.Create(BTNDELETE);
      SVG.Parent := BTNDELETE;
      SVG.HitTest := false;
      SVG.Svg.Source := svgdelete;
      SVG.Align := TAlignLayout.Center;
      SVG.Height := 28;
      SVG.Width := 28;

      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 142;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := FormatDateTime('dd/mm/yyyy', DM.qryExpenses.FieldByName('exdate').AsDateTime);

      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Align := TAlignLayout.Client;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := DM.qryExpenses.FieldByName('exdetails').AsString;

      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 90;
      LBL.Align := TAlignLayout.Right;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := FormatFloat('0.00', DM.qryExpenses.FieldByName('excost').AsFloat);

      DM.qryExpenses.Next;

    end;

  finally
    LBExpenses.EndUpdate;
    DM.qryExpenses.Close;
  end;
end;

procedure TJobForm.ShowTime;
var
  LBI: TListBoxItem;
  SVG: TSkSVG;
  LBL: TLabel;
  BTNDELETE: TSpeedButton;
  recid: Integer;
begin
  ClearTime;
  DM.qryTime.Open(format('SELECT * FROM jobs_timerecords WHERE jobno = %d ORDER BY logdate ASC, lastchanged ASC', [jobno]));
  LBTime.BeginUpdate;
  try
    LBTime.Items.Clear;
    while not DM.qryTime.Eof do
    begin
      recid := DM.qryTime.FieldByName('trid').AsInteger;

      // Create the listboxitem container
      LBI := TListBoxItem.Create(LBTime);
      LBI.Parent := LBTime;
      LBI.StyleLookup := 'customitem';
      LBI.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
      LBI.Height := 40;
      LBI.Tag := recid;

      // Creat the delete button control
      BTNDELETE := TSpeedButton.Create(LBI);
      BTNDELETE.StyleLookup := 'transparentcirclebuttonstyle';
      BTNDELETE.Parent := LBI;
      BTNDELETE.Tag := recid;
      BTNDELETE.Align := TAlignLayout.MostRight;
      BTNDELETE.Margins.Top := 1;
      BTNDELETE.Margins.Right := 8;
      BTNDELETE.Margins.Left := 8;
      BTNDELETE.Margins.Bottom := 1;
      BTNDELETE.Width := 40;
      BTNDELETE.OnClick := DoLBTimeDeleteClick;
      BTNDELETE.HitTest := true;

      // Create the delete button SVG icon
      SVG := TSkSVG.Create(BTNDELETE);
      SVG.Parent := BTNDELETE;
      SVG.HitTest := false;
      SVG.Svg.Source := svgdelete;
      SVG.Align := TAlignLayout.Center;
      SVG.Height := 28;
      SVG.Width := 28;

      // Creat the label for the date
      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 142;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := FormatDateTime('dd/mm/yyyy', DM.qryTime.FieldByName('logdate').AsDateTime);

      //  Create the label for the travel time
      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 103;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := DM.qryTime.FieldByName('traveltime').AsString;

      // Create the label for time arrived
      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 120;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      if DM.qryTime.FieldByName('timearrived').IsNull then
        LBL.Text := ''
      else
        LBL.Text := FormatDateTime('hh:mm', DM.qryTime.FieldByName('timearrived').AsDateTime);

      // Create the label for time departed
      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 120;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      if DM.qryTime.FieldByName('timedeparted').IsNull then
        LBL.Text := ''
      else
        LBL.Text := FormatDateTime('hh:mm', DM.qryTime.FieldByName('timedeparted').AsDateTime);

      // Create the label for mileage
      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 120;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      if DM.qryTime.FieldByName('mileage').IsNull then
        LBL.Text := ''
      else
        LBL.Text := DM.qryTime.FieldByName('mileage').AsString;

      DM.qryTime.Next;

    end;

  finally
    LBTime.EndUpdate;
    DM.qryTime.Close;
  end;
end;

procedure TJobForm.ClearSpares;
begin
  txtSpareqty.Text := '';
  txtSparedetails.Text := '';
end;

procedure TJobForm.ShowSpares;
var
  LBI: TListBoxItem;
  SVG: TSkSVG;
  LBL: TLabel;
  BTNDELETE: TSpeedButton;
  recid: Integer;
begin
  ClearSpares;
  DM.qrySpares.Open(format('SELECT * FROM jobs_spareparts WHERE jobno = %d ORDER BY spid ASC, lastchanged ASC', [jobno]));
  LBSpares.BeginUpdate;
  try
    LBSpares.Items.Clear;
    while not DM.qrySpares.Eof do
    begin
      recid := DM.qrySpares.FieldByName('spid').AsInteger;

      LBI := TListBoxItem.Create(LBSpares);
      LBI.Parent := LBSpares;
      LBI.StyleLookup := 'customitem';
      LBI.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
      LBI.Height := 40;
      LBI.Tag := recid;

      BTNDELETE := TSpeedButton.Create(LBI);
      BTNDELETE.StyleLookup := 'transparentcirclebuttonstyle';
      BTNDELETE.Parent := LBI;
      BTNDELETE.Tag := recid;
      BTNDELETE.Align := TAlignLayout.MostRight;
      BTNDELETE.Margins.Top := 1;
      BTNDELETE.Margins.Right := 8;
      BTNDELETE.Margins.Left := 8;
      BTNDELETE.Margins.Bottom := 1;
      BTNDELETE.Width := 40;
      BTNDELETE.OnClick := DoLBSparesDeleteClick;
      BTNDELETE.HitTest := true;

      SVG := TSkSVG.Create(BTNDELETE);
      SVG.Parent := BTNDELETE;
      SVG.HitTest := false;
      SVG.Svg.Source := svgdelete;
      SVG.Align := TAlignLayout.Center;
      SVG.Height := 28;
      SVG.Width := 28;

      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Width := 80;
      LBL.Align := TAlignLayout.MostLeft;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := DM.qrySpares.FieldByName('qtyused').AsString;

      LBL := TLabel.Create(LBI);
      LBL.Parent := LBI;
      LBL.AutoSize := false;
      LBL.Align := TAlignLayout.Client;
      LBL.TextSettings.HorzAlign := TTextAlign.Leading;
      LBL.TextSettings.VertAlign := TTextAlign.Center;
      LBL.StyledSettings := [];
      LBL.TextSettings.Font.Size := 18;
      LBL.TextSettings.FontColor := TAlphaColors.White;
      LBL.StyledSettings := LBL.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
      LBL.Text := DM.qrySpares.FieldByName('partdetails').AsString;

      DM.qrySpares.Next;

    end;

  finally
    LBSpares.EndUpdate;
    DM.qrySpares.Close;
  end;
end;

procedure TJobForm.DoLBTimeDeleteClick(Sender: TObject);
begin
  var SelectedTime := TListBoxItem(FindItemParent(Sender as TFMXObject, TListBoxItem));
  if not assigned(SelectedTime) then
    exit;
  if LBTime.ItemIndex <> SelectedTime.Index then
    LBTime.ItemIndex := SelectedTime.Index;
  DeleteTimeRecord(SelectedTime);
end;

procedure TJobForm.DoLBSparesDeleteClick(Sender: TObject);
begin
  var SelectedSpares := TListBoxItem(FindItemParent(Sender as TFMXObject, TListBoxItem));
  if not assigned(SelectedSpares) then
    exit;
  if LBSpares.ItemIndex <> SelectedSpares.Index then
    LBSpares.ItemIndex := SelectedSpares.Index;
  DeleteSparesRecord(SelectedSpares);
end;

procedure TJobForm.DoLBExpensesDeleteClick(Sender: TObject);
begin
  var SelectedExpense := TListBoxItem(FindItemParent(Sender as TFMXObject, TListBoxItem));
  if not assigned(SelectedExpense) then
    exit;
  if LBExpenses.ItemIndex <> SelectedExpense.Index then
    LBExpenses.ItemIndex := SelectedExpense.Index;
  DeleteExpensesRecord(SelectedExpense);
end;

function FindItemParent(OBJ: TFMXObject; ParentClass: TCLASS): TFMXObject;
begin
  Result := nil;
  if OBJ = nil then
    Exit;
  if (OBJ.Parent <> nil) and (OBJ.Parent is ParentClass) then
    Exit(OBJ.Parent);
  if OBJ.Parent <> nil then
    Result := FindItemParent(OBJ.Parent, ParentClass);
end;

procedure TJobForm.LoadCustomers;
begin
  cbCustomers.BeginUpdate; // stops visual flashing if lots of items
  try
    cbCustomers.Clear;
    DM.qryListCust.SQL.Text := 'SELECT custname FROM customers ORDER BY custname';
    DM.qryListCust.Open;
    while not DM.qryListCust.Eof do
    begin
      cbCustomers.Items.Add(DM.qryListCust.FieldByName('custname').AsString);
      DM.qryListCust.Next;
    end;
  finally
    cbCustomers.EndUpdate;
    DM.qryListCust.Close;
  end;
end;


procedure TJobForm.LoadFromLibraryClick(Sender: TObject);
var
  ImageService: IFMXTakenImageService;
begin
  RequestPermissions();
  UnselectThumbFill();
  CurrentImageTag := TComponent(Sender).Tag;
  FRects[CurrentImageTag].Fill.Color := TAlphaColors.Lightskyblue;
  imgMainphoto.Bitmap.Assign(FThumbs[CurrentImageTag].Bitmap);
  if TPlatformServices.Current.SupportsPlatformService(IFMXTakenImageService, IInterface(ImageService)) then
  begin
    TakePhotoFromLibraryAction1.Execute;
    exit;
  end;
{$IF Defined(MSWINDOWS)}
  // we load from a file...
  OpenDialog1.Filter := 'All supported files (*.jpg;*.png)|*.JPG;*.PNG|JPEG Images (*.jpg)|*.JPG|PNG Images (*.png)|*.PNG';
  if OpenDialog1.Execute then
  begin
    // We try load it...
    if FileExists(OpenDialog1.FileName) then
    begin
      try
        imgMainphoto.Bitmap.LoadFromFile(OpenDialog1.FileName);
        SavePhoto(job.Jobno, CurrentImageTag, imgMainphoto.Bitmap);
        FThumbs[CurrentImageTag].Bitmap.Assign(imgMainphoto.Bitmap);// display the THUMBNAIL version!
      except
        on E: Exception do
        begin
          ShowException('LoadFromLibraryClick', E);
        end;
      end;
    end;
  end;
{$ENDIF}
end;


procedure TJobForm.ShowPictureClick(Sender: TObject);
begin
  UnselectThumbFill();
  CurrentImageTag := TComponent(Sender).Tag;
  FRects[CurrentImageTag].Fill.Color := TAlphaColors.Lightskyblue;
  imgMainphoto.Bitmap.Assign(FThumbs[CurrentImageTag].Bitmap);
end;



procedure TJobForm.ShowJobPhotos();
begin
  ClearDisplayedPhotos();
  try
    qryJobphotos.Open(Format('SELECT photo, photono FROM jobs_photos WHERE jobno = %d ORDER BY photono LIMIT 6', [job.Jobno]));
    while not qryJobphotos.Eof do
    begin
      if not (qryJobphotos.FieldByName('photo') as TBlobField).IsNull then
        FThumbs[qryJobphotos.FieldByName('photono').AsInteger].Bitmap.Assign((qryJobphotos.FieldByName('photo') as TBlobField));
      qryJobphotos.Next;
    end;
  finally
    qryJobphotos.Close;
  end;
end;

procedure TJobForm.ClearDisplayedPhotos();
begin
  UnselectThumbFill();
  imgMainphoto.Bitmap := nil;
  for var I := 1 to 6 do
    FThumbs[I].Bitmap := nil;
end;


procedure TJobForm.DeleteJobphoto(const AJobno, APhoto: integer);
begin
  try
    DM.FDlocal.ExecSQL('UPDATE jobs_photos SET photo=NULL WHERE jobno=:p1 AND photono=:p2;', [AJobno, APhoto]);
    FThumbs[APhoto].Bitmap := nil;
    imgMainphoto.Bitmap := nil;
  except
    on E: Exception do
    begin
      ShowException('DeleteJobPhoto', E);
    end;
  end;
end;

procedure TJobForm.DeletePictureClick(Sender: TObject);
var
  Index: integer;
  Thumb: TImage;
  Rect: TRectangle;
begin
  Index := TComponent(Sender).Tag;
  Thumb := FThumbs[Index];
  Rect := FRects[Index];
  UnselectThumbFill();
  Rect.Fill.Color := TAlphaColors.Lightskyblue;
  imgMainphoto.Bitmap.Assign(Thumb.Bitmap);
  if Thumb.Bitmap.IsEmpty then
    exit;
  var MSG := 'Do you really want to delete the selected job photograph ?';
  TDialogService.MessageDialog(MSG, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure (const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          try
            DeleteJobphoto(job.Jobno, Index);
            ShowJobPhotos();
          except
            on E: Exception do
            begin
              ShowException('DeletePicture', E);
            end;
          end;
        end;
      end);
end;

end.
