# NetworkShareInstaller
<h2>Description</h2>
This script is designed to be used as part of a WDS/MDT deployment, to install software onto a new deployment of a Windows system.
The primary purpose for this script is to avoid having to manually load software onto the WDS server and to leverage
existing software repository infrastructure. The script loads the networked install directory in the form of a temporary drive,
loads a software list, and runs the install.ps1 script located in each product directory. This script can be added as part
of a task sequence once the new asset is joined to the domain.

<h2>Notes</h2>
This is a neutral, baseline form of the script. To function properly, run this in an elevated (admin) PowerShell session. You will need to edit the script and make changes to the following variables to suit your specifc domain and user group needs. These are at the top of the script and are easy to adjust:

- $driveLetter
- $networkPath
- $softwareList

<h2>Requirements</h2>
The system must be able to run PowerShell scripts - verify the current execution policy via <code>Get-ExecutionPolicy</code> and temporarily change the policy using <code>Set-ExecutionPolicy Unrestricted</code>. Be sure to set the execution policy back to the original policy after the script is finished running.

The user account running the script must also have permissions to install new software onto the system. This includes any services accounts
you may be using as part of your deployment process.

