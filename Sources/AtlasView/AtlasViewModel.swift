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
    
    init(appId: String, userService: AtlasUserService) {
        self.appId = appId
        self.userService = userService
    }
    
    func atlasURL() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_WIDGET_BASE_URL
        
        urlComponents.queryItems = [
            URLQueryItem(name: AtlasNetworkURLs.PARAM_APP_ID, value: "20"),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_ATLAS_ID, value: "20"),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_ID, value: "20"),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_HASH, value: "20"),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_NAME, value: "20"),
            URLQueryItem(name: AtlasNetworkURLs.PARAM_USER_EMAIL, value: "20")
        ]
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URLRequest(url: url)
        }
        
    func onAtlasScriptMessage(_ message: String,
                              _ completion: @escaping (Bool) -> ()) {
        let atlasUser = AtlasUser(id: userService.atlasUser?.id ?? "",
                                  hash: userService.atlasUser?.hash ?? "",
                                  atlasId: userService.atlasUser?.atlasId,
                                  name: userService.atlasUser?.name,
                                  email: userService.atlasUser?.email)
        userService.restorUser(appId: appId,
                               atlasUser: atlasUser) { result in
            switch result {
            case .success(let newAtlasUser):
                completion(atlasUser.atlasId != newAtlasUser.atlasId)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
}
