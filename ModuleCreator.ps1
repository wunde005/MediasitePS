<#
    .SYNOPSIS
         Generates mediasite api module
    .DESCRIPTION
         Pulls xml file from mediasite server and creates module files
    .PARAMETER target
         create module file only with specified target
    .PARAMETER uri
         specify uri of mediasite server
    .PARAMETER rawoutput

    .EXAMPLE
         > .\ModuleCreator.ps1 -uri "http://sofo.mediasite.com/mediasite"

#>

###############
# Script for generating Module to interact with Mediasite API
# 
#
###############

param(
    [string[]]$Resources,
    [string]$uri="http://sofo.mediasite.com/mediasite",
    [switch]$clean
    )

$moduleroot = "MediasitePS"
$publicroot = $moduleroot + "\generated"
$publicfolder = $PSScriptRoot + "\" + $publicroot
$psd1file = $moduleroot + "\MediasitePS.psd1"
$templatefile = $PSScriptRoot + "\template\Presentations.ps1"

function getmetadata{
    <#
        .Synopsis
            get metadata for Mediasite Api
    
        .DESCRIPTION
            Get metadata for mediasite Api from the /api/v1/$metadata location
        
        .PARAMETER uri
            uri to the Mediasite server. Uses http://sofo.mediasite.com/mediasite by default.
    
        .PARAMETER save
            save the metadata to a file for the load command
    
        .PARAMETER load
            load the metadata from a file (from the save command)
    
        .PARAMETER all
            Returns all endpoints instead of only the broweable ones
                
        .EXAMPLE
        getmetadata -uri http://sofo.mediasite.com/mediasite
        Getting Metadata from: test.xml
    
    
        Name          : Templates
        EntityType    : SonicFoundry.Mediasite.WebApi.Model.TemplateRepresentation
        Browsable     : True
        d5p1          : http://www.mediasite.com/api/v1
        Documentation : Documentation
    
        Name          : Presentations
        EntityType    : SonicFoundry.Mediasite.WebApi.Model.PresentationDefaultRepresentation
        .........
    
        .EXAMPLE
        getmetadata -save test.xml
        
        .EXAMPLE
        getmetadata -load test.xml
        Getting Metadata from: test.xml
    
    
        Name          : Templates
        EntityType    : SonicFoundry.Mediasite.WebApi.Model.TemplateRepresentation
        Browsable     : True
        d5p1          : http://www.mediasite.com/api/v1
        Documentation : Documentation
    
        Name          : Presentations
        EntityType    : SonicFoundry.Mediasite.WebApi.Model.PresentationDefaultRepresentation
        ...........    
    #>
    [CmdletBinding(DefaultParameterSetName="default")]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = 'save')]
        [string]$save,
        [Parameter(Mandatory = $true, ParameterSetName = 'load')]
        [string]$load,
        [Parameter(Mandatory = $false, ParameterSetName = 'save')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [string]$uri='http://sofo.mediasite.com/mediasite',
        [Parameter(Mandatory = $false, ParameterSetName = 'load')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [switch]$all,
        [switch]$raw
    )

    if($load.Length -gt 0){
        write-host "Getting Metadata from: $load"
        $filecontent = Get-Content $load

        $rawxml = [xml]($filecontent -join "`n")
    }
    else{
        $luri = $uri + '/api/v1/$metadata'

        write-host "Getting Metadata from $luri"
        $metadata = Invoke-WebRequest -Uri $luri
        
        #remove BOM off of start of the string
        if([int][char]$metadata.Content[0] -eq 65279) { 
            $Content =  $metadata.Content.Substring(1)
        }
        else{
            $Content = $metadata.content
        }
        $rawxml =    [xml]$Content
        if($raw){
            return $rawxml
        }
    }
    if($save.Length -gt 0){
        $Content | out-file $save
    }
    else{
        $defaultNS = $rawxml.edmx.DataServices.Schema | Where-Object { $_.namespace -eq 'Default' }
        if($all){
            write-verbose "Returning All"
            return $defaultNS.EntityContainer.EntitySet
        }
        else{
            write-verbose "Returning Browseable"
            $BrowseAble = $defaultNS.EntityContainer.EntitySet | Where-Object { $_.browsable -eq $true } 
            return $BrowseAble
        }
    }
}

