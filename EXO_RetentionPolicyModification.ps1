# Let's get connected to Exchange Online
Connect-ExchangeOnline
# Let's get connected to the Security & Compliance Center
Connect-IPPSSession
# Getting a list of users with a mailbox | This can be any attribute found via Get-Recipient
$IntendedUsers = Get-Recipient -ResultSize Unlimited | select-object * | Where-Object CustomAttribute3 -eq "SpecialAttributeValue" | sort-object PrimarySmtpAddress
#List all of the current retention policies
Get-RetentionCompliancePolicy | Select-Object name,guid
# Declare the Intended policy you will be using
$IntendedPolicy='JustTesting'
#Get the expanded properties to give us a list of mailboxes the policy currently applies.
$CurrentPolicyUsers = Get-RetentionCompliancePolicy -Identity $IntendedPolicy -DistributionDetail | Select-Object -ExpandProperty ExchangeLocation | ForEach-Object {$_.Name} | sort-object $_.Name
# Let's compare the two arrays "IntendedUsers" and "CurrentPolicyUsers" users to add the users who have the custom attribute and aren't in the policy yet.
$NotInPolicy = $IntendedUsers.primarySmtpAddress | Where-Object {$CurrentPolicyUsers -NotContains $_}
ForEach ($user in $NotInPolicy) { Set-RetentionCompliancePolicy -Identity $IntendedPolicy -AddExchangeLocation $user }
