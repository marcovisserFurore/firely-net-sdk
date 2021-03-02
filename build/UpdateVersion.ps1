Param(
  [string]$propFile,
  [string]$newVersion,
  [string]$suffix
)

$xml = [xml](get-content $propFile)

# newVersion is not set, so getting it from the fhir-net-api.props
If ([string]::IsNullOrEmpty($newVersion)) 
{
	#Get the version (without suffix)
	$newVersion = $xml.Project.PropertyGroup.VersionPrefix
}

# suffix is not set, so getting it from the fhir-net-api.props
If ([string]::IsNullOrEmpty($suffix)) 
{
	$suffix = $xml.Project.PropertyGroup.VersionSuffix
}
	
Write-Host "Replacing version information with version: [$newVersion] suffix: [$suffix]" 

#Replacing the version and suffix
(Get-Content $propFile) |
    Foreach-Object { $_ `
        -replace "<VersionPrefix>.*</VersionPrefix>", "<VersionPrefix>$newVersion</VersionPrefix>" `
        -replace "<VersionSuffix>.*</VersionSuffix>", "<VersionSuffix>$suffix</VersionSuffix>" `
    } |
    Set-Content $propFile