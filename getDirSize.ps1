Param(
    [string] $Path=""
)

$a = ls $Path -Recurse | ?{$_.Mode -notmatch "d"} | %{$_.Length} | measure -Sum
$a.Sum / 1000 / 1000 / 1000
