Param(
    [string] $ProcessName,
    [int] $Interval = 5,
    [ValidateSet("Continue", "SilentlyContinue", "Stop")][string] $ErrorAction = "Continue"
)

while(1)
{
    Get-Counter -ListSet Process | Out-Null
    
    $counter = Get-Counter "\Process($ProcessName)\Working Set - Private" -ErrorAction $ErrorAction

    if ($counter -ne $null) {
        $line = "" + $counter.Timestamp + "," + $counter.CounterSamples.CookedValue
        echo $line
    }
    
    Start-Sleep -seconds $Interval
}

#(Get-Counter "\Process(ace_host)\Working Set").CounterSamples
#(Get-Counter "\Process(ace_host)\Private Bytes").CounterSamples
#(Get-Counter "\Process(alsdb)\Working Set - Private").CounterSamples
#(Get-Counter "\Process(alsdb)\Working Set").CounterSamples
#(Get-Counter "\Process(alsdb)\Private Bytes").CounterSamples