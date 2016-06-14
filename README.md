# SOS Example Project

## Preamble

This guide assumes you have done the following from the __Prerequisites__ section of the SOS documentation landing page.

1. Cocoapods is installed.
2. The SOS [pods-specs-public](https://github.com/goinstant/pods-specs-public) repository as been added to your cocoapods list of repositories.
3. You have valid credentials for a Salesforce.com org, as well as the SOS account/application information that was provided to you during the setup process.
4. You are using [Xcode 6](https://developer.apple.com/xcode/downloads/) or higher.

## Getting Started

This section will detail how to retrieve and setup the SOS Example project.

### Retreiving the project

You can find and clone the example project from github here: [sos-guides on Github](https://github.com/goinstant/sos-guides)

Simply clone this project and run `pod install`

### SOSSettings.plist

In the SOSExamples.xcworkspace you will see a `SOSSettings.plist` file in the explorer.
This contains the information you will need to successfully start an SOS session.

This settings file contains several fields. These fields correspond to information retrieved in your org.

Please see [this](http://sos.goinstant.com/pilot/documentation/docs/guides/User%20Guide%201.%20Service%20Cloud%20Org%20Configuration.html) page on configuring your org for SOS to retrieve these values.

In addition to the SOS org configuration, there are fields to enable various custom UI elements for SOS. These will instruct SOS to load the custom classes built within this app instead of the default UI the SOS SDK provides.


__NOTE__: By default this settings file contains placeholder values.  If the credentials here are not valid when starting a session, you will see an error.

## Using the SOSExamples Project

__NOTE__ CocoaPods creates or updates the `SOSExamples.xcworkspace` file. You need to use this file to load and build the project. The `SOSExamples.xcodeproj` will not work on its own.

This sample application is designed to showcase how you might approach integrating SOS into your application. This application is almost entirely wired together via the storyboard. Most code that you will find in the project is specifically related to an SOS integration.

