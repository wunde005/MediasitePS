function RecycledPresentations
{
<#
    .DESCRIPTION
        Mediasite presentations and shortcuts that are in the Recycle Bin. By default only a subset of fields are served; a larger subset can be retrieved by using the query parameter $select=card and the full set by using $select=full. Search-backed resource.

    .PARAMETER Tags

    .PARAMETER TimedEvents

    .PARAMETER Presenters

    .PARAMETER Questions

    .PARAMETER ThumbnailContent

    .PARAMETER SlideContent

    .PARAMETER OnDemandContent

    .PARAMETER BroadcastContent

    .PARAMETER PodcastContent

    .PARAMETER OcrContent

    .PARAMETER CaptionContent

    .PARAMETER AudioPeaksContent

    .PARAMETER LayoutOptions

    .PARAMETER EmailInvitation

    .PARAMETER RelatedPresentations

    .PARAMETER ShowcaseChannels

    .PARAMETER ShowcaseChannelsForAllInstances

    .PARAMETER VideoPodcastContent

    .PARAMETER Modules

    .PARAMETER Categories

    .PARAMETER ExternalPublishingContent

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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#RecycledPresentations

#>
	Param
	(
		[string]$id,
		[string]$id2,
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
		$targets = @("")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
