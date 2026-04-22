// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Changed 16.04.2026 Removed GetSeconds as only used in one place

unit uCommon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Notification, System.DateUtils,
  {$IF Defined(Android)}
    Androidapi.Jni.JavaTypes, Androidapi.Jni.Widget, Androidapi.Jni.App,
    Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers, Posix.Unistd,
  {$ENDIF}
  FMX.Controls, FMX.TabControl, FMX.DialogService, FMX.DialogService.Async, FMX.Types, FMX.ListBox,
  uCommonDialogs;

  procedure StyleListItem(AItem: TListBoxItem; const ASize: single; const AColour: TAlphaColor);
  procedure StyleComboBox(AComboBox: TComboBox; const ASize: single; const AColour: TAlphaColor);

implementation

procedure StyleListItem(AItem: TListBoxItem; const ASize: single; const AColour: TAlphaColor);
begin
  // Routine to change the default font size and colour of indiviudal items of a TListItem
  AItem.StyledSettings := [];
  AItem.Font.Size := ASize;
  AItem.FontColor := AColour;
  AItem.StyledSettings := AItem.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
end;

procedure StyleComboBox(AComboBox: TComboBox; const ASize: single; const AColour: TAlphaColor);
begin
  // Routine to change the default style and colour of all items of a TComboBox
  for var I := 0 to Pred(AComboBox.count) do
     StyleListItem(AComboBox.ListItems[I], ASize, AColour);
end;

procedure StyleListBox(AListBox: TListBox; const ASize: single; const AColour: TAlphaColor);
begin
  // Routine to change the default style and colour of all items of a TlistBox
  for var I := 0 to Pred(AListBox.count) do
    StyleListItem(AListBox.ListItems[I], ASize, AColour);
end;

end.
