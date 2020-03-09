$next = @{}
$lastmethod = ""

#sets next link based on function name
function setnext{
    param(
      [string]$name,
      [string]$link
    )
    $script:lastmethod = $name
    $script:next[$name] = $link
}
    
#returns last used function
function getlast{
  return $script:lastmethod
}

#returns url for next data based on the function name
function getnext{
    param(
      [string]$name,
      [string]$link
    )
    $script:lastmethod = $name
    return $script:next[$name]
}
