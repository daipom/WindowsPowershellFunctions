Param(
	[parameter(mandatory=$true)][string] $NewFilePath,
	[parameter(mandatory=$true)][string] $OldFilePath
)

$new = cat $NewFilePath -encoding UTF8
$old = cat $OldFilePath -encoding UTF8

diff $new $old
