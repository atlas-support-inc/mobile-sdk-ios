//
//  AtlasConversation.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/29/24.
//

import Foundation

public struct AtlasConversationStats: Codable {
    public let id: String
    public let closed: Bool
    public let unreadCount: Int
}
