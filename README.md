# Assistant for No Man's Sky (Android + iOS apps)
**Project Owner**: [Khaoz-Topsy](https://github.com/Khaoz-Topsy)

The **Assistant for No Man's Sky** is an app that gives users information about the game, such as crafting recipes, refiner recipes, item costs, blueprint costs, a portal library and guides. Almost all of the data is extracted from the **No Man's Sky** game files. This project would not be possible without the hard work of the NMS Modding community and the [MBinCompiler](https://github.com/monkeyman192/MBINCompiler).

#### Links
- [Website](https://nmsassistant.com)
- [Google Play Store](https://play.google.com/store/apps/details?id=com.kurtlourens.no_mans_sky_recipes, "Google Play Store")
- [Apple App Store Store](https://apps.apple.com/us/app/assistant-for-no-mans-sky/id1480287625, "Apple App Store")

- [Twitter](https://twitter.com/AssistantNMS?ref=nmsAssistantGithub)
- [Discord](https://assistantapps.com/discord?ref=nmsAssistantGithub)
- [Facebook](https://facebook.com/AssistantNMS?ref=nmsAssistantGithub)
- [Steam Community Page](https://steamcommunity.com/groups/AssistantNMS?ref=nmsAssistantGithub)

### Running the project
1. Rename the `env.dart.template` file to `env.dart`

### Contributing

### Builds (CI/CD)
The Mobile Apps are built and released to the [Google Play Store](https://play.google.com/store/apps/details?id=com.kurtlourens.no_mans_sky_recipes, "Google Play") and [Apple App Store Store](https://apps.apple.com/us/app/assistant-for-no-mans-sky/id1480287625, "Apple App Store") using [CodeMagic](https://codemagic.io).

- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5da07d2e7338b0000f046ba3/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5da07d2e7338b0000f046ba3/latest_build) - Android & iOS (Production)
- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5e180f76d95f1f258ec86619/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5da07d2e7338b0000f046ba3/latest_build) - Android (Production)
- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5d9da9057a0a9500105180be/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5d9da9057a0a9500105180be/latest_build) - Android (Alpha)
- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5d9dc56b7a0a95000a475d84/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5d9dc56b7a0a95000a475d84/latest_build) - iOS Build

__The iOS build on [CodeMagic](https://codemagic.io) generally reports that it has failed even though it actually successfully built and pushed the `.ipa` file to the Apple App Store. This is because they poll the App Store checking if the `.ipa` file is there and after a few attempts throw an error. So ignore build failures for anything that has to do with iOS 🙄.__


### History

> This app was originally released in early August 2019! The app was originally named No Man's Sky Recipes, when submitting the app to the Apple Store it was rejected due to the name and so the app was renamed.

> After 2 years of development and maintenance, the app was made open source so that the community to have greater control and oversight of what goes into the apps and hopefully some people might want to help fix bugs 😅


## Feature Requests / Issues / Bugs
Please feel free to let me know if there is an issue with the App by logging an issue here or sending an [email](mailto:nms@kurtlourens.com).

If you would like to help add languages to the app please make a pull request into this [repository](https://github.com/NoMansSkyAssistant/Languages) or send an [email](mailto:nms@kurtlourens.com).


