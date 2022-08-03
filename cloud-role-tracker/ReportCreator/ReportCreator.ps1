function report ($name){
    
    #Style the HTML report with Colours
    $css = "<title>Files</title>
    <style>
    table {
        margin: auto;
        font-family: Arial;
        box-shadow: 10px 10px 5px #777;
        border: black;
    }
    th {
        background: #DA291C;
        color: #FFFFFF;
        max-width: 400px;
        padding: 5px 10px;
    }
    td {
        font-size: 10px;
        padding: 5px 20px;
        color: #111;
    }
    tr {
        background: #e8d2f3;
    }
    tr:nth-child(even) {
        background: #68CADA;
    }
    tr:nth-child(odd) {
        background: #BBE4EC;
    }
    </style>"

<#
    Write-Host "1. Show in Powershell Console"
    Write-Host "2. Create a HTML Report"
    Write-Host "3. Create a CSV Report"
    Write-Host "4. Exit"

$errormessage = "Invalid entry."
$selections = @("1","2","3", "4")

#>

#Convert report to a HTML file.
function returnHTMLReport{
    $report | ConvertTo-Html -Head $css | Out-File "c:\temp\$name.html"
    return "Report has been saved to c:\temp\$name.html"
}

#Convert report to a CSV file.
function returnCSVReport{
    $report | Export-Csv -NoTypeInformation -Path "c:\temp\$name.csv"
    return "Report has been saved to c:\temp\$name.csv"
}

# Ask the user how they would like the view the report
<# do {
    $userinput = Read-Host "Please Enter The Corresponding Number"
    switch($userinput) {
        1 { return $report }
        2 { return returnHTMLReport }
        3 { return returnCSVReport }
        4 { return "Exiting" }
        default { Write-Host $errormessage }
    }
} while ($userinput -notcontains $selections)
#>

# Hardcoded for the time being 
return returnCSVReport
}
