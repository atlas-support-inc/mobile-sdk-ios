import WebKit

public protocol AtlasSDKDelegate: AnyObject {
    func onError(message: String)
    func onNewTicket(_ id: String)
    func onStatsUpdate(conversations: [AtlasConversationStats])
}

@objc public class AtlasSDK: NSObject {
    /// Private initializer prevents instances
    private override init() {}
    /// The appId is empty by default and must
    /// be set before using getAtlasViewController() or any other public methods.
    internal static var appId: String = ""
    private static var viewController: AtlasViewController?
    
    private static let atlasUserService = AtlasUserService()
    private static let atlasSDKQueue = DispatchQueue(label: "com.atlasSDK",
                                                     qos: .userInitiated,
                                                     attributes: .concurrent)

    @objc static public func setAppId(_ appId: String) {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return
        }
        AtlasSDK.appId = appId
    }
            
    @objc static public func getAtlassViewController(query: String = "") -> UIViewController? {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return nil
        }
        
        let viewModel = AtlasViewModel(appId: appId,
                                       userService: atlasUserService)
        
        viewModel.query = query
        let viewController = AtlasViewController(viewModel: viewModel)
        self.viewController = viewController
        
        return viewController
    }
    
    @objc static public func identify(userId: String?,
                                userHash: String?,
                                name: String?,
                                email: String?,
                                phoneNumber: String?) {
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
                    userName: name,
                    userEmail: email,
                    phoneNumber: phoneNumber)
        }
    }
    
    @objc static public func logout() {
        atlasSDKQueue.async() {
            atlasUserService
                .restorUser(
                    appId: appId,
                    userId: "",
                    userHash: nil,
                    userName: nil,
                    userEmail: nil,
                    phoneNumber: nil)
        }
    }
    
/// Coming in future versions
//    static public func updateCustomField(ticketId: String, data: [String: Any]) {
//        atlasSDKQueue.async() {
//            atlasUserService.updateCustomFields(ticketId: ticketId,
//                                                data: data)
//        }
//    }
}

internal extension AtlasSDK {
    /// External communication handlers
    private static var atlasSDKDelegates: [(any AtlasSDKDelegate)?] = []
    
    private static var atlasSDKOnErroHandlers: [(String) -> ()] = []
    private static var atlasSDKOnNewTicketHandlers: [(String) -> ()] = []
    private static var atlasSDKStatsUpdateHandlers: [([AtlasConversationStats]) -> ()] = []
    
    /// Notify external handlers
    @objc static func onError(_ error: String) {
        atlasSDKOnErroHandlers.forEach { $0(error) }
        atlasSDKDelegates.forEach { $0?.onError(message: error)}
    }
    
    static func onStatsUpdate(_ conversations: [AtlasConversationStats]) {
        atlasSDKStatsUpdateHandlers.forEach { $0(conversations) }
        atlasSDKDelegates.forEach { $0?.onStatsUpdate(conversations: conversations) }
    }
    
    @objc static func onNewTicket(id: String) {
        atlasSDKOnNewTicketHandlers.forEach { $0(id) }
        atlasSDKDelegates.forEach { $0?.onNewTicket(id) }
    }
}

/// Public setters for external handlers
public extension AtlasSDK {
    static func setDelegate(_ delegate: any AtlasSDKDelegate) {
        weak var weakDelegate = delegate
        atlasSDKDelegates.append(weakDelegate)
    }
    
    static func removeDelegate(_ delegate: any AtlasSDKDelegate) {
        atlasSDKDelegates.removeAll(where: { $0 === delegate })
    }
    
    static func setOnErroHandler(_ handler: @escaping (String) -> ()) {
        atlasSDKOnErroHandlers.append(handler)
    }
    
    static func removeOnErroHandler(_ handler: @escaping (String) -> ()) {
//        atlasSDKOnErroHandlers.removeAll { ObjectIdentifier($0) == ObjectIdentifier(handler) }
    }
    
    static func setOnNewTicketHandler(_ handler: @escaping (String) -> ()) {
        atlasSDKOnNewTicketHandlers.append(handler)
    }
    
    static func removeOnNewTicketHandler(_ handler: @escaping (String) -> ()) {
//        atlasSDKOnNewTicketHandlers.removeAll { ObjectIdentifier($0) == ObjectIdentifier(handler) }
    }
    
    static func setStatsUpdateHandler(_ handler: @escaping ([AtlasConversationStats]) -> ()) {
        atlasSDKStatsUpdateHandlers.append(handler)
    }
    
    static func removeOnNewTicketHandler(_ handler: @escaping ([AtlasConversationStats]) -> ()) {
//        atlasSDKStatsUpdateHandlers.removeAll { ObjectIdentifier($0) == ObjectIdentifier(handler) }
    }
}