function get_template_section {
    param(
        [string]$templatefile,
        [string]$section,
        [string]$verb=""
    )
    if($verb -ne ""){
        $verb += ": "
    }
    $rtnarray = @()
    $template = Get-Content $templatefile
    if($section){
        write-host "$($verb)section:$section"
        $found = $false
        $skip = $false
        $template | ForEach-Object {
            if($_.indexof("#</$section>") -ge 0){
               $found = $false
            }
             if($_.indexof("#<SKIP>") -ge 0){
                $skip = $true
             }
             
            if($found -AND -NOT $SKIP){
                $rtnarray += $_
            }
            if($_.indexof("#</SKIP>") -ge 0){
                $skip = $false
             }
            
            if($_.indexof("#<$section>") -ne -1){
                $found = $true
            }
        }
    }
    write-host "$($verb)section:$section count:$($rtnarray.count)"
    
    return $rtnarray
}

function gen_parameters
{
    param(
        $obj,
        [string]$p
        )
    
    $exists = $false
        
    $verbs = @("PUT","POST","GET","PATCH","DELETE")
    $text = @()
    
    $i = 0
    if($obj.name -eq ""){
        $name = "default"
    }
    else{
        $name = $obj.name
    }
    
    if($p -eq "verbs"){
        write-host "running verbs"
        $manditory = $true
        $verbs | ForEach-Object {
            if($obj[$_].exists){
                $exists = $true
            }
        }
        if($exists){
            $text += "[Parameter(Mandatory = `$FALSE, ParameterSetName = '$($name)')]"
        }
    }
    elseif($verbs -contains $p){
    
        if($p -eq "GET" -and $obj[$p].exists){
            $text += "[Parameter(Mandatory = `$FALSE, ParameterSetName = '$($name)')]"
        }
        ELSEIF($p -eq "POST" -and $obj[$p].exists){
            $text += "[Parameter(Mandatory = `$FALSE, ParameterSetName = '$($name)')]"
        }
        ELSEIF($p -eq "PATCH" -and $obj[$p].exists){
            $text += "[Parameter(Mandatory = `$FALSE, ParameterSetName = '$($name)')]"
        }
        ELSEIF($p -eq "DELETE" -and $obj[$p].exists){
            $text += "[Parameter(Mandatory = `$FALSE, ParameterSetName = '$($name)')]"
        }
        ELSEIF($p -eq "PUT" -and $obj[$p].exists){
            $text += "[Parameter(Mandatory = `$FALSE, ParameterSetName = '$($name)')]"
        }
    }
    elseif($p -eq "id" -or $p -eq "id2"){
        $id_req = $true
        $id_avail = $false
        $id2_req = $true
        $id2_avail = $false
        $obj.keys | ForEach-Object {
            $i++ 
            if($_ -ne "name"){
                $t = $obj[$_]
                if($t.exists){
                    if(-not $id_avail -and ($t.id_avail -or $t.id_req)){
                        $id_avail = $true
                    }       
                    if(-not $id2_avail -and ($t.id2_avail -or $t.id2_req)){
                        $id2_avail = $true
                    }
                    if($id_req -and -not $t.id_req){
                        $id_req = $false
                    }
                    if($id2_req -and -not $t.id2_req){
                        $id2_req = $false
                    }
                }
                
            }
        }
        if($id_avail -and $p -eq "id"){
            $text += "[Parameter(Mandatory = `$$($id_req), ParameterSetName = '$($name)')]"
        }
        if($id2_avail -and $p -eq "id2"){
            $text += "[Parameter(Mandatory = `$$($id2_req), ParameterSetName = '$($name)')]"
        }
    
    }
    else{
        $manditory = $FALSE
        $exists = $false 
       
        $obj.keys | ForEach-Object {
            if($_ -ne "name"){
                if($obj[$_].exists){
                    $exists = $true
                }
            }
        }
        if($exists){
            $text += "[Parameter(Mandatory = `$$manditory, ParameterSetName = '$($name)')]"
        }
    }
    
    if($text.Length -lt 1){
        return $null
    }
    else{
        return $text
    }    
}


function target{
    param(
        $uri
    )
    
    if($uri -eq $null){
        return $null
    }
    else{ 
        $temp = $uri.split('/')
        $temp = $temp[3..$temp.Length]
        $new = @{'root'="";'target'="";'id'=$false;'id2'=$false;
    }
    
    $i = 0
    $t = ""
    $temp | ForEach-Object { 
        $found = $false
        
        if($_.indexof("('id')") -ge 0){
            $found = $true
            $new.id = $true
        }
        elseif($_.indexof("('id1')") -ge 0){
            $found = $true
            $new.id = $true
        }
        elseif($_.indexof("(id2)") -ge 0){
            $found = $true
            $new.id2 = $true
        }
        if($found){
            $t = $_.split('(')[0]
        }
        else{
            $t = $_
        }
        if($i++ -eq 0){
            $new.root = $t
        }    
    }
    if($t -ne $new.root){
        $new.target = $t
    }
    $new
    }
}

