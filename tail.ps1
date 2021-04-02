Param(
    [parameter(mandatory=$true)][string] $filepath,
    [int] $count=40,
    [switch] $Wait
    )
if ($Wait) {
    cat $filepath -Tail $count -Wait -Encoding UTF8
}
else {
    cat $filepath -Tail $count -Encoding UTF8
}