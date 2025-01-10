//
//  AtlasNetworkURLs.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

enum AtlasNetworkURLs {
    // https://openlibrary.org/subjects/love.json?limit=20
    static let SCHEME = "https"
    static let ATLAS_WIDGET_BASE_URL = "embed.atlas.so"

    static let PARAM_APP_ID = "appId"
    static let PARAM_ATLAS_ID = "atlasId"
    static let PARAM_USER_ID = "userId"
    static let PARAM_USER_HASH = "userHash"
    static let PARAM_USER_NAME = "userName"
    static let PARAM_USER_EMAIL = "userEmail"
    static let PARAM_QUERY = "query"
    
    static let ATLAS_API_BASE_URL = "app.atlas.so"
    static let LOGIN_URL_PATH = "/api/client-app/company/identify"
    static let UPDATE_TICKET_URL =  "/api/client-app/ticket/"
    static let UPDATE_CUSTOM_FIELDS_URL =  "/update_custom_fields"
    static let GET_CONVERSATIONS_URL =  "/api/client-app/conversations/"
    
    static let ATLAS_WEB_SOCKET_SCHEME = "wss"
    static let ATLAS_WEB_SOCKET_BASE_URL = "app.atlas.so"
    static let ATLAS_WEB_SOCKET_CUSTOMER_PATH = "/ws/CUSTOMER::"
}
