import WebKit

var urlBase = "https://atlas-embed-termosa.vercel.app/"

public class AtlasSupport: WKWebView {
    
    public func startChat(appId: String, userId: String, userHash: String, userName: String = "", userEmail: String = "") {
        let urlParams = "appId=\(appId)&userId=\(userId)&userHash=\(userHash)&userName=\(userName)&userEmail=\(userEmail)"
        guard let url = URL(string: "\(urlBase)?\(urlParams)") else { return }
        load(URLRequest(url: url))
    }
}

protocol AtlasSDKDelegate: AnyObject {
    func onError(message: String?)
    func onNewTicket(ticketId: String?)
    func onChangeIdentity(atlasId: String?, userId: String?, userHash: String)
}

class AtlasSDK {
    
    // Private initializer prevents instances
    private init() {}
    
    static let sdkVersion = "1.0.0"
    
    // The appId is empty by default and must be set before using getAtlasViewController() or any other public methods.
    static var appId: String = ""
    private static var viewController: AtlasViewController?
    private static var atlasSDKDelegates: [any AtlasSDKDelegate] = []
    
    private static let atlasUserService = AtlasUserService()
    private static let atlasSDKQueue = DispatchQueue(label: "com.atlasSDK",
                                                     attributes: .concurrent)
    
    static func setAtlasSDKDelegate(_ delegate: any AtlasSDKDelegate) {
        atlasSDKDelegates.append(delegate)
    }
    
    static func removeAtlasSDKDelegate(_ delegate: any AtlasSDKDelegate) {
//        atlasSDKDelegates.removeAll(where: { $0 == delegate })
    }

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
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return
        }
        atlasSDKQueue.async() {
            atlasUserService
                .restorUser(
                    appId: appId,
                    atlasUser: AtlasUser(
                        id: userId ?? "",
                        hash: userHash ?? "",
                        atlasId: nil,
                        name: userName,
                        email: userEmail)) { result in
                            viewController?.loadAtlasWebApp()
                            switch result {
                            case .success(let newAtlasUser):
                                atlasSDKDelegates.forEach {
                                    $0.onChangeIdentity(atlasId: newAtlasUser.atlasId,
                                                        userId: newAtlasUser.id,
                                                        userHash: newAtlasUser.hash)
                                }
                            case .failure(let error):
                                atlasSDKDelegates.forEach {
                                    $0.onError(message: error.localizedDescription)
                                }
                            }
                            
                        }
        }
    }
            
    static func getAtlassViewController() -> UIViewController? {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return nil
        }
        
        let viewModel = AtlasViewModel(appId: appId,
                                       userService: AtlasSDK.atlasUserService)
        let viewController = AtlasViewController(viewModel: viewModel)
        self.viewController = viewController
        
        return viewController
    }
}

