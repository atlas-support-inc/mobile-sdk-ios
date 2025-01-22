//
//  AtlasViewModel.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

class AtlasViewModel {
    
    let appId: String
    let userService: AtlasUserService
    
    var query: String = ""
    var sdkVersionName: String {
        let bundle = Bundle(identifier: "org.cocoapods.AtlasSupportSDK")
        let version
        = (bundle?.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "Unknown"
        let sdkVersionParam = "swift@\(version)"
        
        return sdkVersionParam
    }
    
    init(appId: String, userService: AtlasUserService) {
        self.appId = appId
        self.userService = userService
    }
    
    func atlasURL() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_WIDGET_BASE_URL
        
        urlComponents.queryItems = [
            URLQueryItem(name: AtlasNetworkURLs.PARAM_APP_ID, value: appId),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_ATLAS_ID, value: userService.atlasId ?? ""),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_QUERY, value: query),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_SDK_VERSION, value: sdkVersionName),
        ]

        /// Ensure the URL is valid
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
        
    func onAtlasScriptMessage(_ message: AtlasWebViewMessage) {
        switch message.type {
        case .changeIdentity:
            let atlasId = message.atlasId
            userService.setAtlasId(atlasId)
        case .newTicket:
            if let ticketId = message.ticketId { AtlasSDK.onNewTicket(id: ticketId) }
        case .error:
            if let errorMessage = message.errorMessage { AtlasSDK.onError(errorMessage) }
        }
    }
}
