import WebKit

public protocol AtlasSDKDelegate: AnyObject {
    func onAtlasError(message: String)
    func onAtlasNewTicket(_ id: String)
    func onAtlasStatsUpdate(conversations: [AtlasConversationStats])
}

public class AtlasSDK {
    /// Private initializer prevents instances
    private init() {}
    /// The appId is empty by default and must
    /// be set before using getAtlasViewController() or any other public methods.
    internal static var appId: String = ""
    private static var viewController: AtlasViewController?
    
    private static let atlasUserService = AtlasUserService()
    private static let atlasSDKQueue = DispatchQueue(label: "com.atlasSDK",
                                                     qos: .userInitiated,
                                                     attributes: .concurrent)

    static public func setAppId(_ appId: String) {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return
        }
        AtlasSDK.appId = appId
    }
            
    static public func getAtlassViewController(_ chatbot: String = "") -> UIViewController? {
        guard !appId.isEmpty else {
            print("AtlasSDK Error: App ID cannot be empty.")
            return nil
        }
        
        let viewModel = AtlasViewModel(appId: appId,
                                       userService: atlasUserService)
        
        viewModel.chat = chatbot
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
    
    static public func updateCustomField(ticketId: String, data: [String: Any]) {
        atlasSDKQueue.async() {
            atlasUserService.updateCustomFields(ticketId: ticketId,
                                                data: data)
        }
    }
}

internal extension AtlasSDK {
    /// External communication handlers
    private static var atlasSDKDelegates: [(any AtlasSDKDelegate)?] = []
    
    private static var atlasSDKOnErroHandlers: [(String) -> ()] = []
    private static var atlasSDKOnNewTicketHandlers: [(String) -> ()] = []
    private static var atlasSDKStatsUpdateHandlers: [([AtlasConversationStats]) -> ()] = []
    
    /// Notify external handlers
    static func onError(_ error: String) {
        atlasSDKOnErroHandlers.forEach { $0(error) }
        atlasSDKDelegates.forEach { $0?.onAtlasError(message: error)}
    }
    
    static func onStatsUpdate(_ conversations: [AtlasConversationStats]) {
        atlasSDKStatsUpdateHandlers.forEach { $0(conversations) }
        atlasSDKDelegates.forEach { $0?.onAtlasStatsUpdate(conversations: conversations) }
    }
    
    static func onNewTicket(id: String) {
        atlasSDKOnNewTicketHandlers.forEach { $0(id) }
        atlasSDKDelegates.forEach { $0?.onAtlasNewTicket(id) }
    }
}

/// Public setters for external handlers
public extension AtlasSDK {
    static func setAtlasSDKDelegate(_ delegate: any AtlasSDKDelegate) {
        weak var weakDelegate = delegate
        atlasSDKDelegates.append(weakDelegate)
    }
    
    static func removeAtlasSDKDelegate(_ delegate: any AtlasSDKDelegate) {
        atlasSDKDelegates.removeAll(where: { $0 === delegate })
    }
    
    static func setAtlasSDKOnErroHandler(_ handler: @escaping (String) -> ()) {
        atlasSDKOnErroHandlers.append(handler)
    }
    
    static func removeAtlasSDKOnErroHandler(_ handler: @escaping (String) -> ()) {
//        atlasSDKOnErroHandlers.removeAll { ObjectIdentifier($0) == ObjectIdentifier(handler) }
    }
    
    static func setAtlasSDKOnNewTicketHandler(_ handler: @escaping (String) -> ()) {
        atlasSDKOnNewTicketHandlers.append(handler)
    }
    
    static func removeAtlasSDKOnNewTicketHandler(_ handler: @escaping (String) -> ()) {
//        atlasSDKOnNewTicketHandlers.removeAll { ObjectIdentifier($0) == ObjectIdentifier(handler) }
    }
    
    static func setAtlasSDKStatsUpdateHandler(_ handler: @escaping ([AtlasConversationStats]) -> ()) {
        atlasSDKStatsUpdateHandlers.append(handler)
    }
    
    static func removeAtlasSDKOnNewTicketHandler(_ handler: @escaping ([AtlasConversationStats]) -> ()) {
//        atlasSDKStatsUpdateHandlers.removeAll { ObjectIdentifier($0) == ObjectIdentifier(handler) }
    }
}
