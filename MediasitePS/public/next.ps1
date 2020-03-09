function next{
    param(
        [switch]$display
    )
    $name = getlast
    if($display){
        return $next[$name]
    }
    
    #write-host "name: $name $($null -eq $name) $($name -eq '')"
    if($name -eq ""){
        Write-Warning "No previous command set"
    }
    else{
        $command = "$name -next"
        return Invoke-Expression $command
    }
}