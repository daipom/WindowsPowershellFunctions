param(
    [parameter(mandatory=$true)][string] $Path,
    [int] $SplitLineCount=100000,
    [string] $Encoding="UTF8"
    )

$i=0
cat $Path -ReadCount $SplitLineCount -Encoding $Encoding | % { Out-File split_$i.txt -InputObject $_ -Encoding $Encoding; $i++ }
