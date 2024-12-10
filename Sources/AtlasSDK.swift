import WebKit

public protocol AtlasSDKDelegate: AnyObject {
    func onError(message: String)
    func onNewTicket(_ id: String)
    func onStatsUpdate(conversations: [AtlasConversationStats])
}

public class AtlasSDK {
    /// Private initializer prevents instances
    private init() {}
    /// The appId is empty by default and must
    /// be set before using getAtlasViewController() or any other public methods.
    internal static var appId: String = ""
    /// See AtlasWebSocketService `connect` function for  isWebSocketDisabled usage
    internal static var isWebSocketDisabled: Bool = false
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
    
    static func setWebSocketDisabled() {
        isWebSocketDisabled = true
    }
    
    static func setWebSocketEnabled() {
        isWebSocketDisabled = false
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
    static func onError(_ error: String) {
        atlasSDKOnErroHandlers.forEach { $0(error) }
        atlasSDKDelegates.forEach { $0?.onError(message: error)}
    }
    
    static func onStatsUpdate(_ conversations: [AtlasConversationStats]) {
        atlasSDKStatsUpdateHandlers.forEach { $0(conversations) }
        atlasSDKDelegates.forEach { $0?.onStatsUpdate(conversations: conversations) }
    }
    
    static func onNewTicket(id: String) {
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
