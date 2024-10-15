workflow AutoStart-VM {
    param (
        [string]$vmName = 'YourVMName',
        [string]$resourceGroupName = 'Your-ResourceGroup',
        [string]$startTime = '08:00:00'
    )

    # Authenticate with Azure using the Run As Account
    $ServicePrincipalConnection = Get-AutomationConnection -Name 'AzureRunAsConnection'
    try {
        Connect-AzAccount -ServicePrincipal -TenantId $ServicePrincipalConnection.TenantId `
                          -ApplicationId $ServicePrincipalConnection.ApplicationId `
                          -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint
        Write-Output "Successfully authenticated with Azure."
    }
    catch {
        Write-Error "Failed to authenticate with Azure. Please check the Azure Run As Account configuration."
        return
    }

    # Ensure the subscription context is correctly set
    try {
        # List available subscriptions
        $subscription = Get-AzSubscription | Where-Object { $_.State -eq 'Enabled' }

        # Set the subscription context (use the first enabled subscription)
        if ($subscription) {
            Set-AzContext -SubscriptionId $subscription.Id
            Write-Output "Subscription context set to: $($subscription.Name)"
        }
        else {
            Write-Error "No valid subscription found."
            return
        }
    }
    catch {
        Write-Error "Failed to set the Azure subscription context."
        return
    }

    # Start the VM
    Start-AzVM -Name $vmName -ResourceGroupName $resourceGroupName

    # Wait for the VM to reach the Running state using a loop with `Do-Until`
    Do {
        $vmStatus = Get-AzVM -Name $vmName -ResourceGroupName $resourceGroupName
        Write-Output "Current VM Status: $($vmStatus.Statuses[1].Code)"
        Start-Sleep -Seconds 30
    } Until ($vmStatus.Statuses[1].Code -eq 'PowerState/running')

    Write-Output "VM is now running."
}
