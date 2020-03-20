# MediasitePS
Mediasite Powershell Module

## Overview
The module is generated using: ModuleCreator.ps1  
It gets the metadata for the Mediasite Api from /api/v1/$metadata on the Mediasite server and then generates functions for each of the available Resources (eg. Recorders, Presentations and Home).  Each resource supports the GET, POST, PUT, PATCH and DELETE verbs for routes that support it (GET is the default if not specified).  Sub routes are handled by arguments passed to the resource function.  For example Folders supports the arguments UpdatePermissions, UpdateOwner and DeleteFolder.  

## Get started

open powershell and cd to the folder you want to clone it to
```
> git clone https://github.com/wunde005/MediasitePS
```
Load module and follow prompts:
```
> Import-Module .\MediasitePS\MediasitePS\mediasiteps
auth_file:
WARNING: Auth file not submitted.  Either re-import with the auth file specified or follow the prompts to create a new
one.
Example import with auth file: import-module MediasitePS -ArgumentList .\tmp\auth.xml

mediasite uri(https://<servername>/mediasite): https://<yourserver>/mediasite

Info on the API can be found here: https://<yourserver>/mediasite/api/v1/$metadata#top

Go here to create a API key: https://<yourserver>/mediasite/api/Docs/ApiKeyRegistration.aspx

Enter API Key: <your api key>
What is your username?: <your username>
What is your password?: <your password>
get Application Ticket?(Y/n): y
username to use for ticket (leave blank to use current username): MediasiteAdmin
finding profile id for MediasiteAdmin
write authfile?(Y/n): y
auth file: testauth.xml <enter a filename for the auth info>
```
check it is working
```
> Home

odata.metadata                         : https://<your server>/Mediasite/Api/v1/$metadata#Home/@Element
odata.id                               : https://<your server>/Mediasite/Api/v1/Home
NowPlaying@odata.navigationLinkUrl     : https://<your server>/Mediasite/Api/v1/Home('7.2.3.0')/NowPlaying
RecentlyViewed@odata.navigationLinkUrl : https://<your server>/Mediasite/Api/v1/Home('7.2.3.0')/RecentlyViewed
#ChangePassword                        : @{target=https://<your server>/Mediasite/Api/v1/Home('7.2.3.0')/Chang
                                         ePassword}
ApiVersion                             : 7.2.3.0
ApiPublishedDate                       : 2020-03-20T16:25:12.485241Z
SiteName                               : Mediasite
SiteDescription                        :
SiteVersion                            : 7.2.2
SiteBuildNumber                        : 3914
....
....

```
Next time you load it use:
```
> Import-Module .\MediasitePS\MediasitePS\mediasiteps -ArgumentList .\testauth.xml
```

### Here are a few examples of the route and the corresponding powershell command:  
     
Description:&nbsp;Lists presentations related to this one  
API Route:&nbsp;&nbsp;&nbsp;&nbsp;GET /api/v1/Presentations('id')/RelatedPresentations  
PowerShell:&nbsp;&nbsp;Presentations -id "000bc599961f42eb9f073cfef3b5567b1d" -relatedpresentations  

Description:&nbsp;Lists presentations in a folder  
API Route:&nbsp;&nbsp;&nbsp;&nbsp;GET /api/v1/Folders('id')/Presentations  
PowerShell:&nbsp;&nbsp;Folders -id "008f12080cf94cffaa3c828abced39c914" -presentations  

Description:&nbsp;Create folder  
API Route:&nbsp;&nbsp;&nbsp;&nbsp;POST /api/v1/Folders  
PowerShell:&nbsp;&nbsp;Folders -post -data @{"Name"="New Folder";"ParentFolderId"="572ac9bbd7954bdcae91421ac88f0b2d14"}  

Description:&nbsp;Get tag for presentation specified by id2  
API Route:&nbsp;&nbsp;&nbsp;&nbsp;GET /api/v1/Presentations('id1')/Tags(id2)  
PowerShell:&nbsp;&nbsp;Presentations -id "001b651ea7dc4e288d331a1a225270901d" -Tags -id2 34

