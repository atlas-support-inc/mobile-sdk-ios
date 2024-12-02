//
//  AtlasWebSocketPacket.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

struct AtlasWebSocketPacket: Codable {
    let packet_type: PacketType
    let payload: AtlasWebSocketPayload
}

struct AtlasWebSocketPayload: Codable {
    let conversation: AtlasWebSocketConversation?
    let conversationId: String?
    let message: AtlasWebSocketPayloadMessage?
}

struct AtlasWebSocketConversation: Codable {
    let id: String?
    let status: String?
    let messages: [AtlasWebSocketPayloadMessage]
}

struct AtlasWebSocketPayloadMessage: Codable {
    let side: Int?
    let conversationId: String
    let read: Bool?
}

enum PacketType: String, Codable {
    case conversationUpdated = "CONVERSATION_UPDATED"
    case agentMessage = "AGENT_MESSAGE"
    case botMessage = "BOT_MESSAGE"
    case messageRead = "MESSAGE_READ"
    case chatWidgetRespons = "CHATBOT_WIDGET_RESPONS"
    case conversationHidden = "CONVERSATION_HIDDEN"
}
