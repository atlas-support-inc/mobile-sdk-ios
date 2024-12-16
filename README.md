# AtlasSupportSDK

**AtlasSupportSDK** is a mobile SDK that integrates a real-time chat widget into iOS applications. 

---

## Installation

### CocoaPods

Add the SDK to your `Podfile`:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'AtlasSupportSDK', '~> 0.0.3'
end
```

Run the following command in your terminal:

```bash
pod install
```

Open the `.xcworkspace` file in Xcode.

---

## Usage

### Import the SDK

In any file where you want to use the SDK, import it:

```swift
import AtlasSupportSDK
```

In the example, we import the SDK into HomeViewController and TabBarController because these are the two navigation points leading to the AtlasViewController.

---

### Initialize and Configure the SDK

Call the appropriate initialization and configuration methods erly. Depends on your app architecture.

For example:

```swift
let appId = "kxjfzvo5pp"

AtlasSDK.setAppId(appId)
```

---

### Presenting the Atlas Chat ViewController

The getAtlassViewController method can return an optional value. This occurs if the appId is not provided, which is required for initializing the SDK correctly.

```swift
guard let atlassViewController = AtlasSDK.getAtlassViewController() else {
    print("HomeViewController Error: Can not create AtlasSDK View Controller")
    return
}
  
navigationController?.present(atlassViewController, animated: true)
```

---

### Guest Mode and User Identification 

The Atlas SDK allows the chat to operate in guest mode by default. In this mode, conversations are initiated without associating them with a specific user account. However, developers can link the chat to a user account by calling the `identify` method with a valid user ID.

The `identify` method can be used in the following scenarios:

1. Before Presenting the Chat:

If the user is already authenticated in your app, you can call `identify` before presenting the chat. This ensures that all conversations are tied to the authenticated user from the beginning.

2. After Starting a Guest Conversation:

If the user starts a chat as a guest but later logs in or authenticates within your app, you can call `identify`. This action links the ongoing conversation and its history to the user's account.

```swift
// Identify a user before presenting the chat
let userID = userIDTextField.text ?? "authenticated-user-id"
AtlasSDK.identify(userId: userIDTextField.text, 
                  userHash: nil, 
                  userName: "John Doe", 
                  userEmail: "john.doe@example.com")

// Proceed to present the chat
if let chatViewController = AtlasSDK.getAtlassViewController("bot-id") {
    navigationController?.present(chatViewController, animated: true)
}
```

OR

```swift
let userID = userIDTextField.text ?? ""
AtlasSDK.identify(userId: userID, 
                  userHash: nil, 
                  userName: nil, 
                  userEmail: nil)

```

---

### Customization 

It's possible to pass chat bot id to a `getAtlassViewController` to open specified chat bot to handle possible customer request.
```swift
let botID = botIDTextField.text ?? ""
guard let atlassViewController = AtlasSDK.getAtlassViewController(botID) else {
    print("HomeViewController Error: Can not create AtlasSDK View Controller")
    return
}
  
navigationController?.present(atlassViewController, animated: true)
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
