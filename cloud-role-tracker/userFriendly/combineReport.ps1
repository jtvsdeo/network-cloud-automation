# This combines all the created csv files into one csv file.
function combineReport {
    cmd /c "copy c:\\temp\*.csv c:\\temp\combined-csv-files.csv"
    
}
