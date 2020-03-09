#adds methods to returned objects 
#  'get' script blocks for <name>@odata.navigationLinkUrl links
#  'post' script block for #<name> links
#  subfolders script for folders
#  rootfolder script for home

function addmethod{
    param(
      $obj
    )
  
    $name = (((($obj.'odata.id') -split "api/v1/")[1] -split "\(")[0])
  
    if($name -eq "Folders"){
      $stext_f = 
@"
return (Folders -filter "ParentFolderId+eq+'`$(`$this.Id)'" -all)
"@
        $methodname_f = "Folders"
        $scriptblock_f = [scriptblock]::Create($stext_f)

        $obj | Add-Member -MemberType ScriptMethod -Name $methodname_f  -value $scriptblock_f  -force
    }
    elseif($name -eq "Home"){
        $stext_p = 
@"
return (Folders -id `$this.RootFolderId)
"@
        $methodname_p = "RootFolder"
        $scriptblock_p = [scriptblock]::Create($stext_p)
        $obj | Add-Member -MemberType ScriptMethod -Name $methodname_p  -value $scriptblock_p  -force
    }
    #if presentation and $select=card add full method to get obect with $select=full
    elseif(($name -eq "Presentations") -and ($null -eq $obj.PlayStatus)){
        $stext_p = 
@"
return (Presentations -id `$this.Id -full)
"@
        $methodname_p = "full"
        $scriptblock_p = [scriptblock]::Create($stext_p)
        $obj | Add-Member -MemberType ScriptMethod -Name $methodname_p  -value $scriptblock_p  -force
    }
    ($obj | Get-Member -MemberType NoteProperty).Name | Foreach-Object {

        if($_ -eq "ParentFolderId"){
            $stext = 
@"
if(`$null -eq `$this.ParentFolderId){
   write-warning "Folder is root"
   return `$null
}
return (Folders -id `$this.ParentFolderId)
"@
            $methodname = "Parent"
            $scriptblock = [scriptblock]::Create($stext)
            
            $obj | Add-Member -MemberType ScriptMethod -Name $methodname  -value $scriptblock  -force
        }

    $idx = $_.indexof('@odata.navigationLinkUrl') 
    $idxpost = $_.indexof('#')

    if($idxpost -ge 0){
        $methodname = $_.substring($idxpost+1)
   
        if($methodname -eq "Play"){
            write-verbose "PLay"
            $stext = 
@"
(New-Object -Com Shell.Application).Open((`$this.'#Play').target)
"@

        }   
        elseif($methodname -eq "Upload"){
            $stext = 
@"
param(
    [parameter(Position=0)]`$filename
)
#write-host "Not Enabled Yet"
`$luri = (`$this.'#Upload').target
mupload -uri `$luri -filename `$filename
"@

        }
        else{

          $stext = 
@"
param(
    [parameter(Position=0,Mandatory=`$false)]`$data
)
`$target = (`$this.'$_').target
if(`$null -eq `$data){
    `$data = @{}
}
if(`$data.gettype().name -ne "Hashtable"){
    write-warning "input needs to be a hashtable"
}
else{    
    $name -Post -data `$data -cmd `$target
}    
"@
                
            }
                
            $scriptblock = [scriptblock]::Create($stext)

            $obj | Add-Member -MemberType ScriptMethod -Name $methodname  -value $scriptblock  -force

        }
        elseif($idx -ge 0){
            $stext = 
@"
`$options=""
if(`$args[0].length -gt 0){
    `$options = "?" + `$args[0]
    write-host ((`$this.'$_') + `$options)
}
$name -cmd ((`$this.'$_') + `$options)
"@
            $methodname = $_.substring(0,$idx)
            
            $scriptblock = [scriptblock]::Create($stext)
            
            
            $obj | Add-Member -MemberType ScriptMethod -Name $methodname  -value $scriptblock  -force
        }
    }
    return $obj
}


function addmethods{
param(
    $obj1,
    $noaddmethod=$false
)
    if($noaddmethod){
        return $obj1
    }
    if($obj1 -is [array]){
        return ($obj1 | ForEach-Object { addmethod -obj $_ })
    }
    else{
        return (addmethod -obj $obj1)
    }
}

