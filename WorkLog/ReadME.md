\# WorkSheetManager



🗓️ \*\*WorkLog\*\*  

📅 Date: 19/10/2025



\## Project Setup



\- Created a new \*\*multi-device Delphi application\*\*.

\- Renamed the main form to `MainForm` and saved the unit as `uMainForm.pas`.

\- Saved the application project as `WorkSheets.dproj`.

\- Removed \*\*32-bit target platforms\*\* from the project group.

\- Enabled \*\*Skia graphics engine\*\* via the Projects window.



\## Data Module Configuration



\- Added a \*\*DataModule\*\*, named it `DM`, and saved it as `uDataModule.pas`.

\- In Project Options, set `DM` as the \*\*top form\*\* in the AutoCreate list.

\- Used `File > Use Unit` in `MainForm` to link the DataModule and added it to the interface section.



\## FDConnection Setup



\- Added a `TFDConnection` component to the DataModule and renamed it to `FDlocal`.

\- Enabled GUI error dialog and wait cursor for better user feedback.

\- Configured the connection for \*\*SQLite\*\* with the following settings:

&nbsp; - `DriverID`: `SQLite`

&nbsp; - `OpenMode`: `CreateUTF8`

&nbsp; - `LockingMode`: `Normal` (for multithreaded access)

&nbsp; - `DateTimeFormat`: `Delphi DateTime` (compatible with MySQL and SQLite)

&nbsp; - `SQLiteAdvanced`: `auto\_vacuum=FULL`

&nbsp; - `StringFormat`: `Unicode`



\## Platform-Specific Database Initialization



\- Defined a `homeFolder` path for storing the database, depending on the platform (primarily Windows for testing).

\- If the folder doesn't exist, it is created automatically.

\- If the database file is missing:

&nbsp; - It is created using a predefined constant for the database schema.

&nbsp; - The connection is opened.

&nbsp; - The `SQL\_CUSTOMERS` constant is executed to define the `customers` table.





