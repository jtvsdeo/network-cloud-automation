

#Import Role Finder Script
Import-Module '.\RoleFinder\RoleFinder.ps1' -force

#Import Report Creator Script
Import-Module '.\ReportCreator\ReportCreator.ps1' -force

#Import Combining CSV Script
Import-Module '.\userFriendly\combineReport.ps1' -force

Import-Module '.\userFriendly\app.ps1' -force

Write-Host "`nPlease open this script with Dot-Sourcing (Ex: . .\RoleTracker.ps1) if not already done so.`n"