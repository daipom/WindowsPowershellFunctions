svn revert * -R
svn st | %{($_ -split " ")[-1]} | rm -Force -Recurse