<#
.Synopsis
Bulk software installation script to load a pre-defined set of software for new deployments.
.DESCRIPTION
This script is designed to be used as part of a WDS/MDT deployment, to install software onto a new deployment of a Windows system.
The primary purpose for this script is to avoid having to manually load software onto the WDS server and to leverage
existing software repository infrastructure. The script loads the networked install directory in the form of a temporary drive,
loads a software list, and runs the install.ps1 script located in each product directory. This script can be added as part
of a task sequence once the new asset is joined to the domain.
#>

# We can replace the drive letter with whatever we want, as long as it's not L
$driveLetter = 'Z'
$networkPath = '\\server\share'

# Create a PSDrive to map to the network share
try {
    New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $networkPath -Persist -ErrorAction Stop
} catch {
    Write-Error "Failed to create PSDrive: $_"
    exit 1
}

# Define a list of software to install with vendor and product names
$softwareList = @(
    "Vendor1\Product1",
    "Vendor1\Product2",
    "Vendor2\Product1"
    # Add more software entries as needed
)

# Iterate through the list and install each software
foreach ($software in $softwareList) {
    $softwareFolderPath = Join-Path -Path "${driveLetter}:\installs" -ChildPath $software

    # Check if the folder exists before attempting to install
    if (Test-Path $softwareFolderPath) {
        try {
            # Navigate to the folder on the network share and run the install script
            Set-Location -Path $softwareFolderPath -ErrorAction Stop
            Start-Process -FilePath 'powershell.exe' -ArgumentList "-File .\install.ps1" -Wait -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to install ${software}: $_"
            continue 
        }
    } else {
        Write-Warning "Folder for ${software} not found."
    }
}

# Remove the PSDrive when done
try {
    Remove-PSDrive -Name $driveLetter -ErrorAction Stop
}
catch {
    Write-Error "Failed to remove PSDrive: $_"
    exit 1
}