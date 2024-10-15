document.addEventListener("DOMContentLoaded", () => {
    // Initialize the modal
    const modalElem = document.querySelector('#errorModal') as HTMLElement;
    const modalInstance = M.Modal.init(modalElem);
    const form = document.getElementById("configForm") as HTMLFormElement;
    const output = document.getElementById("output") as HTMLPreElement;
    const generateConfigButton = document.getElementById("generateConfig") as HTMLButtonElement;
    const downloadConfigButton = document.getElementById("downloadConfig") as HTMLButtonElement;
    const errorText = document.getElementById("errorText") as HTMLParagraphElement;

    const config: {
        bloatwareRemoval: boolean;
        disableTelemetry: boolean;
        disableAds: boolean;
        disableBing: boolean;
        disableCopilot: boolean;
        showFileExtensions: boolean;
        hide3DObjects: boolean;
        disableWidgets: boolean;
        hideChat: boolean;
        fpsBoost: boolean;
        windowsVersion: string | null;
    } = {
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
    };

    // Capture checkbox selections
    form.addEventListener("change", (event) => {
        const target = event.target as HTMLInputElement;
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
    document.getElementById("windows10")!.addEventListener("click", () => {
        config.windowsVersion = "Windows 10";
        document.getElementById("windows10Options")!.style.display = "block"; // Show Windows 10 options
        document.getElementById("windows11Options")!.style.display = "none";  // Hide Windows 11 options
        updateOutput();
    });

    document.getElementById("windows11")!.addEventListener("click", () => {
        config.windowsVersion = "Windows 11";
        document.getElementById("windows11Options")!.style.display = "block"; // Show Windows 11 options
        document.getElementById("windows10Options")!.style.display = "none";  // Hide Windows 10 options
        updateOutput();
    });

    // Generate JSON configuration with validation
    generateConfigButton.addEventListener("click", () => {
        if (!config.windowsVersion) {
            errorText.innerText = 'Please select either Windows 10 or Windows 11.';
            modalInstance.open(); // Open the modal if no version is selected
            return;
        } else if (!(
            config.bloatwareRemoval ||
            config.disableTelemetry ||
            config.disableAds ||
            config.disableBing ||
            config.disableCopilot ||
            config.showFileExtensions ||
            config.hide3DObjects ||
            config.disableWidgets ||
            config.hideChat ||
            config.fpsBoost
        )) {
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
        a.download = 'bloatware_config.json';
        a.click();
        
        URL.revokeObjectURL(url); // Clean up the URL object
    });

    // Update output display
    function updateOutput() {
        output.textContent = JSON.stringify(config, null, 2);
    }
});
