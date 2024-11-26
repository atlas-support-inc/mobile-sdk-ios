//
//  AtlasViewModel.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

class AtlasViewModel {
    
    let appId: String
//    let user: String
    
    init(appId: String) {
        self.appId = appId
    }
    
    func atlasURL() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkURLs.scheme
        urlComponents.host = NetworkURLs.ATLAS_WIDGET_BASE_URL
        
        urlComponents.queryItems = [
            URLQueryItem(name: NetworkURLs.PARAM_APP_ID, value: "20"),
            URLQueryItem(name: NetworkURLs.PARAM_ATLAS_ID, value: "20"),
            URLQueryItem(name: NetworkURLs.PARAM_USER_ID, value: "20"),
            URLQueryItem(name: NetworkURLs.PARAM_USER_HASH, value: "20"),
            URLQueryItem(name: NetworkURLs.PARAM_USER_NAME, value: "20"),
            URLQueryItem(name: NetworkURLs.PARAM_USER_EMAIL, value: "20")
        ]
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    func onAtlasScriptMessage(_ message: String) {
        
    }
}
