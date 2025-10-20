unit uCommon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.DialogService.Async, FMX.DialogService, FMX.Controls;

  procedure ShowWarning(const AMessage: string; Sender: TControl = nil);

implementation

procedure ShowWarning(const AMessage: string; Sender: TControl = nil);
begin
  TDialogService.MessageDialog(AMessage, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0,
        procedure (const AResult: TModalResult) begin
          if AResult = mrOK then
          begin
            // Process anything else you require here for android
          end;
        end);
end;

end.
