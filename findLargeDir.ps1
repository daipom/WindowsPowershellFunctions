ls -Directory |
  %{ [PSCustomObject]@{"Length"=getDirSize.ps1 $_.Name; "Name"=$_.Name;} } |
  ?{$_.Length -gt 1} |
  sort -Property Length -Descending
