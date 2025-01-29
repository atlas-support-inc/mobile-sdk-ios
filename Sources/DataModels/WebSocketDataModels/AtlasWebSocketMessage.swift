//
//  AtlasWebSocketMessage.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

struct AtlasWebSocketMessage: Codable {
    let channelId: String
    let channelKind: String
    let packetType: String
    let payload: String
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelKind = "channel_kind"
        case packetType = "packet_type"
        case payload = "{}"
    }
}

struct Payload: Codable {}
