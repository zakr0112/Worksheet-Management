<h1 align="center">Worksheet Management Application</h1>

<p align="center">
  <img src="https://github.com/zakr0112/Worksheet-Management/blob/main/WorkLog/16%2001%202026/WorksheetOptions.png" alt="Description" width="400">
  <br>
  <em>Worksheet Manager App</em>
</p>

<p align="center">

|  |  |  |
|:---:|:---:|:---:|
| <img src="https://github.com/zakr0112/Worksheet-Management/blob/main/WorkLog/16%2001%202026/WorksheetJobManagement.png" width="300"> | <img src="https://github.com/zakr0112/Worksheet-Management/blob/main/WorkLog/16%2001%202026/WorksheetNewJob.png" width="300"> | <img src="https://github.com/zakr0112/Worksheet-Management/blob/main/WorkLog/16%2001%202026/WorksheetCustomers.png" width="300"> |
| <em>Job Management</em> | <em>New Job System</em> | <em>Customer List</em> |

</p>


---

## Application Features

### Job Records
- Create, edit, and update job entries  
- Store job type, dates, customer details, work completed, remedial notes, and engineer names  
- Each job automatically records a “last changed” timestamp
- When a job is created, you can either add the customer to the database or leave it for one-off situations

### Customer Management
- Searchable Customer list 
- Option to add a new customer on the fly if it doesn’t already exist  

### Time Logging
- Record travel time, arrival time, departure time, and mileage  
- Handles empty or partial time entries safely  
- Calculates job time, travel time, and total time automatically  

### Expenses & Spare Parts
- Add expenses with validation for cost and date  
- Add spare parts with quantity checks  

### Cross‑Platform UI
- FMX interface designed for both desktop and mobile  
- Uses native Android dialogs for confirmations  
- Displays a “last changed” indicator in the toolbar  

---

## Technology

- Delphi 12.3 (FMX)
- Delphi 13 (Android Keystore)
- FireDAC (SQLite)
- SQLite local database
- Manager‑style classes for Jobs, Customers, and related data

---

## 1. Open the Project

1. Open **Delphi 12.3**.  
2. Open the project folder.  
3. Load the main project file:

   ```text
   JobManagerApp.dproj
   ```



## 2. Configure the SQLite Database

1. Locate (or create) the database file.  
   - Default path:

     ```text
     data/jobs.db
    

2. If `jobs.db` does **not** exist:
   - Either allow the app to create a new database on first run (if your setup supports this), **or**  
   - Copy an existing `jobs.db` file into the `data` folder.

3. Open the **DataModule** unit:

   ```text
   uDM.pas


4. Check the **FireDAC** connection settings on the `TFDConnection` component:
   - Ensure it points to the correct **SQLite** file (`jobs.db`).  
   - Confirm that `DriverID` is set to:

     ```text
     SQLite


   - Verify that the database path is valid for your current target platform (Windows or Android).



## 3. Run the App on Windows

1. In Delphi, select the **Windows 64‑bit** target platform.  
2. Press **F9** to build and run the application.



## 4. Run the App on Android

1. Connect an Android device **or** start an Android emulator.  
2. In Delphi, switch the target platform to **Android**.  
3. Press **F9** to build and deploy the app to the device/emulator.



## 5. Using the Application

Once the application is running, you can:

1. Create new **jobs**.  
2. Add or select **customers**.  
3. Log **time** and **travel** entries for each job.  
4. Record **expenses** and **spare parts** used.  
5. Store all data directly in the local **SQLite** database (`data/jobs.db`).
