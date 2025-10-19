object DM: TDM
  OnCreate = DataModuleCreate
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object FDlocal: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DateTimeFormat=DateTime'
      'SQLiteAdvanced=auto_vacuum=FULL'
      'StringFormat=Unicode'
      
        'Database=G:\RAD\Projects\WorkSheetManager\DataBase\WorksheetV1.s' +
        'db'
      'DriverID=SQLite')
    Left = 144
    Top = 208
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 552
    Top = 64
  end
  object FDGUIxErrorDialog1: TFDGUIxErrorDialog
    Provider = 'FMX'
    Left = 400
    Top = 64
  end
  object FDQuery1: TFDQuery
    Connection = FDlocal
    Left = 480
    Top = 360
  end
end
