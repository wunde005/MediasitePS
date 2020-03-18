function processrequest{
    param(
        $name,
        $parameterlist,
        [Alias("arguments")]
        $p,
        $targets
    )
    Begin
    {   
    if($null -eq $p.top){
        $top=10
    }
    else{
        $top=$p.top
    }

    if(-not ($p.put -or $p.patch -or $p.delete -or $p.post)){
        $get = $true 
        write-verbose "get:"
    }

    $target = ""
    foreach ($key in $ParameterList.keys)
    {   
        $var = $p[$key]

        if($key)
        {   
            if($targets -contains $key){
                if($key -and $var){
                    if($target -ne ""){
                        write-warning "multiple targets. skipping: $key"
                    }
                    else{
                        $target = $key
                        write-verbose "target: $target"
                        write-verbose "id: $p.id $($p.id.length)"
                        if($p.id.length -lt 1){
                            write-warning "no ID added"
                            throw "no ID added"
                        }
                    }
                }
            }
        }
    }   

    $firstoption = $true

    write-verbose "Command:$name" 

    $luri = $uri + $name
    if($p.id.Length -gt 0){
        $luri = $luri + "('$($p.id)')"
    }
    if($target.length -gt 0){
        $luri = $luri + "/$target"
    }
    
    if($p.filter.Length -gt 0){
        if($firstoption){
            $luri = $luri + "?"
        }
        else{
            $luri = $luri + "&"
        }
        $firstoption = $false
        $filter = $p.filter.replace(' ','+')
        $luri = $luri + "`$filter=" + $filter
    }
    
    if($top -ne 10){
        if($firstoption){
            $luri = $luri + "?"
        }
        else{
            $luri = $luri + "&"
        }
        $firstoption = $false
        $luri = $luri + "`$top=$($top)"
    }
    
    if($p.full){
        if($firstoption){
            $luri = $luri + "?"
        }
        else{
            $luri = $luri + "&"
        }
        $firstoption = $false
        $luri = $luri + "`$select=full"
    }
    
    if($next){
        $luri = getnext -name $name
    }
    
    if($p.cmd.length -gt 0){
        $luri = $p.cmd
    }
    write-verbose "luri:$luri"

}
Process
{   
    if($get){
        $rtndata = mrestget($luri)
    
        Write-Verbose "size $($rtndata.count)"
        Write-Verbose "size $($rtndata.length)"
        write-verbose "done $($rtndata.'odata.count')"
        if($null -ne $rtndata.'odata.id'){
            write-verbose "found odata.id"
            $odataidfound = $true
            $returnedvalue = $false
        }
        
        if($null -ne $rtndata.'odata.count'){
            write-verbose "found odata.count $($rtndata.'odata.count')"
            $returnedvalue = $true
        }
        
        $returnedvalue = [bool]($rtndata.PSobject.Properties.name -match "value")
        
        setnext -name $name -link $rtndata.'odata.nextlink'
        
        write-verbose "Returnedvalue:$returnedvalue"
        write-verbose "odata.count:$($rtndata.'odata.count') not-null:$($null -ne $rtndata.'odata.nextlink') all:$($p.all)"
        
        if(($rtndata.'odata.count' -gt 0) -or $p.all){
            $tmpjson = GetURIoptions -uri (getnext -name $name)
            
            if($null -eq $tmpjson.skip){
                $counttxt = "$name`: 0 of $($rtndata.'odata.count') remaining." 
                
            }
            else{
                $counttxt =  "$name`: $($rtndata.'odata.count' - $tmpjson.skip) of $($rtndata.'odata.count') remaining." 
                if(-not $p.all){
                    $counttxt += " Use> $name -next"
                }
            }
            write-host $counttxt
        }
        else{
            Write-Verbose "size $($rtndata.count)"
            Write-Verbose "size $($rtndata.length)"
            write-verbose "done $($rtndata.'odata.count')"
        }
        write-verbose "countinfo: $($rtndata.count) $($rtndata.value.count) $($rtndata.'odata.count') $($returnedvalue)"
        
        write-verbose "returnedvalue:$returnedvalue"
        
        if($p.rawoutput){
            Write-Verbose "rawout"
            return $rtndata
        }
        if($odataidfound){
        Write-Verbose "odataidfound"
        #return ,,(addmethods -obj1 $rtndata -noaddmethod $noaddmethod)
        return (addmethods -obj1 $rtndata -noaddmethod $noaddmethod)  
        }
        #do I need this anymore? 
        if($rtndata.value.count -eq 0){
            Write-Verbose "value count = 0"
            return @()
            return , (addmethods -obj1 $rtndata -noaddmethod $noaddmethod) 
        }
        elseif($rtndata.value.count -eq 1){
            Write-Verbose "value count = 1"
            return ,,(addmethods -obj1 $rtndata.value -noaddmethod $noaddmethod)
        }
        else{
            Write-Verbose "else"
            return (addmethods -obj1 $rtndata.value -noaddmethod $noaddmethod)
        }
    }
    elseif($p.post){
        write-verbose "mrestpost -data $($p.data) -cmd $luri"
        return mrestpost -data $data -cmd $luri
    }
    elseif($p.put){
        write-verbose "mrestput -data $($p.data) -cmd $luri"
        return mrestput -data $p.data -cmd $luri
    }
    elseif($p.patch){
        write-verbose "mrestpatch -data $($p.data) -cmd $luri"
        return mrestpatch -data $p.data -cmd $luri
    }
    elseif($delete){
        write-verbose "mrestdel($luri)"
        return mrestdel($luri)
    }
    elseif($luri.Length -lt 1){
        write-verbose "empty uri"
    }     
    else{
        write-host "else"
        $defaultrtn = mrestget($luri) 
        if($p.rawoutput){
            #return $defaultrtn
        }
        else{
            $defaultrtn = $defaultrtn | Select-Object -Property * -ExcludeProperty 'odata.*' 
        }
        write-host $defaultrtn.gettype()
        return $defaultrtn
    }
}
End
    {
    write-verbose "All: $($p.all) $(getnext -name $name)"
    if($p.all -and ((getnext -name $name).length -gt 0)){
        $command = "$name -next -all"
        return Invoke-Expression $command
        }
    }
}

