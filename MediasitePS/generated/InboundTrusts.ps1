function InboundTrusts
{
<#
    .DESCRIPTION
        Inbound Mediasite trusts

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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#InboundTrusts

#>
	Param
	(
		[string]$id,
		[string]$id2,
		[switch]$OnOutboundTrustCreated,
		[switch]$OnRemoteTrustUpdated,
		[switch]$OnRemoteTrustDeleted,
		[switch]$OnRemoteSiteRemoved,
		[switch]$OnRemoteSiteRootChanged,
		[switch]$OnExportedPackageAvailable,
		[switch]$OnExportCancelled,
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
		$targets = @("","OnOutboundTrustCreated","OnRemoteTrustUpdated","OnRemoteTrustDeleted","OnRemoteSiteRemoved","OnRemoteSiteRootChanged","OnExportedPackageAvailable","OnExportCancelled")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
