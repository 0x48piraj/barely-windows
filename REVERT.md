# Guide: How to Revert Changes

This guide will help you revert any changes made by Barely Windows.


## Reinstalling Apps

Most applications removed by Barely Windows can be easily reinstalled through the [Microsoft Store](https://apps.microsoft.com/home) or their official websites. Additionally, you can use [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) to reinstall apps.

The only exceptions I know of are the **Microsoft Store** itself and the `XboxSpeechToTextOverlay`, which may not be easily reinstated.

If you have uninstalled the Microsoft Store, please follow [this guide](https://www.elevenforum.com/t/uninstall-or-reinstall-microsoft-store-app-in-windows-10-and-windows-11.11428/) for re-installation instructions.


## Re-enable Bing Web Search

Bing Web Search in Windows Search can be restored by running the `Enable_Bing_Cortana_In_Search.reg` file that is provided by the tool, You can find it by navigating to `Regfiles` > `Undo`.

Alternatively these registry files can be individually viewed and downloaded [here](/RegFiles/Undo).

If your Windows Region is set to a country within the **EEA (European Economic Area)** you may also need to reinstall the [Web Search from Microsoft Bing](https://apps.microsoft.com/detail/9nzbf4gt040c) app. Ensure this app is enabled in the Windows Search settings.

Please note that you may need to sign out of your user account or restart your PC to apply the changes.


## Other changes

All of the other changes can be reverted by using the registry files that are provided with the script, these registry files can be found by navigating to `Regfiles` > `Undo`. 

Alternatively these registry files can be individually viewed and downloaded [here](/RegFiles/Undo).

Simply run the registry file that applies to the setting you want to revert, and you're done!

Please note that you may need to sign out of your user account or restart your PC to apply the changes.