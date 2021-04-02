Param(
	[parameter(mandatory=$true)][string] $Path,
	[string] $RegExpToExtractTime = "^([0-9\-]+ [0-9\:]+)\..*$",
	[string] $StartTime = "",
	[string] $EndTime = ""
)

sls $RegExpToExtractTime $Path | ?{
	$dt = [DateTime]$_.Matches.Groups[1].Value;
	($dt -ge [DateTime]$StartTime) -and ($dt -le [DateTime]$EndTime)
} | %{$_.Line}
