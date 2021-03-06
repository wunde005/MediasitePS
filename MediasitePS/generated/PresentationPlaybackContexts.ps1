function PresentationPlaybackContexts
{
<#
    .DESCRIPTION
        Per-presentation per-user bookmark and viewing coverage information. Note that a requesting user must have the Manage Playback Contexts operation to see this information for any user other than themselves.

    .PARAMETER UserData
        The requested presentation's playback context data for all users, returned in pages. Note that the paging and $orderby can be specified, but $filter will have no effect. If the requesting user lacks the Manage Playback Contexts operation, only their own playback context data may be returned.
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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#PresentationPlaybackContexts

#>
	Param
	(
		[string]$id,
		[string]$id2,
		[switch]$UserData,
		[switch]$GetBatch,
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
		$targets = @("UserData","GetBatch")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
