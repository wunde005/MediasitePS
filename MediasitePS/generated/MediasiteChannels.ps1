function MediasiteChannels
{
<#
    .DESCRIPTION
        Channels. Search-backed resource.

    .PARAMETER Presentations
        List of presentations that are in the channel.
    .PARAMETER AvailablePresentations

    .PARAMETER Settings
        Display options and search settings (if any) for the channel.
    .PARAMETER full
         By default only a subset of fields for presentations are served; a larger subset can be retrieved by the full command (usese $select=full).
    .PARAMETER filter
         OData filter parameter
    .PARAMETER top
         10 results are returned by default, set top to change return count.
    .PARAMETER rawoutput
         return raw output from web request, otherwise it will try to return just the values
   .PARAMETER cmd
         raw url request to be sent to the API
   .PARAMETER data
         Data to be sent to api in hashtable format

    .LINK
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#MediasiteChannels

#>
	Param
	(
		[string]$id,
		[string]$id2,
		[switch]$Settings,
		[switch]$Presentations,
		[switch]$AvailablePresentations,
		[switch]$AddPresentations,
		[switch]$RemovePresentations,
		[switch]$SetTermsAndConditions,
		[switch]$ClearTermsAndConditions,
		[switch]$PUT,
		[switch]$POST,
		[switch]$GET,
		[switch]$PATCH,
		[switch]$DELETE,
		[switch]$all=$false,
		[switch]$next=$false,
		[switch]$full=$false,
		[string]$filter,
		[int16]$top=10,
		[switch]$rawoutput,
		[string]$cmd,
		[switch]$noaddmethod=$false,
		[hashtable]$data
	)
		$targets = @("Settings","","Presentations","AvailablePresentations","AddPresentations","RemovePresentations","SetTermsAndConditions","ClearTermsAndConditions")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
