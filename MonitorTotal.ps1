Param(
    [ValidateSet("CommittedBytesInUse", "AvailableKBytes", "ProcessorTime")][string[]] $MonitorList = @("CommittedBytesInUse", "AvailableKBytes", "ProcessorTime"),
    [int] $Interval = 1,
    [ValidateSet("Continue", "SilentlyContinue", "Stop")][string] $ErrorAction_ = "Continue",
    [string] $TimeStampFormat = "MM/dd/yyyy HH:mm:ss",
    [switch] $SkipHeader = $false
)

$CounterHash = @{
    CommittedBytesInUse = "\memory\% committed bytes in use";
    AvailableKBytes = "\Memory\Available KBytes";
    ProcessorTime = "\Processor(_Total)\% processor time";
}

if (-not $SkipHeader) {
    $headerInfo = $MonitorList -join ","
    $header = "TimeStamp," + $headerInfo
    echo $header
}

while($true)
{
    Get-Counter -ListSet Processor | Out-Null
    Get-Counter -ListSet memory | Out-Null

    $timestamp = (Get-Date).ToString($TimeStampFormat)
    $info = (
        $MonitorList |
        %{Get-Counter $($CounterHash[$_]) -ErrorAction $ErrorAction_} |
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
