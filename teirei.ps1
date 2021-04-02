param(
    [ValidateSet("report", "timepro", "timepro_apply")][string] $purpose = "report",
    [ValidateSet("Normal", "Old")][string] $mode = "Normal",
    [string] $startdate = "",
    [string] $enddate = "",
    [string] $filePath = ""
)

$token = ""
$neoScript = ""

if ($mode -eq "Normal") {
    # use Mr.Hashida's script
    if ($startdate -ne "" -and $enddate -ne "") {
        if ($purpose -eq "report") {
            &$neoScript $purpose --token $token --start_date $startdate --end_date $enddate
        } else {
            $account = Get-Credential -Message "Input your TimePro account." 
            &$neoScript $purpose --token $token --start_date $startdate --end_date $enddate --timepro_user $account.UserName --timepro_password $account.GetNetworkCredential().Password
        }
        &$neoScript $purpose --token $token --start_date $startdate --end_date $enddate
    } else {
        if ($purpose -eq "report") {
            &$neoScript $purpose --token $token
        } else {
            $account = Get-Credential -Message "Input your TimePro account." 
            &$neoScript $purpose --token $token --timepro_user $account.UserName --timepro_password $account.GetNetworkCredential().Password
        }
    }
} else {
    # old my script
    $entireData = Import-Csv $filePath -Encoding default

    $today = Get-Date
    $today_date = [System.Convert]::ToInt32($today.DayOfWeek)
    $lastFriday = $today.AddDays(- $today_date - 2)

    echo ""
    echo("Extracted: " + $lastFriday.Date + " ~ " + $today.Date)
    echo ""

    $targetData = $entireData | ?{ [DateTime]$_.date -ge $lastFriday.Date -and [DateTime]$_.date -le $today.Date }

    $projectHash = @{}

    $targetData | %{
        if (-not $projectHash.ContainsKey($_.project)) {
            $projectHash.Add($_.project, 0)
        }
    }

    $projectHash.Keys | %{
        $projectName = $_
        echo("[" + $projectName + "]")
        echo ""
        $hash = @{}
        $targetData | ?{$projectName -eq $_.project -and $_."spent time" -ne 0} | %{
            if (-not $hash.ContainsKey($_.ticket)) {
                $hash.Add($_.ticket, 0)
            }
            $hash[$_.ticket] += $_."spent time"
        }
        $hash.Keys | %{
             "* " + $_ + " : " + $hash[$_] + "h"
             "** "
        }
        echo ""
    }

    $statistics = $targetData | Measure-Object "spent time" -Sum
    echo("Sum: " + $statistics.Sum + "h")
    echo ""
}


