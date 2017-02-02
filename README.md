# AppBox SDK for iOS

## Introduction
Add AppBox SDK in your development/adhoc/enterprises iOS apps to get automatic update for apps uploaded via [AppBox-iOSAppsWirelessInstallation](http://tryappbox.com/).

## Prerequisites
Before you begin, please make sure that the following prerequisites are met:
* [AppBox for Mac](http://tryappbox.com/download)
* An iOS project that is set up in Xcode 7.0 on macOS 10.10 or later.
* The minimum OS target supported by the AppBox SDK is iOS 8.0 or later.
* If you are using cocoapods, please use cocoapods 1.1.1 or later.
* This readme assumes that you are using Objective-C or Swift 3 syntax and that you want to integrate all services.

## Integrate the SDK (using Cocoapods)

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like Mobile Center in your projects. To learn how to setup CocoaPods for your project, visit [the official CocoaPods website](http://cocoapods.org/).

1. Add the following to your podfile to include all services into your app. This will pull in AppBox SDK.

    ```
    platform :ios, '8.0'
    use_frameworks! 

    target '{Your Target Name}' do
      pod 'AppBox'
    end
    ```

1. Run pod install to install your newly defined pod, open your .xcworkspace and it's time to start the SDK and make use of the AppBox SDK.

## Start the SDK

To start the AppBox SDK in your app, follow these steps:

### 1. Get App Update Key
*  In order to use AppBox auto update service, you need to get app update key. For app update key, you need to upload your app with [AppBox](http://tryappbox.com) option [Keep same link url for all future build](https://iosappswirelessinstallation.codeplex.com/wikipage?title=KeepSameLink)

* When upload is complete, you'll get the a short url like this `https://goo.gl/jsr9JO`. Open this url in your macOS web browser. Here you will see a long url like this `http://i.tryappbox.com/?url=/s/49lsofdx9lsi61j/appinfo.json`.

* In long url after `/s/` and before `/appinfo.json` is your app update key, i.e - `49lsofdx9lsi61j` in this case. Use your's.

### 2. Add import statements

You need to add import statements for AppBox modules before starting the SDK.

#### Objective-C
Open your `AppDelegate.m` file and add the following line at the top of the file below your own import statements.

```objective-c
#import <AppBox/AppBox.h>
```

#### Swift
Open your `AppDelegate.swift` file and add the following line.

```swift
import AppBox
```

### 3. Start the SDK

In order to use AppBox auto update service, you need to -

#### Objective-C
Add the following line to start the SDK in your app's `AppDelegate.m` class in the `application:didFinishLaunchingWithOptions:` method.

```objective-c
[AppNewVersionNotifier initWithKey:"{App Update Key}"];
```
#### Swift
Insert the following line to start the SDK in your app's `AppDelegate.swift` class in the `application(_:didFinishLaunchingWithOptions:)` method.

```swift
AppNewVersionNotifier.initWithKey("{App Update Key}")
```

## Troubleshooting

**Q. Unable to find a specification for MobileCenter error when using CocoaPods in your app?**

If you are using Cocoapods to install AppBox SDK in your app and run into an error with the message - Unable to find a specification for AppBox, run `pod repo update` or `pod repo update master` in your terminal. It will sync the latest podspec files for you. Then try `pod install` which should install AppBox SDK in your app.

**Q. Swift. Could not build objective-c module 'AppBox'**

When this happens, just build the frameworks separately first :
* Change the scheme to `AppBox` (if not present then select from manage scheme)
* Build (⌘B)
* Change back to your project scheme
* Run

## Contributions ❤️
Any contribution is more than welcome! You can contribute through pull requests and [issues](https://github.com/vineetchoudhary/AppBox-iOSFramework/issues) on [GitHub](https://github.com/vineetchoudhary/AppBox-iOSFramework/)

## Bugs 💔 
Please post any bugs to the [issue tracker](https://github.com/vineetchoudhary/AppBox-iOSFramework/issues) found on the project's GitHub page. Please include a description of what is not working right with your issue.

## License
[![](https://licensebuttons.net/l/by-nd/3.0/88x31.png)](https://creativecommons.org/licenses/by-nd/4.0/)

#### You are free to:

* Share, copy and redistribute the material in any medium or format for any purpose, even commercially. The licensor cannot revoke these freedoms as long as you follow the license terms.


#### Under the following terms:

* **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
* **NoDerivatives** — If you remix, transform, or build upon the material, you may not distribute the modified material.
* **No additional restrictions** — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


#### Notices:

- You do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation.
- No warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.

Thank you!
