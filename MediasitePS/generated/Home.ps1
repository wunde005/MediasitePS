function Home
{
<#
    .DESCRIPTION
        API Home contains site-level information. The properties MaximumConnections and PerUserConnectionLimit may be modified via PUT or PATCH, provided the user has System Management permissions; all other properties are read-only.

    .PARAMETER NowPlaying
        Returns the presentations that are currently being broadcast live in the system. (NB: a string identifier must be provided when making this request. This can be any string.) If ShowcaseId is set in the request header, results will be limited to the specified showcase.
    .PARAMETER RecentlyViewed
        Returns the presentations recently viewed by the current user, to a maximum of 20, most recently viewed first. (NB: a string identifier must be provided when making this request. This can be any string.) If ShowcaseId is set in the request header, results will be limited to the specified showcase.
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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#Home

#>
	Param
	(
		[string]$id,
		[string]$id2,
		[switch]$NowPlaying,
		[switch]$RecentlyViewed,
		[switch]$ChangePassword,
		[switch]$RefreshReportData,
		[switch]$ValidatePlaybackTicket,
		[switch]$ComputePerSiteStorage,
		[switch]$BatchSearchReindex,
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
		$targets = @("","NowPlaying","RecentlyViewed","ChangePassword","RefreshReportData","ValidatePlaybackTicket","ComputePerSiteStorage","BatchSearchReindex")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
