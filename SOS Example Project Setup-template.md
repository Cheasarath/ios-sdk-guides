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

__NOTE__: By default this settings file contains placeholder values.  If the credentials here are not valid when starting a session, you will see an error.

## Using the SOSExamples Project

This sample application is designed to showcase how you might approach integrating SOS into your application. This application is almost entirely wired together via the storyboard. Most code that you will find in the project is specifically related to an SOS integration.

### Layout

In the SOSExamples.xcworkspace explorer you will see several groups.

* Common: `Corresponds to all code which is common to every example target`
* Common/SOS: `Code here is used as a light wrapper over standard UI SDK classes.`

You will also see groups for each of the project targets. Code found in these groups are specific to those targets.

For example, the SOSApplication.m file found in `1. Integrate SOS` will only be run for its similarly named target.

### Running the project

As mentioned in the __Layout__ section, there are several targets which correspond to diffent examples of SOS integration.

Each target references an `SOSApplication.m` file which is compiled and linked in for that target. Each example (target) is heavily documented inline, so please see the associated `SOSApplication.m` files for details about how each example works.

Each example will install a separate application on your device, so you can have all of them available to you at once.

## The Examples

### Common Elements

##### Field Masking

Field masking is implemented in the project in the "Compose" view and is handled entirely in the storyboard. The text field adjacent to the "To:" label is given a custom class of `SOSMaskedTextField` and will display the field masking functionality once in an SOS session.

### 1. Integrate SOS

Code can be found in the group:

* `1. Integrate SOS/SOSApplication.m`

This example shows a very basic integration of SOS with no customization.

### 2. Customize (Basic)

Code can be found in the group:

* `2. Customize (Basic)/SOSApplication.m`

This example shows how you can customize the language of SOS messages, and change
basic things like the line width/color for the Agent annotations

### 3. Customize (Advanced)

Code can be found in the group:

* `3. Customize (Advanced)/SOSApplication.m`

This example shows how you can replace and reskin the standard default UI elements SOS provides.
This example also demonstrates how you can replace specifc (or all) UIAlerts with custom UI Elements.

Please refer to the following classes for examples.

From the iOS Documentation the SOSAlert.h exposes the interface to allow you to implement a UIAlert replacement for our framework. http://sos.goinstant.com/pilot/ios/documentation/Protocols/SOSAlert.html

The implementation example in the SOS Guides can be found with the MyAlert class defined in the advanced application found [here](https://github.com/goinstant/sos-guides/blob/master/Guides/integrate-sos/SOSApplication.m)
