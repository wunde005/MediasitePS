function Presentations
{
    <#
 
#<HELP>
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
#</HELP>

    #>

    #[CmdletBinding()]
    [CmdletBinding(DefaultParameterSetName="default")]
    Param
    (
      [string]$id,
    	[string]$id2,
    	[switch]$Annotations,
    	[switch]$Comments,
    	[switch]$Presenters,
    	[switch]$TimedEvents,
    	[switch]$Tags,
    	[switch]$RelatedPresentations,
    	[switch]$Questions,
    	[switch]$ThumbnailContent,
    	[switch]$SlideContent,
    	[switch]$SlideDetailsContent,
    	[switch]$OnDemandContent,
    	[switch]$BroadcastContent,
    	[switch]$PodcastContent,
    	[switch]$PublishToGoContent,
    	[switch]$OcrContent,
    	[switch]$CaptionContent,
    	[switch]$AudioPeaksContent,
    	[switch]$LayoutOptions,
    	[switch]$EmailInvitation,
    	[switch]$ShowcaseChannels,
    	[switch]$ShowcaseChannelsForAllInstances,
    	[switch]$VideoPodcastContent,
    	[switch]$Modules,
    	[switch]$Categories,
    	[switch]$ExternalPublishingContent,
    	[switch]$ModerateOrAnnotate,
    	[switch]$CreateLike,
    	[switch]$CreateShortcut,
    	[switch]$CreateMediaUpload,
    	[switch]$SendInvitation,
    	[switch]$CopyPresentation,
    	[switch]$AddVideoPodcast,
    	[switch]$AddExternalPublishing,
    	[switch]$ConvertVideoToSlide,
    	[switch]$AddCaptionContent,
    	[switch]$GetCommentCount,
    	[switch]$ResetMedia,
    	[switch]$EnableAnnotationCreation,
    	[switch]$SetThumbnail,
    	[switch]$AddPublishToGo,
    	[switch]$SubmitPublishToGo,
    	[switch]$RemovePublishToGo,
    	[switch]$AddPodcast,
    	[switch]$RemovePodcast,
    	[switch]$UpdateCommentVisibility,
    	[switch]$DeleteComments,
    	[switch]$UpdateAnnotationVisibility,
    	[switch]$DeleteAnnotations,
#<PARAM>
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
#</PARAM>
    )
#<BEGIN>

#<SKIP>
    	$targets = @("Annotations","Comments","Presenters","TimedEvents","Tags","RelatedPresentations","Questions","ThumbnailContent","SlideContent","SlideDetailsContent","OnDemandContent","BroadcastContent","PodcastContent","PublishToGoContent","OcrContent","CaptionContent","AudioPeaksContent","LayoutOptions","EmailInvitation","ShowcaseChannels","ShowcaseChannelsForAllInstances","VideoPodcastContent","Modules","Categories","ExternalPublishingContent","ModerateOrAnnotate","CreateLike","CreateShortcut","CreateMediaUpload","SendInvitation","CopyPresentation","AddVideoPodcast","AddExternalPublishing","ConvertVideoToSlide","AddCaptionContent","GetCommentCount","ResetMedia","EnableAnnotationCreation","SetThumbnail","AddPublishToGo","SubmitPublishToGo","RemovePublishToGo","AddPodcast","RemovePodcast","UpdateCommentVisibility","DeleteComments","UpdateAnnotationVisibility","DeleteAnnotations")
#</SKIP>
        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
#</BEGIN>