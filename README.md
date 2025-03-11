# AtlasSupportSDK

**AtlasSupportSDK** is a mobile SDK that integrates a real-time chat widget into iOS applications. 

---

## Installation

You can add Swift SDK to your application in two ways: via **SPM** or **CocoaPods**.

### SPM

In the Xcode, when your project is opened, select **File → Add Package Dependencies...**

In the the opened window enter URL of the Atlas SDK in the search bar:

```
https://github.com/atlas-support-inc/mobile-sdk-ios
```

Select the **AtlasSupportSDK** from the search results, configure **Dependency Rule** and **Add to Project** settings, and click **Add Package** button.

### CocoaPods

In your project add **AtlasSupportSDK** dependency to the **Podfile**:

```swift
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'AtlasSupportSDK', '~> 0.1.2'
end
```

Pull CocoaPods dependencies:

```
pod install
```

---

## Setup

Import the package into your code:

```swift
import AtlasSupportSDK
```

Connect the SDK to your account:

```swift
AtlasSDK.setAppId("YOUR_APP_ID")
```

---

## Identify your users

Make the following call with user details wherever a user logs into your application and you get the user details for the first time.

```swift
AtlasSDK.identify(userId: "...",
    userHash: nil,
    name: "...",
    email: "...",
    phoneNumber: "...")
```

To make sure scammer can't spoof a user, you should pass a `userHash` into identify call (read more about it here).

Unknown properties, like `name` or `phoneNumber` should be set to nil (not empty string) so they won't be overriden if they have previously been stored.

When you want to update the user's details you can call `identify` method again.

Additionally, there is a `logout` method available to clear the user's session when they log out of your application.

```swift
AtlasSDK.logout()
```

## Show UI

To use Atlas UI you need to get instance of the view controller and insert it into your view:

```swift
guard let atlassViewController = AtlasSDK.getAtlassViewController() else {
    print("Can not create AtlasSDK View Controller")
    return
}
  
navigationController.present(atlassViewController, animated: true)
```

### SwiftUI 

The `getAtlassSwiftUIView` method allows you to embedded `AtlasSwiftUIView` into your SwiftUI hierarchy.

```swift
struct ChatView: View {
    var body: some View {
        VStack {
            if let atlassSwifUIView = AtlasSDK.getAtlassSwiftUIView() {
                atlassSwifUIView
            } else {
                Text("Can not create AtlasSDK View")
            }
        }
    }
}
```

### Configuring view 

You can configure how does Atlas UI looks like on the [Chat Configuration page](https://app.atlas.so/configuration/chat). You can also configure the behavior of Atlas UI with the query parameter:

```swift
// Start chat with help center opened
let atlassViewControllerWithHelpCenter = AtlasSDK.getAtlassViewController(query: "open: helpcenter")

// Start chat with the new chatbot
let atlassViewControllerWithChatbot = AtlasSDK.getAtlassViewController(query: "chatbotKey: report_bug")

// Start chat with last opened chatbot if exists
let atlassViewControllerWithChatbot = AtlasSDK.getAtlassViewController(query: "chatbotKey: report_bug; prefer: last")
```

---

### Handling AtlasSDK Events and Delegates

The AtlasSDK provides a flexible way to handle chat events through both delegates and closures. These mechanisms allow developers to respond to various chat-related events, such as errors, ticket creation, or conversation updates, in a structured manner.

You can add event handlers by calling the following methods:
```swift 
AtlasSDK.setDelegate(self)  // Add a delegate conforming to `AtlasSDKDelegate`
AtlasSDK.setOnErroHandler(atlasErrorHandler)  // Closure for handling errors
AtlasSDK.setStatsUpdateHandler(atlasStatsUpdateHandler)  // Closure for conversation stats updates
AtlasSDK.setOnNewTicketHandler(atlasOnNewTicketHandler)  // Closure for new ticket creation
```

Each method appends your handler or delegate to the SDK's internal storage, allowing multiple listeners to respond to the same event.

To remove a previously added delegate or closure, use the corresponding remove methods:
```swift
AtlasSDK.removeDelegate(self)  // Remove delegate
AtlasSDK.removeOnErroHandler(atlasErrorHandler)  // Remove error handler
AtlasSDK.removeOnNewTicketHandler(atlasOnNewTicketHandler)  // Remove ticket handler
AtlasSDK.removeOnNewTicketHandler(atlasStatsUpdateHandler)  // Remove stats update handler
```


## Requirements

- iOS 13.0 or later.
- Swift 4.0 or later.

---

## Support

For issues or feature requests, contact the engineering team at [engineering@getatlas.io](mailto:engineering@getatlas.io) or visit the [GitHub Issues](https://github.com/atlas-support-inc/mobile-sdk-ios/issues) page.

For more details, visit the official [Atlas Support website](https://atlas.so).

---

[![Version](https://img.shields.io/cocoapods/v/AtlasSupportSDK.svg?style=flat)](https://cocoapods.org/pods/AtlasSupportSDK)
[![License](https://img.shields.io/cocoapods/l/AtlasSupportSDK.svg?style=flat)](https://cocoapods.org/pods/AtlasSupportSDK)
[![Platform](https://img.shields.io/cocoapods/p/AtlasSupportSDK.svg?style=flat)](https://cocoapods.org/pods/AtlasSupportSDK)

## Author

Atlas Support Inc, engineering@getatlas.io