Additional supported switches on resources

| Switch | Description | 
| --- | --- |
| all | returns all pages | 
| next | returns next data page |
| full | uses $select=full |
| rawoutput | returns raw data from api |
| noaddmethod | skips the adding of methods |

Additional Arguments

| Argument | Description | Type | 
| --- | --- | --- |
| filter | OData formated filter | string |
| top | Size of page. API Default 10 | int |
| cmd | Full route command | string |
| data | Hashtable data for POST,PUT,PATCH | hashtable |

## MediasitePS loading

The module will need a authentication xml file when loaded.  The file contains the Mediasite api key (sfapikey), the uri for the server (uri) and either a basic auth(authorization) or ticket(MediasiteApplicationTicket).  If it isn't supplied it will prompt for the required info and allow you to save it to a xml file.  There are also some examples of the auth file in [examples](examples).  The prompt generated file with a ticket will encrypt the ticket under the "SecMediasiteApplicationTicketTxt" entry.  The credentials should only work on the computer and computer user the the ticket was originally created under.

Loading example:
```
PS C:\> cd .\devel\mediasiteps
PS C:\devel\mediasiteps>Import-Module .\MediasitePS -ArgumentList ".\tmp\authma.xml"
auth_file:.\tmp\authma.xml
Loading auth from: .\tmp\authma.xml
PS C:\devel\mediasiteps> 
```

## Methods on objects
Methods are added to the returned objects.  
 * 'get' script blocks for <name>@odata.navigationLinkUrl links  
 * 'post' script block for #<name> links  
 * folders: folders script for getting list of subfolders  
 * home: rootfolder script for getting root mediasite folder  

Example showing added script methods and usage of folder.Parent() method
```
PS C:\devel\mediasiteps> $f = folders
Folders: 1916 of 1926 remaining. Use> Folders -next
PS C:\devel\mediasiteps> $f[0] | Get-Member -Type ScriptMethod


   TypeName: System.Management.Automation.PSCustomObject

Name              MemberType   Definition
----              ----------   ----------
DeleteFolder      ScriptMethod System.Object DeleteFolder();
Folders           ScriptMethod System.Object Folders();
Parent            ScriptMethod System.Object Parent();
Presentations     ScriptMethod System.Object Presentations();    
UpdateOwner       ScriptMethod System.Object UpdateOwner();
UpdatePermissions ScriptMethod System.Object UpdatePermissions();

PS C:\devel\mediasiteps> $f[0].Parent()


odata.metadata                        : https://<your server>/Mediasite/Api/v1/$metadata#Folders/@Element
odata.id                              : https://<your server>/Mediasite/Api/v1/Folders('9caa20f3ab1a4563a303f6
                                        104113ae2714')
Presentations@odata.navigationLinkUrl : https://<your server>/Mediasite/Api/v1/Folders('9caa20f3ab1a4563a303f6
                                        104113ae2714')/Presentations
#UpdatePermissions                    : @{target=https://<your server>/Mediasite/Api/v1/Folders('9caa20f3ab1a4
                                        563a303f6104113ae2714')/UpdatePermissions}
#UpdateOwner                          : @{target=https://<your server>/Mediasite/Api/v1/Folders('9caa20f3ab1a4
                                        563a303f6104113ae2714')/UpdateOwner}
#DeleteFolder                         : @{target=https://<your server>/Mediasite/Api/v1/Folders('9caa20f3ab1a4
                                        563a303f6104113ae2714')/DeleteFolder}
Id                                    : 9caa20f3ab1a4563a303f6104113ae2714
Name                                  : Mediasite Users
Owner                                 : MediasiteAdmin
Description                           : User Home Folder Root
CreationDate                          : 2014-08-13T15:01:52
LastModified                          : 2014-08-13T15:01:52
ParentFolderId                        : c3191d7bcf5d43fa97253d0e222efdfc14
Recycled                              : False
Type                                  : Folder, MyMediasiteRoot
IsShared                              : False
IsCopyDestination                     : False
IsReviewEditApproveEnabled            : False


```

