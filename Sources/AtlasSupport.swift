import WebKit

var urlBase = "https://atlas-embed-termosa.vercel.app/"

public class AtlasSupport: WKWebView {
    
    public func startChat(appId: String, userId: String, userHash: String, userName: String = "", userEmail: String = "") {
        let urlParams = "appId=\(appId)&userId=\(userId)&userHash=\(userHash)&userName=\(userName)&userEmail=\(userEmail)"
        guard let url = URL(string: "\(urlBase)?\(urlParams)") else { return }
        load(URLRequest(url: url))
    }
}

// Make all functs optionals
public protocol AtlasSDKDelegate: AnyObject {
    func onAtlasError(message: String)
    func onAtlasStatsUpdate(conversations: [AtlasConversationStats])
}

public class AtlasSDK {
    
    /// Private initializer prevents instances
    private init() {}
    /// The appId is empty by default and must
    /// be set before using getAtlasViewController() or any other public methods.
    internal static var appId: String = ""
    private static var viewController: AtlasViewController?
    
    /// External communication handlers
    private static var atlasSDKDelegates: [(any AtlasSDKDelegate)?] = []
    
    private static var atlasSDKOnErroHandlers: [(String) -> ()] = []
    private static var atlasSDKOnNewTicketHandlers: [(String) -> ()] = []
    private static var atlasSDKStatsUpdateHandlers: [([AtlasConversationStats]) -> ()] = []
    
    private static let atlasUserService = AtlasUserService()
    private static let atlasSDKQueue = DispatchQueue(label: "com.atlasSDK",
                                                     attributes: .concurrent)

    static public func setAppId(_ appId: String) {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return
        }
        AtlasSDK.appId = appId
    }
            
    static public func getAtlassViewController() -> UIViewController? {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return nil
        }
        
        let viewModel = AtlasViewModel(appId: appId,
                                       userService: atlasUserService)
        let viewController = AtlasViewController(viewModel: viewModel)
        self.viewController = viewController
        
        return viewController
    }
    
    static public func identify(userId: String?,
                                userHash: String?,
                                userName: String?,
                                userEmail: String?) {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return
        }
        atlasSDKQueue.async() {
            atlasUserService
                .restorUser(
                    appId: appId,
                    userId: userId,
                    userHash: userHash,
                    userName: userName,
                    userEmail: userEmail)
        }
    }
    
    static public func updateCustomField(ticketId: String, data: [String : Data]) {
        atlasUserService.updateCustomFields(ticketId: ticketId,
                                            data: data)
    }
}

internal extension AtlasSDK {
    static func onError(_ error: Error) {
        atlasSDKOnErroHandlers.forEach { $0(error.localizedDescription) }
        atlasSDKDelegates.forEach { $0?.onAtlasError(message: error.localizedDescription)}
    }
    
    static func onStatsUpdate(_ conversations: [AtlasConversationStats]) {
        atlasSDKStatsUpdateHandlers.forEach { $0(conversations) }
        atlasSDKDelegates.forEach { $0?.onAtlasStatsUpdate(conversations: conversations) }
    }
}

/// External communication handlers
public extension AtlasSDK {
    static func setAtlasSDKDelegate(_ delegate: any AtlasSDKDelegate) {
        weak var weakDelegate = delegate
        atlasSDKDelegates.append(weakDelegate)
    }
    
    static func removeAtlasSDKDelegate(_ delegate: any AtlasSDKDelegate) {
        atlasSDKDelegates.removeAll(where: { $0 === delegate })
    }
    
    static func setAtlasSDKOnErroHandler(_ handler: @escaping (String?) -> ()) {
        atlasSDKOnErroHandlers.append(handler)
    }
    
    static func removeAtlasSDKOnErroHandler(_ handler: @escaping (String?) -> ()) {
//        atlasSDKOnErroHandlers.removeAll { $0 === handler }
    }
    
    static func setAtlasSDKOnNewTicketHandler(_ handler: @escaping (String) -> ()) {
        atlasSDKOnNewTicketHandlers.append(handler)
    }
    
    static func removeAtlasSDKOnNewTicketHandler(_ handler: @escaping (String) -> ()) {
//        atlasSDKOnNewTicketHandlers.removeAll { $0 === handler }
    }
}
