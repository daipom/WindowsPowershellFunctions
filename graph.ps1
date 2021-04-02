param(
    [parameter(mandatory=$true)][string[]] $path_list,
    [ValidateSet("utf-8", "utf-8-sig", "utf-16")][string] $encoding="utf-16",
    [ValidateSet("True", "False")][string] $is_x_time="True",
    [string] $time_format="""%m/%d/%Y %H:%M:%S""",
    [ValidateSet("True", "False")][string] $elapsed="False",
    [string] $yaxis_title="Bytes",
    [string] $yaxis2_title="None",
    [string[]] $yaxis_columns=$null,
    [string[]] $yaxis2_columns=$null
    )

$script = "${env:MY_SCRIPT}/graph/graph.py"
$param_path = $path_list

py $script $param_path --encoding $encoding --is_x_time $is_x_time --time_format $time_format --elapsed $elapsed --yaxis_title $yaxis_title --yaxis2_title $yaxis2_title --yaxis_columns $yaxis_columns --yaxis2_columns $yaxis2_columns
