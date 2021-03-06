function Presentations
{
<#
    .DESCRIPTION
        Mediasite presentations and shortcuts. By default only a subset of fields are served; a larger subset can be retrieved by using the query parameter $select=card and the full set by using $select=full. The 'excludeduplicatepresentations' query-string parameter can be used to request that the results not contain multiple presentations sharing a root; the 'excludeshortcutpresentations' query-string parameter can be used to request that no shortcuts be included in the results. Search-backed resource.

    .PARAMETER RelatedPresentations
        List of presentations ranked as similar to the presentation. The optional query-string parameter similarityType may be used to specify the kind of similarity: Tags, Presenters, or All. If not specified then All is assumed. If ShowcaseId is set in the header of the request, results will be limited to the specified showcase.
    .PARAMETER Tags
        List of the tags associated with the presentation
    .PARAMETER TimedEvents
        List of the timed events associated with the presentation. If ShowcaseId is specified in the header of the request, this can be retrieved anonymously from a showcase that has registration enabled.
    .PARAMETER Presenters
        List of the presenters associated with the presentation
    .PARAMETER Questions
        List of the forum questions submitted by viewers of the presentation
    .PARAMETER Comments

    .PARAMETER ThumbnailContent
        List of all the thumbnail images associated with the presentation. Items are returned in decreasing order of content revision. If ShowcaseId is specified in the header of the request, this will only return thumbnails associated with the specified showcase.
    .PARAMETER SlideContent
        List of all the slide content items associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER SlideDetailsContent
        If the presentation's current revision has a Slide stream, returns a list of all slides in it, annotated with number and position in the presentation, as well as title, description, and OCR text (when defined).
    .PARAMETER OnDemandContent
        List of all the on-demand video associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER BroadcastContent
        List of all the broadcast content associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER PodcastContent
        List of all the podcast content associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER PublishToGoContent
        Publish to go content on the head revision; 404 if there is none. This link requires either View on the presentation or access to the Publish To Go operation.
    .PARAMETER OcrContent
        List of all the OCR content associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER CaptionContent
        List of all the caption content associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER AudioPeaksContent
        List of all the audio peaks data associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER LayoutOptions
        Per-presentation player layout options for the presentation
    .PARAMETER EmailInvitation
        Default email invitation for the presentation
    .PARAMETER ShowcaseChannels
        List of Showcase channels containing the presentation
    .PARAMETER ShowcaseChannelsForAllInstances
        List of Showcase channels containing either the presentation itself, or any shortcut to the same content. This will search within the default showcase unless ShowcaseId is specified in the header of the request.
    .PARAMETER VideoPodcastContent
        List of all the video podcast content items associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER Modules
        List of course modules containing the presentation. (To change the association of a module with a presentation, use PUT/PATCH to update the Associations property on the module to include or exclude the presentation, as needed.)
    .PARAMETER Categories
        List of categories associated with the presentation. If ShowcaseId is set in the header of the request, results will not be filtered by the role of the requester.
    .PARAMETER ExternalPublishingContent
        List of all the external publishing content items associated with the presentation. Items are returned in decreasing order of content revision.
    .PARAMETER Annotations
        List of the annotations associated with the presentation
    .PARAMETER ModerateOrAnnotate
        List of the annotations associated with the presentation
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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#Presentations

#>
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
		$targets = @("Annotations","Comments","Presenters","TimedEvents","Tags","","RelatedPresentations","Questions","ThumbnailContent","SlideContent","SlideDetailsContent","OnDemandContent","BroadcastContent","PodcastContent","PublishToGoContent","OcrContent","CaptionContent","AudioPeaksContent","LayoutOptions","EmailInvitation","ShowcaseChannels","ShowcaseChannelsForAllInstances","VideoPodcastContent","Modules","Categories","ExternalPublishingContent","ModerateOrAnnotate","CreateLike","CreateShortcut","CreateMediaUpload","SendInvitation","CopyPresentation","AddVideoPodcast","AddExternalPublishing","ConvertVideoToSlide","AddCaptionContent","GetCommentCount","ResetMedia","EnableAnnotationCreation","SetThumbnail","AddPublishToGo","SubmitPublishToGo","RemovePublishToGo","AddPodcast","RemovePodcast","UpdateCommentVisibility","DeleteComments","UpdateAnnotationVisibility","DeleteAnnotations")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
