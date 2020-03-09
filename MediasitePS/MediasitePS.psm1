param(
    [parameter(Position=0,Mandatory=$false)][string]$auth_file,
    [parameter(Position=1,Mandatory=$false)][string]$usetemplate
)

#Get public and private function definition files.
    if($usetemplate){
        write-host "using template"
        $Public  = @( Get-ChildItem -Path $PSScriptRoot\template\*.ps1 -ErrorAction SilentlyContinue )
    }
    else{
        $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
        $Public_gen  = @( Get-ChildItem -Path $PSScriptRoot\generated\*.ps1 -ErrorAction SilentlyContinue )
        if($Public_gen.Count -lt 1){
            Write-Warning "No functions found.  You may need to run modulecreator.ps1"
        }
    }
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Private + $public + $Public_gen))
    {
        Try
        {
            #write-host """$($import.name)"" $($import -eq $null)"
            if($null -eq $import.fullname){
                
            }

            elseif($import.name -eq "z_auth.ps1"){
                try{
                    . $import.fullname $auth_file
                }
                catch{
                    Write-Warning "Failed auth load"
                    return
                }
            }
            else{
                #write-host "fullname: $($import.fullname))"
                . $import.fullname
            }
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

# Here I might...
    # Read in or create an initial config file and variable
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only
    #write-verbose $Public.Basename 
    #write-verbose $Public_gen.BaseName
Export-ModuleMember -Function $Public.BaseName
Export-ModuleMember -Function $Public_gen.BaseName

<#
function Get-PD
{
    [CmdletBinding()]
    Param()
    Begin{}
    Process
    {
        $MyInvocation.MyCommand.Module.PrivateData
    }
    End{}
}

$MyPD = Get-PD

write-host "$($mypd | convertto-json)"
#>

