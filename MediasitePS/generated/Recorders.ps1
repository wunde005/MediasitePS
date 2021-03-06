function Recorders
{
<#
    .DESCRIPTION
        Mediasite Recorder registrations. Search-backed resource.

    .PARAMETER LicenseStatus
        Structure representing whether the Recorder software is licensed
    .PARAMETER Status
        Status of the capture engine on the Recorder
    .PARAMETER ExtendedStatus
        Structure representing current status of the Recorder engine and hardware; places less load on the Recorder than RecorderStatus
    .PARAMETER ActiveConnection
        Structure containing the site root URL of the Recorder's current active connection. If there is no such connection, a 404 Not Found will be returned.
    .PARAMETER ActiveSchedulerConnection
        Structure containing the site root URL of the Recorder's current active scheduler connection. If there is no such connection, a 404 Not Found will be returned.
    .PARAMETER ScheduledRecordingTimes
        List of scheduled recordings for this Recorder, ordered by start-time. By default the list spans a week starting from the current day. The start-time of the query can be specified with a filter clause (StartTime ge datetime'YYYY-MM-DD') and the end-time with a clause (EndTime le datetime'YYYY-MM-DD'). Excluded recording sessions can be omitted from the result by including the filter clause (IsExcluded eq false).
    .PARAMETER ActiveInputs
        Active hardware input(s) being used for the current recording.
    .PARAMETER SyncPresenceOnInputs
        List of all inputs the device is aware of. Properties indicate which ones are currently in use as well as which ones currently have a signal.
    .PARAMETER CurrentPresentationMetadata
        Metadata for the current recording including title, start datetime, and if a schedule is available, linked modules and presenter names.
    .PARAMETER TimeRemaining
        Time in seconds remaining until the current presentation will auto-stop. A status value is returned if the current presentation will not auto-stop.
    .PARAMETER AudioLevels
        The current audio level (decibels below full scale). Future: an RMS average of the last 5 seconds (dbfs).
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
    http://sofo.mediasite.com/mediasite/api/v1/$metadata#Recorders

#>
	Param
	(
		[string]$id,
		[string]$id2,
		[switch]$LicenseStatus,
		[switch]$Status,
		[switch]$ExtendedStatus,
		[switch]$ActiveConnection,
		[switch]$ActiveSchedulerConnection,
		[switch]$ScheduledRecordingTimes,
		[switch]$ActiveInputs,
		[switch]$SyncPresenceOnInputs,
		[switch]$CurrentPresentationMetadata,
		[switch]$TimeRemaining,
		[switch]$AudioLevels,
		[switch]$SyncSchedules,
		[switch]$Start,
		[switch]$Stop,
		[switch]$Pause,
		[switch]$Resume,
		[switch]$GetOrCreatePresentation,
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
		$targets = @("","LicenseStatus","Status","ExtendedStatus","ActiveConnection","ActiveSchedulerConnection","ScheduledRecordingTimes","ActiveInputs","SyncPresenceOnInputs","CurrentPresentationMetadata","TimeRemaining","AudioLevels","SyncSchedules","Start","Stop","Pause","Resume","GetOrCreatePresentation")

        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
		
		return processrequest -name $($MyInvocation.MyCommand) -p $PsBoundParameters -parameterlist $ParameterList -verbose -targets $targets
}
