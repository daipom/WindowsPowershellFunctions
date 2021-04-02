Param(
    [parameter(mandatory=$true)][string] $path
)

$dstPath = ""

if ($path.IndexOf(".") -eq -1) {
    $dstPath = $path + "_expanded"
} else {
    $ex = "." + $path.Split(".")[-1]
    $dstPath = ($path -replace $ex,"")
}

Expand-Archive $path -DestinationPath $dstPath
mv "$dstPath\*" .\tmp
rm $dstPath
mv tmp $dstPath