function mverb {
    param(
        $obj
    )
    $out = @()

    $obj | ForEach-Object { 
        $name = $_.name
        if($out | Where-Object{ $_.name -eq $name}){
            write-host "found in array"
        }
        else{
            $new = @{
                'name'=$name;
                'targets'=@();
                'entitytype'=$_.entitytype;
                'description'=$_.Documentation.LongDescription.DescText
            }
        }
        $_.documentation.longdescription.route | ForEach-Object {
            $verb = $_.verb
            $info = target $_.route

            if($null -eq $info.target){

            }
            elseif($info.target -eq "aaa"){
                $new[$_.verb].exists = $true
                if($new[$_.verb].id_req -eq $false){
                } 
                else{
                    $new[$_.verb].id_req = $info.id
                }
                
            }
            else{
                $old = @($new.targets | Where-Object { $_.name -eq $info.target})
                $rest = $new.targets | Where-Object { $_.name -ne $info.target}
                if($old.count -gt 0){
                    $old[0][$_.verb].exists = $true
                    if($old[0][$_.verb].id_req -eq $false){

                    }
                    else{
                        $old[0][$_.verb].id_req = $info.id
                    
                    }
                    if($info.id){
                        $old[0][$_.verb].id_avail = $true
                    }
                    if($info.id2){
                        $old[0][$_.verb].id2_avail = $true
                    }
                    
                    if($old[0][$_.verb].id2_req -eq $false){

                    }
                    else{
                        $old[0][$_.verb].id2_req = $info.id2
                    
                    }   
                    write-verbose "$($new.name):$verb`tidreq:$($old[0][$_.verb].id_req)`tinfo.id:$($info.id)`tinfo.id2:$($info.id2) "
                    
                    $new.targets = @($old) + $rest
                }
                else{
                    $newtarget = @{
                        'name'=$info.target;
                        'DELETE'=@{
                            'id_avail'=$false;
                            'id2_avail'=$false;
                            'id_req'=$null;
                            'exists'=$false;
                            'id2_req'=$null;
                        };
                        'GET'=@{
                            'id_avail'=$false;
                            'id2_avail'=$false;
                            'id_req'=$null;
                            'exists'=$false;
                            'id2_req'=$null
                        };
                        'PATCH'=@{
                            'id_avail'=$false;
                            'id2_avail'=$false;
                            'id_req'=$null;
                            'exists'=$false;
                            'id2_req'=$null;
                        };
                        'POST'=@{
                            'id_avail'=$false;
                            'id2_avail'=$false;
                            'id_req'=$null;
                            'exists'=$false;
                            'id2_req'=$null;
                        };
                        'PUT'=@{
                            'id_avail'=$false;
                            'id2_avail'=$false;
                            'id_req'=$null;
                            'exists'=$false;
                            'id2_req'=$null;
                        };
                    }
                    if($info.target -eq ""){
                        $verbose = $true
                    }
                    $newtarget[$_.verb].exists = $true
                    if($newtarget[$_.verb].id_req -eq $false){
                    } 
                    else{
                        $newtarget[$_.verb].id_req = $info.id
                    }   
                    $newtarget[$_.verb].id_req = $info.id
                    $newtarget[$_.verb].id2_req = $info.id2
                    $new.targets = $new.targets + @($newtarget) 
                }
                
            }
        }
        $out += $new
    }
    return $out
}

function testfi {
    <#
    .DESCRIPTION
        Test if FunctionImport
    #>
    param(
        $fi,
        $bindingparameter
        )
    $parameter = $fi.parameter
    $p = $parameter | Where-Object {$_.name -eq "bindingParameter"}

    return ($p.type -eq $bindingparameter)
}


