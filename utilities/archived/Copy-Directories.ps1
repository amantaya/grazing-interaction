Param(
		[parameter(Mandatory = $true)] [string] $Source,
		[parameter(Mandatory = $true)] [string] $Destination
	)
	
Copy-Item -Path $Source -Recurse -Destination $Destination -verbose