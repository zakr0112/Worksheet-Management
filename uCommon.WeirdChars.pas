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
  ReplaceMap: array[0..11, 0..1] of string = (
    ('’', ''''),    // Apostrophe-like character
    ('‘', ''''),    // Left single quotation mark
    ('“', ''''),    // Left double quotation mark
    ('…', '-'),     // Ellipsis
    (chr(34), '-'),   // Double quote
    (chr(39), '-'),   // Single quote
    (chr(44), '-'),   // Comma
    (chr(96), '-'),   // Grave accent
    (chr(150), '-'),  // En dash
    (chr(151), '-'),  // Em dash
    (chr(157), ' '),  // Special character, replaced with space
    (chr(158), ' ')   // Special character, replaced with space
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
    ('’', ''''), // Apostrophe-like character
    ('“', ''''), // Left double quotation mark
    ('…', '-'),   // Ellipsis
    ('‘', '''')   // Left single quotation mark
  );
var
  i: Integer;
  wrk: string;
begin
  wrk := Trim(ASource);
  for i := Low(ReplaceMap) to High(ReplaceMap) do
    wrk := ReplaceText(wrk, ReplaceMap[i, 0], ReplaceMap[i, 1]);
  Result := wrk;
end