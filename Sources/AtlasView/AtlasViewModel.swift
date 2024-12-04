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
    
    var chat: String = ""

    
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
            URLQueryItem(name: AtlasNetworkURLs.PARAM_ATLAS_ID, value: userService.atlasId),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_ID, value: ""),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_HASH, value: ""),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_NAME, value: ""),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_EMAIL, value: ""),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_CHATBOT, value: chat)
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
