# Barely Windows: Transform Your Windows Experience!

Say goodbye to the clutter and hello to performance with Barely Windows, the intuitive web-based GUI editor designed to streamline your Windows 10 and 11 experience. Effortlessly remove pesky pre-installed bloatware and disable intrusive telemetry, all while boosting your gaming performance with our powerful FPS optimization tools.

With just a few clicks, you can declutter and enhance your system, ensuring it runs smoother and faster than ever. Elevate your Windows experience—get started with Barely Windows today!

Barely Windows isn’t just for everyday users; it’s packed with features that system administrators will love! Take advantage of Windows Audit mode support and run scripts seamlessly without requiring any user input during runtime. Whether you’re managing multiple systems or fine-tuning individual setups, Barely Windows offers the flexibility and control you need to optimize your Windows environment efficiently. Windows 10 and Windows 11 often come with privacy concerns and security vulnerabilities right out of the box. Recognizing this, leading organizations like [Microsoft](https://microsoft.com), [Cyber.mil](https://public.cyber.mil), the [Department of Defense](https://dod.gov), and the [National Security Agency](https://www.nsa.gov/) have outlined essential configuration changes to lock down and harden these operating systems. Barely Windows is designed to automate these critical recommendations, ensuring your system is fortified against potential threats.

> [!Tip]
> All of the changes made by **Barely Windows** can easily be reverted and almost all of the apps can be reinstalled through the Microsoft Store. A full guide on how to revert changes can be found [here](https://github.com/0x48piraj/barely-windows/REVERT.md).


#### Did this tool help you?

- Think about making a tiny one-time contribution to keep enjoying **Barely Windows** with extended support.
- If not, please give this repository a star (⭐) and follow me on GitHub to stay updated!


## Features

#### Bloatware Removal

- Remove a wide variety of bloatware apps.

#### Telemetry, Tracking & Suggested Content

- Disable telemetry, diagnostic data, activity history, app-launch tracking & targeted ads.
- Disable tips, tricks, suggestions and ads in start, settings, notifications, File Explorer, and on the lockscreen.

#### Bing Web Search, Copilot & More

- Disable & remove Bing web search & Cortana from Windows search.
- Disable & remove Windows Copilot. (Windows 11 only)
- Disable Windows Recall snapshots. (Windows 11 only)

#### File Explorer

- Show hidden files, folders and drives.
- Show file extensions for known file types.

#### Taskbar

- Align taskbar icons to the left. (Windows 11 only)
- Hide or change the search icon/box on the taskbar. (Windows 11 only)
- Hide the taskview button from the taskbar. (Windows 11 only)
- Disable the widgets service & hide icon from the taskbar.
- Hide the chat (meet now) icon from the taskbar.


## Default selection

The default selection applies the changes that are recommended for most users, expand the section below for more info.

<details>
  <summary>Click to expand</summary>

  #### Apps that ARE removed by default
  
  <details>
    <summary>Click to expand</summary>
    <blockquote>
      
      Microsoft bloat:
      - Clipchamp.Clipchamp  
      - Microsoft.3DBuilder  
      - Microsoft.549981C3F5F10 (Cortana app)
      - Microsoft.BingFinance  
      - Microsoft.BingFoodAndDrink 
      - Microsoft.BingHealthAndFitness
      - Microsoft.BingNews  
      - Microsoft.BingSearch* (Bing web search in Windows)
      - Microsoft.BingSports  
      - Microsoft.BingTranslator  
      - Microsoft.BingTravel   
      - Microsoft.BingWeather  
      - Microsoft.Getstarted (Cannot be uninstalled in Windows 11)
      - Microsoft.Messaging  
      - Microsoft.Microsoft3DViewer  
      - Microsoft.MicrosoftJournal
      - Microsoft.MicrosoftOfficeHub  
      - Microsoft.MicrosoftPowerBIForWindows  
      - Microsoft.MicrosoftSolitaireCollection  
      - Microsoft.MicrosoftStickyNotes  
      - Microsoft.MixedReality.Portal  
      - Microsoft.NetworkSpeedTest  
      - Microsoft.News  
      - Microsoft.Office.OneNote (Discontinued UWP version only, does not remove new MS365 versions)
      - Microsoft.Office.Sway  
      - Microsoft.OneConnect  
      - Microsoft.Print3D  
      - Microsoft.SkypeApp  
      - Microsoft.Todos  
      - Microsoft.WindowsAlarms  
      - Microsoft.WindowsFeedbackHub  
      - Microsoft.WindowsMaps  
      - Microsoft.WindowsSoundRecorder  
      - Microsoft.XboxApp (Old Xbox Console Companion App, no longer supported)
      - Microsoft.ZuneVideo  
      - MicrosoftCorporationII.MicrosoftFamily (Microsoft Family Safety)
      - MicrosoftTeams (Old personal version of MS Teams from the MS Store)
      - MSTeams (New MS Teams app)
  
      Third party bloat:
      - ACGMediaPlayer  
      - ActiproSoftwareLLC  
      - AdobeSystemsIncorporated.AdobePhotoshopExpress  
      - Amazon.com.Amazon  
      - AmazonVideo.PrimeVideo
      - Asphalt8Airborne   
      - AutodeskSketchBook  
      - CaesarsSlotsFreeCasino  
      - COOKINGFEVER  
      - CyberLinkMediaSuiteEssentials  
      - DisneyMagicKingdoms  
      - Disney 
      - Dolby  
      - DrawboardPDF  
      - Duolingo-LearnLanguagesforFree  
      - EclipseManager  
      - Facebook  
      - FarmVille2CountryEscape  
      - fitbit  
      - Flipboard  
      - HiddenCity  
      - HULULLC.HULUPLUS  
      - iHeartRadio  
      - Instagram
      - king.com.BubbleWitch3Saga  
      - king.com.CandyCrushSaga  
      - king.com.CandyCrushSodaSaga  
      - LinkedInforWindows  
      - MarchofEmpires  
      - Netflix  
      - NYTCrossword  
      - OneCalendar  
      - PandoraMediaInc  
      - PhototasticCollage  
      - PicsArt-PhotoStudio  
      - Plex  
      - PolarrPhotoEditorAcademicEdition  
      - Royal Revolt  
      - Shazam  
      - Sidia.LiveWallpaper  
      - SlingTV  
      - Speed Test  
      - Spotify  
      - TikTok
      - TuneInRadio  
      - Twitter  
      - Viber  
      - WinZipUniversal  
      - Wunderlist  
      - XING
      
      * App is removed when disabling Bing in Windows search.
  </blockquote>
  </details>
  
  #### Apps that are NOT removed by default
  
  <details>
    <summary>Click to expand</summary>
    <blockquote>
      
      General apps that are not removed by default:
      - Microsoft.Edge (Edge browser, only removeable in the EEA)
      - Microsoft.GetHelp (Required for some Windows 11 Troubleshooters)
      - Microsoft.MSPaint (Paint 3D)
      - Microsoft.OutlookForWindows* (New mail app)
      - Microsoft.OneDrive (OneDrive consumer)
      - Microsoft.Paint (Classic Paint)
      - Microsoft.People* (Required for & included with Mail & Calendar)
      - Microsoft.ScreenSketch (Snipping Tool)
      - Microsoft.Whiteboard (Only preinstalled on devices with touchscreen and/or pen support)
      - Microsoft.Windows.Photos
      - Microsoft.WindowsCalculator
      - Microsoft.WindowsCamera
      - Microsoft.windowscommunicationsapps* (Mail & Calendar)
      - Microsoft.WindowsStore (Microsoft Store, NOTE: This app cannot be reinstalled!)
      - Microsoft.WindowsTerminal (New default terminal app in Windows 11)
      - Microsoft.YourPhone (Phone Link)
      - Microsoft.Xbox.TCUI (UI framework, removing this may break MS store, photos and certain games)
      - Microsoft.ZuneMusic (Modern Media Player)
      - MicrosoftWindows.CrossDevice (Phone integration within File Explorer, Camera and more)
  
      Gaming related apps that are not removed by default:
      - Microsoft.GamingApp* (Modern Xbox Gaming App, required for installing some games)
      - Microsoft.XboxGameOverlay* (Game overlay, required for some games)
      - Microsoft.XboxGamingOverlay* (Game overlay, required for some games)
      - Microsoft.XboxIdentityProvider (Xbox sign-in framework, required for some games)
      - Microsoft.XboxSpeechToTextOverlay (Might be required for some games, NOTE: This app cannot be reinstalled!)
  
      Developer related apps that are not removed by default:
      - Microsoft.PowerAutomateDesktop*
      - Microsoft.RemoteDesktop*
      - Windows.DevHome*
  
      * Can be removed by running the tool with the relevant option.
  </blockquote>
  </details>
</details>


## Usage

> [!Warning]
> Great care went into making sure this script does not unintentionally break any OS functionality, but use at your own risk!

### Quick method

Download & run the script automatically via PowerShell. All traces of the script are removed automatically after execution.

1. Open PowerShell as an administrator in the same folder where you downloaded the `bw.config.json` from the [web-app](https://github.com/0x48piraj/barely-windows).
2. Copy and paste the code below into PowerShell, press enter to run the script:

```PowerShell
& ([scriptblock]::Create((irm "https://bw.piyushraj.org/")))
```

3. Wait for the command to automatically download the latest **Barely Windows**.
4. Profit!

### Traditional method

Manually download the script & run the script via PowerShell. Only recommended for advanced users.

1. [Download the latest version of the script](https://github.com/0x48piraj/barely-windows/archive/master.zip), and extract the .ZIP file to your desired location.
2. Navigate to the `barely-windows` folder, copy the `bw.config.json` from the [web-app](https://github.com/0x48piraj/barely-windows) to the same folder.
3. Open PowerShell as an administrator in the same folder.
4. Temporarily enable PowerShell execution by entering the following command:

```PowerShell
Set-ExecutionPolicy Unrestricted -Scope Process
```
5. Now run the script by entering the following command:

```PowerShell
.\launcher.ps1
```

6. Profit!

### Acknowledgements

This is based on [Win11Debloat](https://github.com/Raphire/Win11Debloat) by Jeffrey [(@Raphire](https://github.com/Raphire)).

### License

[The Beer-Ware License (Revision 42)](LICENSE)