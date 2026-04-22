// -----------------------------------------------------------------------------
// Copyright © 2025 - 2026 Zak Richards
//
// Last changed: 16.04.2026
// -----------------------------------------------------------------------------

// Bring the common functions for the report output (replaces uCommonPDFLauncher.pas)
//
// ExportSignatureAsPng
// secondstohuman

unit uReportHelper;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.IOUtils, System.Math,
  FMX.Graphics, FMX.Skia, Skia, Xml.XMLDoc, Xml.XMLIntf;

procedure ExportSignatureAsPNG(const ASvgSource: string; const ASignatureFilename: string);
function secondstohuman(ASeconds: Integer; ABlankforzero: boolean = false): string;

implementation

procedure ExportSignatureAsPNG(const ASvgSource: string; const ASignatureFilename: string);
var
  LBitmap: TBitmap;
begin
  LBitmap := TBitmap.Create(640, 200);
  try
    LBitmap.SkiaDraw(
      procedure (const ACanvas: ISkCanvas)
      var
        LSvgBrush: TSkSvgBrush;
      begin
        // Fill background (defaults to light cream green)
        ACanvas.Clear($FFFFFFFF);
        LSvgBrush := TSkSvgBrush.Create;
        try
          LSvgBrush.Source := ASvgSource;
          LSvgBrush.Render(ACanvas, RectF(0, 0, 640, 200), 1);
        finally
          LSvgBrush.Free;
        end;
      end
    );
    LBitmap.SaveToFile(ASignatureFilename);
  finally
    LBitmap.Free;
  end;
end;

function secondstohuman(ASeconds: Integer; ABlankforzero: boolean): string;
var
  Hours, Minutes: Integer;
begin
  Hours := Floor(ASeconds / 3600);
  Minutes := Floor((ASeconds mod 3600) / 60);
  Result := Format('%d:%2.2d', [Hours, Minutes]);
  if ABlankforzero then
  begin
    if Result = '0:00' then
     Result := '';
  end;
end;

end.

