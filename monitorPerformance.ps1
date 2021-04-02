Param(
    [parameter(mandatory=$true)][string] $ProcessName,
    [int] $Interval = 5,
    [switch] $isSkipHeader = $false
)

# $script:processName = ""

class Record
{
    [string] $Timestamp
    [string] $ProcessorTime
    [string] $CommittedBytesInUse
    [string] $ProcessProcessorTime
    [string] $ProcessWorkingSetPrivate
    [string] $ProcessVirtualBytes

    Record(){
        Get-Counter -ListSet Processor | Out-Null
        Get-Counter -ListSet memory | Out-Null
        Get-Counter -ListSet Process | Out-Null

        $counter = $this.GetCounter("\Processor(_Total)\% Processor Time")
        $this.Timestamp = $counter.Timestamp
        $this.ProcessorTime = $counter.CounterSamples.CookedValue.ToString("0.00")
        $this.CommittedBytesInUse = $this.GetCounterValue("\memory\% committed bytes in use")
        $this.ProcessProcessorTime = $this.GetCounterValue("\process($ProcessName)\% processor time")
        $this.ProcessWorkingSetPrivate = $this.GetCounterValue("\process($ProcessName)\working set - private")
        $this.ProcessVirtualBytes = $this.GetCounterValue("\process($ProcessName)\virtual bytes")
    }

    [Object] GetCounter([string]$counterName){
        return Get-Counter $counterName -ErrorAction "Continue"
    }

    [string] GetCounterValue([string]$counterName){
        try {
            return (Get-Counter $counterName -ErrorAction "Continue").CounterSamples.CookedValue.ToString("0.00")
        } catch [Exception] {
            return "Error"
        }
    }
}

if (-not $isSkipHeader) {
    $record = New-Object Record
    echo (ConvertTo-Csv $record -NoTypeInformation)
    Start-Sleep -seconds $Interval
}

while($true)
{
    $record = New-Object Record

    echo (ConvertTo-Csv $record -NoTypeInformation)[1]

    Start-Sleep -seconds $Interval
}
