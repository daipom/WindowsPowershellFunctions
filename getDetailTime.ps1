param($path)

$a = Get-ItemProperty $path
echo "CreationTime"
$a.CreationTime.ToString("yyyy/MM/dd HH:mm:ss.fffffff")
echo "LastWriteTime"
$a.LastWriteTime.ToString("yyyy/MM/dd HH:mm:ss.fffffff")
echo "LastAccessTime"
$a.LastAccessTime.ToString("yyyy/MM/dd HH:mm:ss.fffffff")