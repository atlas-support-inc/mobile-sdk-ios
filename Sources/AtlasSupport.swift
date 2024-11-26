import WebKit

var urlBase = "https://atlas-embed-termosa.vercel.app/"

public class AtlasSupport: WKWebView {
    
    public func startChat(appId: String, userId: String, userHash: String, userName: String = "", userEmail: String = "") {
        let urlParams = "appId=\(appId)&userId=\(userId)&userHash=\(userHash)&userName=\(userName)&userEmail=\(userEmail)"
        guard let url = URL(string: "\(urlBase)?\(urlParams)") else { return }
        load(URLRequest(url: url))
    }
}

class AtlasSDK {
    
    // Private initializer prevents instances
    private init() {}
    
    static let sdkVersion = "1.0.0"
    
    // The appId is empty by default and must be set before using getAtlasViewController() or any other public methods.
    private static var appId: String = ""
    private static let atlasSDKQueue = DispatchQueue(label: "com.atlasSDK",
                                                     attributes: .concurrent)

    static func setAppId(_ appId: String) {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return
        }
        atlasSDKQueue.async(flags: .barrier) {
            AtlasSDK.appId = appId
        }
    }
    
    static func identify(userId: String? = nil,
                         userHash: String? = nil,
                         userName: String? = nil,
                         userEmail: String? = nil) {
    }
    
    static func getAtlassViewController() -> UIViewController? {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return nil
        }
        
        let viewModel = AtlasViewModel(appId: appId)
        let viewController = AtlasViewController(viewModel: viewModel)
        
        return viewController
    }
}

