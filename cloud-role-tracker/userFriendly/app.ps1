function appName {
    $app = @('x',
            'x'
        )
        
        foreach($data in $app){    
            $response += az ad sp list --spn $data --query '[].{appId:appId, displayName:displayName}' | ConvertFrom-Json
           
        }
        $response | Export-Csv -Path c:\\temp\app.csv -NoTypeInformation
}

    
