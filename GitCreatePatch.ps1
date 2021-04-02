Param(
    [parameter(mandatory=$true)][int] $TicketNum="",
    [parameter(mandatory=$true)][int] $PatchNum=""
)

if ($env:Patch_Root -eq $null) {
    echo "Patch root path is not set."
    return
}

if (-not (Test-Path $env:Patch_Root)) {
    echo "Patch root path does not exist. [path: ${env:Patch_Root}]"
    return
}

git diff | Out-File ${env:Patch_Root}\${TicketNum}\#${TicketNum}_${PatchNum}.patch -Encoding utf8