```
PS C:\devel\mediasiteps> $nf =Folders -id "f5c5f11ae3b34f0593a793767f19a89014"
PS C:\devel\mediasiteps> $nf.DeleteFolder()


odata.metadata : https://<your server>/Mediasite/Api/v1/$metadata#Jobs/@Element
odata.id       : https://<your server>/Mediasite/Api/v1/Jobs('81b20d5c-adf6-4c93-864c-f010d66b98ac')
Id             : 81b20d5c-adf6-4c93-864c-f010d66b98ac
Status         : Queued
StatusMessage  :
JobType        : Mediasite.System.DeleteFolder.7_0_0

PS C:\devel\mediasiteps> 

```

## Paging
Paging is accessed through either a '-next' argument for that particualar resource or 'next' command that runs next for the last resource used.
```
PS C:\devel\mediasiteps> $f = folders
Folders: 1916 of 1926 remaining. Use> Folders -next
PS C:\devel\mediasiteps> $f += folders -next
Folders: 1906 of 1926 remaining. Use> Folders -next
PS C:\devel\mediasiteps> $f += next
Folders: 1896 of 1926 remaining. Use> Folders -next
PS C:\devel\mediasiteps>
```

The '-all' switch can be used to pull all pages at once
```
PS C:\devel\mediasiteps> $r = Recorders -all
Recorders: 5 of 15 remaining.
Recorders: 0 of 15 remaining.
PS C:\devel\mediasiteps> $r.count
15
PS C:\devel\mediasiteps> ($r |sort -Property name).name
CLA-Portable
CSOM_1-114
CSOM_1-115
CSOM_2-206
CSOM_2-207
CSOM_2-213
CSOM_2-215
CSOM_2-234
CSOM_2-260R
CSOM_2-260T
HMH_1-105
LAW-25
WILLEY_175
...
```

## Filters
Filter example:
```
PS C:\devel\mediasiteps> $prec =Presentations -filter "Status eq 'Recording'" -all -full
Presentations: 17 of 27 remaining.
Presentations: 7 of 27 remaining.
Presentations: 0 of 27 remaining.
PS C:\devel\mediasiteps> $prec[0].status
Recording
PS C:\devel\mediasiteps>

```

## Data

Post example:  
Required data is passed as a hashtable
```
PS C:\devel\mediasiteps> Folders -Post -data @{"Name"="New Folder";"ParentFolderId"="572ac9bbd7954bdcae91421ac88f0b2d14"}


odata.metadata                        : https://<your server>/Mediasite/Api/v1/$metadata#Folders/@Element
odata.id                              : https://<your server>/Mediasite/Api/v1/Folders('f5c5f11ae3b34f0593a793767f19a89014')
Presentations@odata.navigationLinkUrl : https://<your server>/Mediasite/Api/v1/Folders('f5c5f11ae3b34f0593a793767f19a89014')/Presentations
#UpdatePermissions                    : @{target=https://<your server>/Mediasite/Api/v1/Folders('f5c5f11ae3b34f0593a793767f19a89014')/UpdatePermissions 
                                        }
#UpdateOwner                          : @{target=https://<your server>/Mediasite/Api/v1/Folders('f5c5f11ae3b34f0593a793767f19a89014')/UpdateOwner}
#DeleteFolder                         : @{target=https://<your server>/Mediasite/Api/v1/Folders('f5c5f11ae3b34f0593a793767f19a89014')/DeleteFolder}     
Id                                    : f5c5f11ae3b34f0593a793767f19a89014
Name                                  : New Folder
Owner                                 : MediasiteAdmin
Description                           :
CreationDate                          : 2020-03-06T13:45:57.0000519
LastModified                          : 2020-03-06T13:45:57.0000519
ParentFolderId                        : 572ac9bbd7954bdcae91421ac88f0b2d14
Recycled                              : False
Type                                  : Folder
IsShared                              : False
IsCopyDestination                     : False
IsReviewEditApproveEnabled            : False


```
