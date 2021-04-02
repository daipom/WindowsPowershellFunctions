Param(
    [parameter(mandatory=$true)][string] $Path,
    [int] $Interval = 60,
    [ValidateSet("Continue", "SilentlyContinue", "Stop")][string] $ErrorAction_ = "Continue",
    [string] $TimeStampFormat = "MM/dd/yyyy HH:mm:ss",
    [switch] $SkipHeader = $false
)

class Record
{
    [string] $Timestamp
    [string] $SizeByte

    Record([string]$Path, [string]$TimeStampFormat, [string]$ErrorAction_){
        $this.Timestamp = Get-Date -Format $TimeStampFormat
        $fileList = ls $Path -Recurse
        if ($fileList.Count -eq 1) {
            $this.SizeByte = (ls $Path -ErrorAction $ErrorAction_ -Recurse).Length
        } else {
            $this.SizeByte = (ls $Path -ErrorAction $ErrorAction_ -Recurse | Measure-Object Length -Sum).Sum
        }
    }
}

if (-not $SkipHeader) {
    $record = New-Object Record($Path, $TimeStampFormat, $ErrorAction_)
    echo (ConvertTo-Csv $record -NoTypeInformation)
    Start-Sleep -seconds $Interval
}

while($true)
{
    $record = New-Object Record($Path, $TimeStampFormat, $ErrorAction_)

    echo (ConvertTo-Csv $record -NoTypeInformation)[1]

    Start-Sleep -seconds $Interval
}