##Removes all Graph Modules from Azure Automation Accounts

Connect-AzAccount
$rg = read-host "Resource Group: "
$automationaccountname = read-host "Automation Account: "

##------------------------------Remove Graph from runtime version 7.2--------------------------------------------##
 $azmodules = get-azautomationmodule -resourcegroup $rg -AutomationAccountName $automationaccountname -runtime 7.2

 $badmod = $azmodules | where {$_.name -like "*graph*"} | select -ExpandProperty Name

 foreach ($ba in $badmod)
 {
    
    Remove-AzAutomationModule -ResourceGroupName $rg -AutomationAccountName $automationaccountname -Name $ba -runtime 7.2 -Force -Confirm:$false
    write-output "$ba is removed from runtime 7.2"
 }

##------------------------------Remove Graph from runtime version 5.1--------------------------------------------##
$azmodules = get-azautomationmodule -resourcegroup $rg -AutomationAccountName $automationaccountname -runtime 5.1

$badmod = $azmodules | where {$_.name -like "*graph*"} | select -ExpandProperty Name

foreach ($ba in $badmod)
{
   
   Remove-AzAutomationModule -ResourceGroupName $rg -AutomationAccountName $automationaccountname -Name $ba -runtime 5.1 -Force -Confirm:$false
   write-output "$ba is removed from runtime 5.1"
}

