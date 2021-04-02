param(
    [ValidateSet("GetTicketNum", "OpenPatchDir", "SetTicketNum", "CreatePatch")][string] $mode = "GetTicketNum",
    [ValidateSet("git", "svn")][string] $type = "git"
)

$global:ticketNumFileName = ".ticketnum"

function getTicketNum {
    if (Test-Path($ticketNumFileName)) {
        cat $ticketNumFileName
    } else {
        echo "Not Set"
    }
}

function OpenPatchDir {
    if ($env:Patch_Root -eq $null) {
        echo "Patch root path is not set."
        return
    }

    if (-not (Test-Path $env:Patch_Root)) {
        echo "Patch root path does not exist. [path: ${env:Patch_Root}]"
        return
    }

    $ticketNum = getTicketNum

    if ($ticketNum -eq "Not Set") {
        echo "Not Set"
        return
    }

    $patchDirPath = "${env:Patch_Root}\${ticketNum}"

    if (-not (Test-Path $patchDirPath)) {
        mkdir $patchDirPath
    }

    ii $patchDirPath
}

function setTicketNum {
    $ticketNum = Read-Host -Prompt "ticket number"
    echo $ticketNum > $ticketNumFileName
}

function createPatch {
    $ticketNum = getTicketNum

    if ($ticketNum -eq "Not Set") {
        echo "Not Set"
        return
    }

    if (-not (Test-Path $env:Patch_Root)) {
        echo "Patch root path is not set or it does not exist. [path: ${env:Patch_Root}]"
        return
    }

    $patchDirPath = "${env:Patch_Root}\${ticketNum}"

    if (-not (Test-Path $patchDirPath)) {
        mkdir $patchDirPath
    }

    $maxPatchNum = 
    getFileNameList -Path $patchDirPath -Like "*.patch" | sls "^#${ticketNum}_(?<patchNum>[0-9].*).patch$" | %{
        [int]$_.Matches.Groups[1].Value
    } | Measure-Object -max | %{$_.Maximum}

    $newPatchNum = $maxPatchNum + 1

    if ($type -eq "git") {
        GitCreatePatch $ticketNum $newPatchNum
    } else {
        svnCreatePatch $ticketNum $newPatchNum
    }

    $newPatchNum
}

if ($mode -eq "GetTicketNum") {
    getTicketNum
    return
}

if ($mode -eq "OpenPatchDir") {
    OpenPatchDir
    return
}

if ($mode -eq "SetTicketNum") {
    setTicketNum
    return
}

if ($mode -eq "CreatePatch") {
    createPatch
    return
}
