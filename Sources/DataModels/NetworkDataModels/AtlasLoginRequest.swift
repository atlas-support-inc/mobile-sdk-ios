//
//  AtlasLoginRequest.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

struct AtlasLoginRequest: Codable {
    let appId: String
    let userId: String?
    let userHash: String?
    let userName: String?
    let userEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case appId = "appId"
        case userId = "userId"
        case userHash = "userHash"
        case userName = "name"
        case userEmail = "email"
    }
}
