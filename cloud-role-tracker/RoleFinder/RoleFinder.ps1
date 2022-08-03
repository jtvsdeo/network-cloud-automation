#Find Access Role at Subscription, Resource Group or Resource Level
function CLS-RoleFinder{

    <#
        .SYNOPSIS
        Find User, Group or Service Principal Roles at Subscription, Resource Group or Resource Level.

        .DESCRIPTION
        Easily find Roles assigned to Users, Groups and Service Principals at
        Subscription, Resource Group or Resource level
        
        Input at which level to get Name, Role and Role type at each level, excluding
        inherited roles.

        .INPUTS
        Subscription (examples: 'LAB', 'MBU PRD')
        ScopeLevel ('Subscription','ResourceGroup','Resource')

        .EXAMPLE
        C:\PS> CLS-RoleFinder -Subscription 'LAB' -ScopeLevel Subscription
        C:\PS> CLS-RoleFinder -Subscription '<subscription> LAB' -ScopeLevel Resource

    #>
    
#Get parameters from user, Subscription(Does not have to be exact match) and ScopeLevel mandatory.
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $Subscription,
        [Parameter(Mandatory)]
        [ValidateSet('Subscription','ResourceGroup','Resource', 'ALL',IgnoreCase)]
        [String] $ScopeLevel       
    )

        switch($ScopeLevel){
            'Subscription'{.Subscription($Subscription)}
            'ResourceGroup'{.RG($Subscription)}
            'Resource'{.Resource($Subscription)}
            'ALL'{.Subscription($Subscription)}
            'ALL'{.RG($Subscription)}
            'ALL'{.Resource($Subscription)}
        }
}

#Retrieve roles at subscription level that match subscription scope provided.
function .Subscription($SubscriptionMatch){
    
    #Iterate through each subscription scope provided and save the information as a report
    $report = @()

    $subscriptions = ((az account list --all) | ConvertFrom-Json).name
    if ($SubscriptionMatch -ne "ALL") {
        $subscriptions = $subscriptions | Where {$_ -Match $SubscriptionMatch}
    }
    

    foreach($sub in $subscriptions){
    
        $roles = (az role assignment list --subscription $sub) | ConvertFrom-Json

        foreach ($role in $roles){
            $info = "" | Select-Object Name,  RoleType,  RoleName, Subscription
            $info.Subscription = $sub
            $info.RoleName = $role.roleDefinitionName
            $info.Name = $role.principalName
            $info.RoleType = $role.principalType
           
            
            $report += $info
        }
    
    }

    #Create a report by calling .report function
    .report("Subscription Level Access")
}


#Retrieve roles at ResourceGroup Level that match subscription scope provided.
function .RG($SubscriptionMatch){
    
    #Iterate through each subscription scope provided and save the information as a report
    $report = @()

    $subscriptions = ((az account list --all) | ConvertFrom-Json).name
    if ($SubscriptionMatch -ne "ALL") {
        $subscriptions = $subscriptions | Where {$_ -Match $SubscriptionMatch}
    }

    foreach($sub in $subscriptions){
        
        $roles = (az role assignment list --all --subscription $sub) | ConvertFrom-Json

        $roles = $roles | where {$_.resourceGroup -ne $null -and $_.scope.Split('/')[5] -eq $null}

        foreach ($role in $roles){
            $info = "" | Select-Object Name, RoleType, RoleName, Subscription,  ResourceGroup
            $info.RoleName = $role.roleDefinitionName
            $info.Name = $role.principalName
            $info.RoleType = $role.principalType
            
            $info.ResourceGroup = $role.resourceGroup
            $info.Subscription = $sub

            $report += $info
        }
    }
    #Create a report by calling .report function
    .report("ResourceGroup Level Access")
}

#Retrieve roles at Resource Level that match subscription scope provided.
function .Resource($SubscriptionMatch){

    #Iterate through each subscription scope provided and save the information as a report
    $report = @()

    $subscriptions = ((az account list --all) | ConvertFrom-Json).name
    if ($SubscriptionMatch -ne "ALL") {
        $subscriptions = $subscriptions | Where {$_ -Match $SubscriptionMatch}
    }

    foreach($sub in $subscriptions){
    
        $roles = (az role assignment list --all --subscription $sub) | ConvertFrom-Json

        $roles = $roles | where {$_.scope.Split('/')[5] -ne $null}

        foreach ($role in $roles){
            $info = "" | Select-Object  Name, RoleType, RoleName,  Subscription, ResourceGroup, ResourceName, Scope
            $info.Subscription = $sub
            $info.RoleName = $role.roleDefinitionName
            $info.Name = $role.principalName
            $info.RoleType = $role.principalType
            $info.ResourceGroup = $role.resourceGroup
            $info.ResourceName = $role.scope.Split('/')[8]
            $info.Scope = $role.scope

            $report += $info
        }   
    }
    #Create a report by calling .report function
    .report("Resource Level Access")
}

    #Report Creator
    function .report ($reportName){

        #Get a list of how many Users, Groups and Service Principal are there.
        $UserCount = ($report.RoleType | Where-Object {$_ -eq "User"}).Count
        $GroupCount = ($report.RoleType | Where-Object {$_ -eq "Group"}).Count
        $SPCount = ($report.RoleType | Where-Object {$_ -eq "ServicePrincipal"}).Count

        Write-Host "`nThere are currently $UserCount User roles, $GroupCount Group roles, and $SPCount Service Principal roles which match the given Subscription(s)"
        #Write-Host "How would you like to view the report?"
        
        #Create report
        report($reportName)
    }
