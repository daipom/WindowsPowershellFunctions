Param(
    [string] $Path="",
	[string] $Like="",
	[string] $NotLike="",
    [switch] $Recurse,
    [switch] $FullName
)

function getFileNames {
    Param (
        [Parameter(Mandatory=$true)] [bool] $Recurse
    )

    if ($Recurse) {
        ls $Path -Recurse | ?{ $_.Mode -notmatch "d" }
    }
    else {
        ls $Path | ?{ $_.Mode -notmatch "d" }
    }
}

function outputFileName {
    Param (
        [Parameter(Mandatory=$true)] [System.IO.FileInfo] $FileInfo,
        [Parameter(Mandatory=$true)] [bool] $FullName
    )

    if ($FullName) {
        $FileInfo.FullName
    }
    else {
        $FileInfo.Name
    }
}

if ($Like -ne "") {
	getFileNames -Recurse $Recurse | ?{ $_.Name -like $Like } | %{ outputFileName -FileInfo $_ -FullName $FullName }
}
elseif ($NotLike -ne "") {
	getFileNames -Recurse $Recurse | ?{ $_.Name -notlike $NotLike } | %{ outputFileName -FileInfo $_ -FullName $FullName }
}
else {
	getFileNames -Recurse $Recurse | %{ outputFileName -FileInfo $_ -FullName $FullName }
}

