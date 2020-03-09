param(
    [parameter(Position=0,Mandatory=$false)][string]$auth_file
)

$authfileused = $false
write-host "auth_file:$auth_file"
$auth = $null
if([string]::IsNullOrWhiteSpace($auth_file)){
  write-warning "Auth file not submitted.  Either re-import with the auth file specified or follow the prompts to create a new one."
  write-host "Example import with auth file: import-module MediasitePS -ArgumentList .\tmp\auth.xml`n"
}
else{
  write-host "Loading auth from: $auth_file"
  try {
    $auth = import-clixml ($auth_file)
  }
  catch{ [System.IO.FileNotFoundException]
    Write-Warning "File not found. Make sure xml config exists: $auth_file"   
    throw
  }
  $authfileused = $true
}

if($null -eq $auth){
  $auth = New-Object -TypeName psobject
}

#no uri, ask for uri
if($null -eq $auth.uri){
  $systemUri = Read-Host "mediasite uri(https://<servername>/mediasite)"#'uri?'

  $auth | Add-Member -MemberType NoteProperty -name uri -Value $systemUri.tostring()  
}
else{
  $systemUri = $auth.uri
}
seturi -systemuri $systemuri

#no API key, ask for API key
if($null -eq $auth.sfapikey){
  write-host "`nInfo on the API can be found here: $systemUri/api/v1/`$metadata#top`n"

  write-host "Go here to create a API key: $systemUri/api/Docs/ApiKeyRegistration.aspx`n"
  
  $sfapikey = Read-Host 'Enter API Key'
  $auth | Add-Member -MemberType NoteProperty -name sfapikey -Value $sfapikey.tostring()
}
else{
  $sfapikey = $auth.sfapikey
}

if(($null -eq $auth.authorization) -and ($null -eq $auth.secauthtext) -and ($null -eq $auth.MediasiteApplicationTicket) -and ($null -eq $auth.SecMediasiteApplicationTicketTxt)){  
  $username = Read-Host 'What is your username?'
  $pass = Read-Host 'What is your password?' -AsSecureString
  $upass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
  
  $authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username + ':' + $upass)))"
  
  $auth | Add-Member -MemberType NoteProperty -name authorization -Value $authorization
  $authorization = $null
  
  $upass = $null
  $pass = $null
  $authfromconfig = $false
}
elseif($null -ne $auth.secauthtext){
  $authfromconfig = $true
  $authorization = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($(ConvertTo-SecureString $auth.secauthtext)))
}
else{
  $authfromconfig = $true
  $authorization = $auth.authorization  
}
$ticket = $null

if($null -eq $auth.MediasiteApplicationTicket -and -not $authfromconfig -and -not $authfileused){
  #write-host "`n"
  #write-host "$authfromconfig $authfileused"
  $getticket = Read-host 'get Application Ticket?(Y/n)'
  if($getticket -eq 'y'){

    $tusername = read-host 'username to use for ticket (leave blank to use current username)'
    if([string]::IsNullOrWhiteSpace($tusername)){
      $tusername = $username
    }
    write-host "finding profile id for $tusername"
    
    try{
      $ma = mrestget("UserProfiles?`$filter=UserName%20eq%20'$tusername'")
    }
    catch {
      Write-Host "An error occurred:"
      Write-Host $_
      throw
    }
    
    if($ma.value.Id.length -eq 34){    
      try{
        $response = mrestpost -cmd "ApplicationTickets" -data @{"UserProfileId"=$ma.value.Id}
      }
      catch{
        Write-Warning "issue getting application ticket."
        write-host $_
        throw
      }
      $ticket = $response.Id
    }
    else{
      write-host "User $tusername not found"
    }
    #read-host "$ma kill?"
  }

  if($null -eq $ticket){
  }
  elseif($null -ne $ticket){
    $auth = $auth | Select-Object -Property * -ExcludeProperty "authorization"
    $auth | Add-Member -MemberType NoteProperty -name SecMediasiteApplicationTicketTxt -Value ((ConvertTo-SecureString $ticket -AsPlainText -Force) | ConvertFrom-SecureString ).tostring()
    $ticket = $null
  }
  else{
      $auth = $auth | Select-Object -Property * -ExcludeProperty "authorization"
      $auth | Add-Member -MemberType NoteProperty -name MediasiteApplicationTicket -Value $ticket.tostring()
  }

  $writeauth = Read-host 'write authfile?(Y/n)'
  if($writeauth -eq 'y'){
    $newauthfile = read-host 'auth file'
    $auth | Export-Clixml "$newauthfile"
  }
}

#add secured ticket to auth object
if($null -ne $auth.SecMediasiteApplicationTicketTxt -and $null -eq $auth.SecMediasiteApplicationTicket){
  $auth | Add-Member -MemberType NoteProperty -name SecMediasiteApplicationTicket -Value ($auth.SecMediasiteApplicationTicketTxt | ConvertTo-SecureString) 
}


