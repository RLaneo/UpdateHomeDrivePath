Import-Module ActiveDirectory

# Set the name of the old server and the new server
$oldServer = "oldserver"
$newServer = "newserver"

# Set the name of the OU where the users are located
$ouName = "OU=Staff,OU=Users,DC=example,DC=com"

# Set the path and filename for the log file
$logFile = "C:\Scripts\UpdateHomeDrive-Building.log"

# Get a list of all users in the specified OU
$users = Get-ADUser -SearchBase $ouName -Filter * -Properties HomeDirectory

# Loop through each user
foreach ($user in $users) {
  # Get the user's current home drive mapping
  $homeDrive = $user.HomeDirectory

  # Check if the home drive is mapped to the old server
  if ($homeDrive -like "*$oldServer*") {
    # Replace the old server name with the new server name
    $newHomeDrive = $homeDrive -replace $oldServer,$newServer

    # Set the user's home drive mapping to the new server
    Set-ADUser -Identity $user.SamAccountName -HomeDirectory $newHomeDrive

    # Write a log entry for the user
    Add-Content -Path $logFile -Value "$(Get-Date -Format G): Updated home drive for user $($user.SamAccountName) from $homeDrive to $newHomeDrive"
  }
}
