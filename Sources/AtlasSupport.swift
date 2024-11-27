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
protocol AtlasSDKDelegate: AnyObject {
    func onError(message: String)
    func onNewTicket(ticketId: String)
    func onChangeIdentity(atlasId: String, userId: String, userHash: String)
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
    private static var atlasSDKOnChangeIdentityHandlers: [(String, String, String) -> ()] = []
    
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
                    userEmail: userEmail) { result in
                            viewController?.loadAtlasWebApp()
                            switch result {
                            case .success(let newAtlasUser):
                                atlasSDKDelegates.forEach {
                                    $0?.onChangeIdentity(atlasId: newAtlasUser.atlasId,
                                                         userId: newAtlasUser.id,
                                                         userHash: newAtlasUser.hash)
                                }
                            case .failure(let error):
                                atlasSDKDelegates.forEach {
                                    $0?.onError(message: error.localizedDescription)
                                }
                            }
                            
                        }
        }
    }
    
    static public func logout() {
        atlasUserService.logout()
        viewController?.loadAtlasWebApp()
    }
}

extension AtlasSDK {
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
    
    static func setAtlasSDKOnChangeIdentityHandler(_ handler: @escaping (String, String, String) -> ()) {
        atlasSDKOnChangeIdentityHandlers.append(handler)
    }
    
    static func removeAtlasSDKOnChangeIdentityHandler(_ handler: @escaping (String, String, String) -> ()) {
//        atlasSDKOnChangeIdentityHandlers.removeAll { $0 === handler }
    }
}
