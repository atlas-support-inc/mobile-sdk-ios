//
//  AtlasNetworkURLs.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

enum AtlasNetworkURLs {
    // https://openlibrary.org/subjects/love.json?limit=20
    static let scheme = "https"
    static let ATLAS_WIDGET_BASE_URL = "embed.atlas.so"
    
    static let PARAM_APP_ID = "appId"
    static let PARAM_ATLAS_ID = "atlasId"
    static let PARAM_USER_ID = "userId"
    static let PARAM_USER_HASH = "userHash"
    static let PARAM_USER_NAME = "userName"
    static let PARAM_USER_EMAIL = "userEmail"
    
    static let LOGIN_URL_PATH = "/client-app/company/identify"
}
