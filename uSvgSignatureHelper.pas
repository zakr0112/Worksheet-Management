unit uSvgSignatureHelper;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.IOUtils,
  FMX.Graphics, FMX.Skia, Skia, Xml.XMLDoc, Xml.XMLIntf;

procedure ExportSignatureAsPNG(const ASvgSource: string; const ASignatureFilename: string);

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

end.

