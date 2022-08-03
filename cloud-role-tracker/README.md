# Role Finder Script

## Step 1   
Make sure this script is run `. .\RoleTracker.ps1` with dot sourcing inside the Role-Tracking folder.  

## Step 2  
Run `CLS-RoleFinder -Subscription '<>' -ScopeLevel <>`  
> Options:  
Subscription examples: 'LAB', '<Subscription> PRD', 'ALL'  
ScopeLevel examples: 'Subscription','ResourceGroup','Resource', 'ALL'

## Step 3 
Run `combineReport` to combine all the csv files created in c:\\temp

## Step 4 (Add data in app.csv) (Instructions if needed to redo)
Add all the service principles from the combined csv to the `app.ps1` script. Then run `appName`.  
This generates a csv with with sp id and human readable app.  
Use the generated csv from the app script and and use vlookup to change the sp ids to app names on the combined csv. 
