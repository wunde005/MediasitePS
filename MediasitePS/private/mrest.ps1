[string]$uri = ""

$displayauthmethod = $false
#Returns header for API

function rtnheader(){
  
  if($null -eq $auth.sfapikey){
    $lsfapikey = $sfapikey
  }
  else{
    $lsfapikey = $auth.sfapikey 
  }
  $defaulthdr = @{
    "Accept"="text/html,application/xhtml+xml,application/xml-;q=0.9,image/webp,*/*;q=0.8";
    "Accept-Language"="en-US,en;q=0.8";
    "sfapikey"=$($lsfapikey);"Accept-Encoding"="gzip,deflate,sdch";
    }

  if($auth.SecMediasiteApplicationTicket.length -gt 0){
    if($displayauthmethod){
      write-host "using secure mediasite appliction ticket"
    }
    return $defaulthdr + @{
      "Mediasite-Application-Ticket"=([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
       $auth.secMediasiteApplicationTicket)))
    }
  }
  elseif($auth.MediasiteApplicationTicket.length -gt 0){
      if($displayauthmethod){
        write-host "using ApplicationTicket"
      }
      return $defaulthdr + @{
          "Mediasite-Application-Ticket"=$auth.MediasiteApplicationTicket
      }
  }
  elseif($auth.authorization.Length -gt 0){
    if($displayauthmethod){
      write-host "using auth.authorization"
    }
    return $defaulthdr + @{
      "Authorization"=$auth.authorization
  }  
  }
  if($displayauthmethod){
    write-host "using authorization"
  }
  return $defaulthdr + @{
      "Authorization"=$authorization
  }
}

function rtnuri(){
  return $uri
}

function seturi{
  param(
    [string]$systemuri
  )
  $script:uri = $systemUri + "/api/v1/"
}

function mrestget($x){
  $x = $x.toString()
  if(!$x){
    return;
    }
  elseif($x.contains("http")){
    $luricmd = $x
    }
  else{ 
    $luricmd = $uri + $x
    }
  if($debug){
    write-host $luricmd
    write-host "headers:"
    write-host $(rtnheader | convertto-json)
  }
  try{
    return Invoke-RestMethod -Headers $(rtnheader) -uri $luricmd
  }
  catch{
    Write-Warning "Invoke-RestMethod Failed"
    throw $PSItem
  }
}
  
function mrestpatch{
  param (
    [Parameter(Mandatory=$true)][string]$cmd,
    [Parameter(Mandatory=$true)][System.Object]$data
    
  )
  if($null -ne $data){
    if($cmd.contains("http")){
      $luricmd = $cmd
    }
    else{
      $luricmd = $uri + $cmd
    }
    return Invoke-RestMethod -Headers $(rtnheader) -uri $luricmd -method patch -ContentType 'application/json' -Body ($data| convertto-json)
    }
  else{
    write-host "`$postdata value is missing"
  }
}

function mrestdel($x){
  if(!$x){
    return;
    }
  elseif($x.contains("http")){
    $luricmd = $x
    }
  else{ 
    $luricmd = $uri + $x
    }
  #if($true){
  if($debug){
    write-host $luricmd
    write-host $(rtnheader)
  }
  try{
    return Invoke-RestMethod -Headers $(rtnheader) -uri $luricmd  -Method Delete
  }
  catch{
    throw $PSItem
  }
}
  
function mrestput{
  param (
    [Parameter(Mandatory=$true)][string]$cmd,
    [Parameter(Mandatory=$true)][System.Object]$data
    
  )
  if($null -ne $data){
    if($cmd.contains("http")){
      $luricmd = $cmd
    }
    else{
      $luricmd = $uri + $cmd
    }
    return Invoke-RestMethod -Headers $(rtnheader) -uri $luricmd -method put -ContentType 'application/json' -Body ($data| convertto-json)
    }
  else{
    write-host "`$postdata value is missing"
  }
}
  

function mupload{
  param(
      [string]$filename,
      [string]$uri
      )
  
  $file = Get-ChildItem $filename
  $name = $file.Name
  $basename = $file.basename
  $extension = $file.extension
  if($extension -ne '.mp4'){
    write-host "not mp4"
    write-host "$filename $name $basename $extension"
  }
  $name = $basename + "-" + (get-date).toString('yyMMdd-hhmm') + $extension
  $luricmd = $uri +"/"+$name
  
  try { 
      $results = Invoke-RestMethod -Headers $(rtnheader) -ContentType 'video/mp4' -uri $luricmd -method post -Infile $filename -ErrorAction Stop
  }
  catch{
      return $_.Exception.Response
  }
  
  write-host $results
  return @{'FileName'=$name}
}

function mrestpost{
  param([hashtable]$data,[string]$cmd)
  $rt = rtnheader

  $rt.Accept = "application/json;q=0.9,image/webp,*/*;q=0.8"

  if($data.gettype().name -ne "Hashtable"){
    write-warning "Data is not a hasstable"
  }

  if($null -ne $data){
    if($cmd.contains("http")){
      $luricmd = $cmd
    }
    else{
      $luricmd = $uri + $cmd
    }
    return Invoke-RestMethod -Headers $rt -uri $luricmd -method post -ContentType 'application/json' -body ($data | convertto-json)
  }
  else{
    write-host "`$data value is missing"
  }
}