function generate_function {
    param(
        $obj,
        $fi,
        $smwm 
    )
    $targets = $obj.targets
    write-host "`n$($obj.name)"
    
    $verbs = @("PUT","POST","GET","PATCH","DELETE")
    
    $lfi = ($fi | Where-Object { testfi -fi $_ -bindingparameter $obj.entitytype })
        
    $helptxt = ""
    foreach ($l in $lfi){
        write-host "$($obj.name): PARAM: $($l.name)"
        $helptxt += "    .PARAMETER $($l.name)`n"
        if($null -eq $l.Documentation.LongDescription){
            $cleantxt = ""
        }
        else{
            $cleantxt = $l.Documentation.LongDescription.replace("`n",'')
        }
        $helptxt += "        $cleantxt`n"
    }

    $text = ""
    $text += "function $($obj.name)`n{`n"
    $text += @"
<#

"@
    $text += "    .DESCRIPTION`n"
    $text += "        $($obj.description)`n`n"
    $text += functionlinks -smwm $smwm -entitytype $obj.entitytype.split('.')[-1] -target $obj.name
    
    $text += $helptxt

    (get_template_section -templatefile $templatefile -section "HELP" -verb $obj.name) | ForEach-Object { $text += "$_`n" }

    $text += @"    

    .LINK
    $($uri)/api/v1/`$metadata#$($obj.name)

#>

"@

    $ctab = "`t"

    $text += "$($ctab)Param`n$ctab(`n"
    $ctab = "`t`t"
    $text += "$ctab[string]`$id,`n"

    $text += "$ctab[string]`$id2,`n"
    $targets | ForEach-Object{
        if($_.name -eq ""){
            $name = "default"
        }
        else{
            $name = $_.name
            $text += "$ctab[switch]`$$($name),`n"
        }
    }

    ((get_template_section -templatefile ".\template\presentations.ps1" -section "PARAM" -verb $obj.name)) | ForEach-Object{
        $text += "$ctab$($_.trim())`n"
    }
    $ctab = "`t"
    $text += "$ctab)"

    $targettxt = "`$targets = @("
    $delim = ""
    $targets.name | ForEach-Object {
        $targettxt += $delim +"`"$_`"" 

        $delim = ","
    }
    $targettxt += ")`n"

    $newbegin = @()
    $found = $false
    (get_template_section -templatefile $templatefile -section "BEGIN" -verb $obj.name) | ForEach-Object {
        $newbegin += $_
        if(-not $found){
            $newbegin += "`t`t$targettxt"
            $found = $true
        }
    }
    $text += ($newbegin -join "`n")
    return $text 
}

function functionlinks {
    param(
        $smwm,
        $entitytype,
        $target=""
    )
    if($target -ne ""){
        $target += ": "
    }
    $text = ""
    foreach ($np in ($smwm| Where-Object {$_.name -eq $entitytype}).navigationproperty){
        write-host "$($target)NAVPROP: $($np.name)"
        $text += "    .PARAMETER $($np.name)`n"
        if($null -ne $np.documentation.longdescription){
            $text += "        $($np.documentation.longdescription.replace('`n',''))`n"
        }
        else{
            $text += "`n"
        }
    }
    return $text
}

#formating for timings
$maxtabs = 4
function gettabs{
    param($string,$maxtabs)

    $tabcnt = [Math]::Floor($string.length/8)
    $tabs = "`t"
    $newtabs = $maxtabs - $tabcnt
    if($newtabs -lt 1){
        $newtabs = 1
    }
    return $($tabs*($newtabs))
}

#get meta data from server
$metadata = getmetadata -uri $uri -raw

#entities
$smwm = ($metadata.Edmx.DataServices.Schema | Where-Object { $_.namespace -eq "SonicFoundry.Mediasite.WebApi.Model" }).entitytype

#function imports
$fi = ($metatdata.Edmx.DataServices.schema | Where-Object { $_.namespace -eq "Default"}).entitycontainer.functionimport

#default name space, only get browseble
$dns = (($metadata.Edmx.DataServices.Schema | Where-Object { $_.namespace -eq "default" }).entitycontainer.entityset  )|  Where-Object { $_.Browsable -eq $true }

#continue with only specified target
if($null -ne $Resources){
    $dns = $dns | Where-Object { $_.name -in $Resources}
}


#remove ps1 files from generated folder if "clean" is selected
if($clean){
    
    write-host "cleaning public scripts from: $publicfolder "
    Get-ChildItem -path $publicfolder -File -filter *.ps1| Remove-Item
}

$timings = ""
$tcnt = $null

#make functions in public folder available 
$exportlist = "FunctionsToExport = 'Next'"

#add functions in genderated folder available
foreach ($verb in $dns){
    $exportlist += ",'$($verb.name)'"
    $m = measure-command {
        $moduletxt = generate_function -obj (mverb($verb)) -fi $fi -smwm $smwm
        $modulefile = $publicfolder+ "\$($verb.name).ps1"
        $moduletxt | out-file -FilePath $modulefile
    }
    $tcnt += $m
    $timings +=  "$($verb.name)$(gettabs -maxtabs $maxtabs -string $verb.name)$($m.TotalMilliseconds) ms`n"
}
write-host "`nTimings:`n$timings"
write-host "$("`t"*$maxtabs)$($tcnt.Totalseconds) secs"

#replace functions to export in psd1 file
$regex = '^FunctionsToExport = .*'
(Get-Content $psd1file) -replace $regex,$exportlist  | Set-Content $psd1file
