#takes uri from 'odata.nextlink' and returns object of the options
# mostly for getting top and skip info

  
function GetURIoptions{
    param(
        [string]$uri
    )
    $t = $uri.split('?')
    if($t.Length -lt 2){
        #no options found in uri
        $tmp4 = ""
    }
    else{
        $tmp = $t[1]
        $tmp2 = $tmp.split('&')
        $tmp3 = $tmp2
        $tmp4 = ($tmp3 | ForEach-Object { $_.replace('$','"').replace('=','":"')}) -join '",'
        $tmp4 += '"'
    }
    return "{$tmp4}" | ConvertFrom-Json
}
