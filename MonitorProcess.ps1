Param(
    [parameter(mandatory=$true)][string] $ProcessName,
    [ValidateSet("WorkingSetPrivate", "VirtualBytes", "PrivateBytes", "WorkingSet", "ProcessorTime", "HandleCount")][string[]] $MonitorList = @("WorkingSetPrivate"),
    [int] $Interval = 1,
    [ValidateSet("Continue", "SilentlyContinue", "Stop")][string] $ErrorAction_ = "Continue",
    [string] $TimeStampFormat = "MM/dd/yyyy HH:mm:ss",
    [switch] $SkipHeader = $false
)

$CounterHash = @{
    WorkingSetPrivate = "working set - private";
    VirtualBytes = "virtual bytes";
    PrivateBytes = "private bytes";
    WorkingSet = "working set";
    ProcessorTime = "% processor time";
    HandleCount = "Handle Count"
}

if (-not $SkipHeader) {
    $headerInfo = $MonitorList -join ","
    $header = "TimeStamp," + $headerInfo
    echo $header
}

while($true)
{
    Get-Counter -ListSet Process | Out-Null

    $timestamp = (Get-Date).ToString($TimeStampFormat)
    $info = (
        $MonitorList |
        %{Get-Counter "\Process($ProcessName)\$($CounterHash[$_])" -ErrorAction $ErrorAction_} |
        % {
            try {
                $_.CounterSamples.CookedValue
            }
            catch [Exception]
            {
                "Error"
            } 
        }
    ) -join ","

    $line = "" + $timestamp + "," + $info
    echo $line

    Start-Sleep -seconds $Interval
}
