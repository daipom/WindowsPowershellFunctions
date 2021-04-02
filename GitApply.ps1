Param(
    [parameter(mandatory=$true)][string] $FilePathToApply
)

git apply --ignore-whitespace $FilePathToApply
