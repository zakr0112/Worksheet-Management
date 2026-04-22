// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 14.04.2026
// -----------------------------------------------------------------------------

unit uCommonUTF8Helper;

interface

uses
  System.Classes, System.SysUtils, System.Math, System.IOUtils, System.Types, System.StrUtils;

function StrictSanitiseInput(const ASource: string; AReplacechar: char = chr(32)): string;
function SanitiseInput(const ASource: string): string;
function ReplaceWeirdChars(const ASource: string): string;

implementation

function StrictSanitiseInput(const ASource: string; AReplacechar: char = chr(32)): string;
const
  AllowedChars = ' (){}[]:<>@-~#%&!0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
begin
  var wrk := Trim(ASource);
  var OutputStr := wrk;  // Initialize the output string with the input string
  for var I := 1 to Length(wrk) do
  begin
    if Pos(wrk[I], AllowedChars) = 0 then
    begin
      OutputStr[I] := AReplacechar;
    end;
  end;
  Result := Trim(OutputStr);
end;

function SanitiseInput(const ASource: string): string;
const
  ReplaceMap: array[0..15, 0..1] of string = (
    ('‚Äô', ''''),    // Apostrophe-like character
    ('í', ''''),      // Apostrophe-like character
    ('‚Äò', ''''),    // Left single quotation mark
    ('ë', ''''),      // Left single quotation mark
    ('‚Äú', ''''),    // Left double quotation mark
    ('ì', ''''),      // Left double quotation mark
    ('‚Ä¶', '-'),     // Ellipsis
    ('‚Äù', ''''),    // Left single quotation mark
    (chr(34), '-'),   // Double quote
    (chr(39), '-'),   // Single quote
    (chr(44), '-'),   // Comma
    (chr(96), '-'),   // Grave accent
    (chr(150), '-'),  // En dash
    (chr(151), '-'),  // Em dash
    (chr(157), ' '),  // Special character, replaced with space
    (chr(158), ' ')  // Special character, replaced with space
  );
var
  i: Integer;
  wrk: string;
begin
  wrk := Trim(ASource);
  for i := Low(ReplaceMap) to High(ReplaceMap) do
    wrk := ReplaceText(wrk, ReplaceMap[i, 0], ReplaceMap[i, 1]);
  Result := Trim(ReplaceText(wrk, chr(160), ' ')); // Replace non-breaking space at the end
end;

function ReplaceWeirdChars(const ASource: string): string;
const
  ReplaceMap: array[0..6, 0..1] of string = (
    (chr(96), '-'), // Grave accent
    (chr(150), '-'), // En dash
    (chr(151), '-'), // Em dash
    ('í', ''''), // Apostrophe-like character
    ('ì', ''''), // Left double quotation mark
    ('Ö', '-'),   // Ellipsis
    ('ë', '''')   // Left single quotation mark
  );
var
  i: Integer;
  wrk: string;
begin
  wrk := Trim(ASource);
  for i := Low(ReplaceMap) to High(ReplaceMap) do
    wrk := ReplaceText(wrk, ReplaceMap[i, 0], ReplaceMap[i, 1]);
  Result := wrk;
end;

end.
