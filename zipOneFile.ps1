Param(
	[parameter(mandatory=$true)][string] $path
)

$dstPath = ""

if ($path.IndexOf(".") -eq -1) {
    $dstPath = $path + ".zip"
} else {
    $ex = "." + $path.Split(".")[-1]
    $dstPath = ($path -replace $ex,".zip")
}

Compress-Archive $path -DestinationPath $dstPath
