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
  pod 'AtlasSupportSDK', '~> 0.0.6'
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

In this example, we import the SDK into HomeViewController and TabBarController because these are the two navigation points leading to the AtlasViewController.

---

### Initialize and Configure the SDK

Call the appropriate initialization and configuration methods erly. Depends on your app architecture.

For example:

```swift
AtlasSDK.setAppId("YOUR_APP_ID")
```

You can find `YOUR_APP_ID` in the Atlas application: https://app.atlas.so/settings/company

---

### Presenting the Atlas Chat ViewController

The `getAtlassViewController` method can return an optional value. This occurs if the appId is not provided, which is required for initializing the SDK correctly.

```swift
guard let atlassViewController = AtlasSDK.getAtlassViewController() else {
    print("HomeViewController Error: Can not create AtlasSDK View Controller")
    return
}
  
navigationController?.present(atlassViewController, animated: true)
```

---

### User Identification 

The Atlas SDK allows the chat to operate without identification. In this case, conversations are initiated without associating them with a specific customer. However, developers can link conversations to existing customer by calling the `identify` method with a valid user ID.

```swift
// Identify a user before presenting the chat
AtlasSDK.identify(userId: "UNIQUE_USER_IDENTIFIER", 
                  userHash: nil, // Required if authenication is enabled in Atlas Configuration
                  userName: "John Doe", // Optional
                  userEmail: "john.doe@example.com") // Optional

// Proceed to present the chat
if let chatViewController = AtlasSDK.getAtlassViewController() {
    navigationController?.present(chatViewController, animated: true)
}
```

---

### Customization 

It's possible to pass `query` key to a `getAtlassViewController` to configure the behavior or content of the returned AtlasFragment. (For ex: open specified chatbot to handle possible customer request)

**Default value:** "" (empty string).

**Expected format:** "key1: value1; key2: value2; ...."

```swift
    val atlasFragment = AtlasSdk.getAtlasFragment(query = "chatbotKey: n_other_topics; prefer: last")
```

`**chatbotKey:**` Specifies the context or topic key for the chatbot.

Example: `n_other_topics might` refer to general or miscellaneous topics.

`**prefer:**` Defines a preference or mode of operation.

Example: `last` indicate prioritization of recent interactions.

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
