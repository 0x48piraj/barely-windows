"use strict";
document.addEventListener("DOMContentLoaded", () => {
    // Initialize the modal
    const modalElem = document.querySelector('#errorModal');
    const modalInstance = M.Modal.init(modalElem);
    const form = document.getElementById("configForm");
    const output = document.getElementById("output");
    const generateConfigButton = document.getElementById("generateConfig");
    const downloadConfigButton = document.getElementById("downloadConfig");
    const errorText = document.getElementById("errorText");
    const appListContainer = document.getElementById("appListContainer");
    const preConfiguredApps = {
        safe: [
            "Clipchamp.Clipchamp",
            "Microsoft.3DBuilder",
            "Microsoft.549981C3F5F10", // Cortana app
            "Microsoft.BingFinance",
            "Microsoft.BingFoodAndDrink",
            "Microsoft.BingHealthAndFitness",
            "Microsoft.BingNews",
            "Microsoft.BingSports",
            "Microsoft.BingTranslator",
            "Microsoft.BingTravel",
            "Microsoft.BingWeather",
            "Microsoft.Messaging",
            "Microsoft.Microsoft3DViewer",
            "Microsoft.MicrosoftJournal",
            "Microsoft.MicrosoftOfficeHub",
            "Microsoft.MicrosoftPowerBIForWindows",
            "Microsoft.MicrosoftSolitaireCollection",
            "Microsoft.MicrosoftStickyNotes",
            "Microsoft.MixedReality.Portal",
            "Microsoft.NetworkSpeedTest",
            "Microsoft.News",
            "Microsoft.Office.OneNote",
            "Microsoft.Office.Sway",
            "Microsoft.OneConnect",
            "Microsoft.Print3D",
            "Microsoft.SkypeApp",
            "Microsoft.Todos",
            "Microsoft.WindowsAlarms",
            "Microsoft.WindowsFeedbackHub",
            "Microsoft.WindowsMaps",
            "Microsoft.WindowsSoundRecorder",
            "Microsoft.XboxApp", // Old Xbox Console Companion App, no longer supported
            "Microsoft.ZuneVideo",
            "MicrosoftCorporationII.MicrosoftFamily", // Family Safety App
            "MicrosoftCorporationII.QuickAssist",
            "MicrosoftTeams", // Old MS Teams personal (MS Store)
            "MSTeams", // New MS Teams app
            "Microsoft.Getstarted", // Exclude Microsoft.Getstarted for Windows 11
            "ACGMediaPlayer",
            "ActiproSoftwareLLC",
            "AdobeSystemsIncorporated.AdobePhotoshopExpress",
            "Amazon.com.Amazon",
            "AmazonVideo.PrimeVideo",
            "Asphalt8Airborne",
            "AutodeskSketchBook",
            "CaesarsSlotsFreeCasino",
            "COOKINGFEVER",
            "CyberLinkMediaSuiteEssentials",
            "DisneyMagicKingdoms",
            "Disney",
            "DrawboardPDF",
            "Duolingo-LearnLanguagesforFree",
            "EclipseManager",
            "Facebook",
            "FarmVille2CountryEscape",
            "fitbit",
            "Flipboard",
            "HiddenCity",
            "HULULLC.HULUPLUS",
            "iHeartRadio",
            "Instagram",
            "king.com.BubbleWitch3Saga",
            "king.com.CandyCrushSaga",
            "king.com.CandyCrushSodaSaga",
            "LinkedInforWindows",
            "MarchofEmpires",
            "Netflix",
            "NYTCrossword",
            "OneCalendar",
            "PandoraMediaInc",
            "PhototasticCollage",
            "PicsArt-PhotoStudio",
            "Plex",
            "PolarrPhotoEditorAcademicEdition",
            "Royal Revolt",
            "Shazam",
            "Sidia.LiveWallpaper",
            "SlingTV",
            "Spotify",
            "TikTok",
            "TuneInRadio",
            "Twitter",
            "Viber",
            "WinZipUniversal",
            "Wunderlist",
            "XING",
        ],
        scrub: [
            "Microsoft.BingSearch", // Web Search from Microsoft Bing (Integrates into Windows Search)
            "Microsoft.Copilot", // New Windows Copilot app
            "Microsoft.Edge", // Edge browser (Can only be uninstalled in European Economic Area)
            "Microsoft.GetHelp", // Required for some Windows 11 Troubleshooters
            "Microsoft.MSPaint", // Paint 3D
            "Microsoft.OneDrive", // OneDrive consumer
            "Microsoft.Paint", // Classic Paint
            "Microsoft.ScreenSketch", // Snipping Tool
            "Microsoft.Whiteboard", // Only preinstalled on devices with touchscreen and/or pen support
            "Microsoft.Windows.Photos", // Photos app
            "Microsoft.WindowsCalculator", // Calculator app
            "Microsoft.WindowsCamera", // Camera app
            "Microsoft.WindowsStore", // Microsoft Store, WARNING: This app cannot be reinstalled!
            "Microsoft.WindowsTerminal", // New default terminal app in Windows 11
            "Microsoft.Xbox.TCUI", // UI framework, required for MS Store, Photos, and certain games
            "Microsoft.XboxIdentityProvider", // Xbox sign-in framework, required for some games
            "Microsoft.XboxSpeechToTextOverlay", // Might be required for some games, WARNING: This app cannot be reinstalled!
            "Microsoft.YourPhone", // Phone link
            "Microsoft.ZuneMusic", // Modern Media Player
            "MicrosoftWindows.CrossDevice", // Phone integration within File Explorer, Camera, and more
        ],
        experimental: [
            "Microsoft.GamingApp", // Modern Xbox Gaming App, required for installing some PC games
            "Microsoft.OutlookForWindows", // New mail app: Outlook for Windows
            "Microsoft.People", // Required for & included with Mail & Calendar
            "Microsoft.PowerAutomateDesktop", // Automation tool for desktop
            "Microsoft.RemoteDesktop", // Remote desktop application
            "Microsoft.Windows.DevHome", // Windows Dev Home tool
            "Microsoft.windowscommunicationsapps", // Mail & Calendar
            "Microsoft.XboxGameOverlay", // Game overlay, required/useful for some games
            "Microsoft.XboxGamingOverlay", // Game overlay, required/useful for some games
        ],
    };
    const config = {
        bloatwareRemoval: false,
        disableTelemetry: false,
        disableAds: false,
        disableBing: false,
        disableCopilot: false,
        showFileExtensions: false,
        hide3DObjects: false,
        disableWidgets: false,
        hideChat: false,
        fpsBoost: false,
        windowsVersion: null,
        bloatwareApps: [],
    };
    // Add event listener for the pre-configuration dropdown
    appListContainer.addEventListener("change", () => {
        const selectedValue = appListContainer.value;
        // Check if selected value is a key in preConfiguredApps
        if (selectedValue in preConfiguredApps) {
            // Update the config object or handle it as needed
            config.bloatwareRemoval = true; // Enable bloatware removal if any option is selected
            if (!config.windowsVersion) {
                errorText.innerText = 'Please select either Windows 10 or Windows 11.';
                modalInstance.open(); // Open the modal if no version is selected
                appListContainer.value = ""; // Reset to default selection
                return;
            }
            // Remove Microsoft.Getstarted if Windows 11 is selected
            if (config.windowsVersion === "windows11") {
                config.bloatwareApps = preConfiguredApps[selectedValue].filter(app => app !== "Microsoft.Getstarted");
            }
            else {
                config.bloatwareApps = preConfiguredApps[selectedValue]; // Store selected apps
            }
            // Update output display to reflect the changes
            updateOutput();
        }
    });
    // Capture checkbox selections
    form.addEventListener("change", (event) => {
        const target = event.target;
        switch (target.id) {
            case "removeBloatware":
                config.bloatwareRemoval = target.checked;
                break;
            case "disableTelemetry":
                config.disableTelemetry = target.checked;
                break;
            case "disableAds":
                config.disableAds = target.checked;
                break;
            case "disableBing":
                config.disableBing = target.checked;
                break;
            case "disableCopilot":
                config.disableCopilot = target.checked;
                break;
            case "showFileExtensions":
                config.showFileExtensions = target.checked;
                break;
            case "hide3DObjects":
                config.hide3DObjects = target.checked;
                break;
            case "disableWidgets":
                config.disableWidgets = target.checked;
                break;
            case "hideChat":
                config.hideChat = target.checked;
                break;
            case "fpsBoost":
                config.fpsBoost = target.checked;
                break;
        }
        updateOutput();
    });
    // Capture Windows version selection
    document.getElementById("windows10").addEventListener("click", () => {
        config.windowsVersion = "windows10";
        document.getElementById("windows10Options").style.display = "block"; // Show Windows 10 options
        document.getElementById("windows11Options").style.display = "none"; // Hide Windows 11 options
        updateOutput();
    });
    document.getElementById("windows11").addEventListener("click", () => {
        config.windowsVersion = "windows11";
        document.getElementById("windows11Options").style.display = "block"; // Show Windows 11 options
        document.getElementById("windows10Options").style.display = "none"; // Hide Windows 10 options
        updateOutput();
    });
    // Generate JSON configuration with validation
    generateConfigButton.addEventListener("click", () => {
        if (!config.windowsVersion) {
            errorText.innerText = 'Please select either Windows 10 or Windows 11.';
            modalInstance.open(); // Open the modal if no version is selected
            return;
        }
        else if (!(config.bloatwareRemoval ||
            config.disableTelemetry ||
            config.disableAds ||
            config.disableBing ||
            config.disableCopilot ||
            config.showFileExtensions ||
            config.hide3DObjects ||
            config.disableWidgets ||
            config.hideChat ||
            config.fpsBoost ||
            config.bloatwareApps.length > 0)) {
            errorText.innerText = 'No options are selected.';
            modalInstance.open(); // Open the modal if no options are selected
            return;
        }
        const jsonConfig = JSON.stringify(config, null, 2);
        output.textContent = jsonConfig;
        downloadConfigButton.style.display = 'inline'; // Show download button
    });
    // Download JSON configuration
    downloadConfigButton.addEventListener("click", () => {
        const jsonConfig = JSON.stringify(config, null, 2);
        const blob = new Blob([jsonConfig], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'bw.config.json';
        a.click();
        URL.revokeObjectURL(url); // Clean up the URL object
    });
    // Update output display
    function updateOutput() {
        output.textContent = JSON.stringify(config, null, 2);
    }
});
