function Schedules
{
<#
    .DESCRIPTION
        Mediasite schedules. Search-backed resource.

    .PARAMETER Presenters
        List of presenters for the schedule
    .PARAMETER Recurrences
        List of recurrences for the schedule
    .PARAMETER Presentations
        List of presentations for the schedule
    .PARAMETER Tags
        List of tags for the schedule
    .PARAMETER Recorder
        Recorder used by the schedule
    .PARAMETER Player
        Player used by the schedule
    .PARAMETER Folder
        Parent folder of the schedule
    .PARAMETER SlideContent
        List of all the slide content associated with the schedule (not available yet)
    .PARAMETER OnDemandContent
        List of all the on-demand content associated with the schedule (not available yet)
    .PARAMETER BroadcastContent
        List of all the broadcast content associated with the schedule (not available yet)
    .PARAMETER PodcastContent
        List of all the podcast content associated with the schedule
    .PARAMETER PublishToGoContent
        Publish to go content on the schedule; 404 if there is none.
    .PARAMETER OcrContent
        List of all the OCR content associated with the schedule (not available yet)
    .PARAMETER CaptionContent
        List of all the caption content associated with the schedule (not available yet)
    .PARAMETER VideoPodcastContent
        List of all the video podcast content items associated with the schedule.
    .PARAMETER ExternalPublishingContent
        List of all the external publishing content items associated with the schedule.
    .PARAMETER Modules
        List of course modules containing the schedule. (To change the association of a module with a schedule, use PUT/PATCH to update the Associations property on the module to include or exclude the schedule, as needed.)
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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#Schedules

#>
	Param
	(
		[string]$id,
		[string]$id2,
		[switch]$Tags,
		[switch]$Recurrences,
		[switch]$Presenters,
		[switch]$Presentations,
		[switch]$Recorder,
		[switch]$Player,
		[switch]$Folder,
		[switch]$SlideContent,
		[switch]$OnDemandContent,
		[switch]$BroadcastContent,
		[switch]$PodcastContent,
		[switch]$PublishToGoContent,
		[switch]$OcrContent,
		[switch]$CaptionContent,
		[switch]$VideoPodcastContent,
		[switch]$ExternalPublishingContent,
		[switch]$Modules,
		[switch]$AddVideoPodcast,
		[switch]$AddExternalPublishing,
		[switch]$AddPublishToGo,
		[switch]$RemovePublishToGo,
		[switch]$AddPodcast,
		[switch]$RemovePodcast,
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
		$targets = @("Tags","Recurrences","Presenters","","Presentations","Recorder","Player","Folder","SlideContent","OnDemandContent","BroadcastContent","PodcastContent","PublishToGoContent","OcrContent","CaptionContent","VideoPodcastContent","ExternalPublishingContent","Modules","AddVideoPodcast","AddExternalPublishing","AddPublishToGo","RemovePublishToGo","AddPodcast","RemovePodcast")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
