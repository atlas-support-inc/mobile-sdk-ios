//
//  AtlasConversation.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/29/24.
//

import Foundation

public struct AtlasConversationStats: Codable {
    let id: String
    let closed: Bool
    let unreanCount: Int
}
