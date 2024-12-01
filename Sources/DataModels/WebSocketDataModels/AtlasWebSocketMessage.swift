//
//  AtlasWebSocketMessage.swift
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
    let conversation: AtlasWebSocketConversation
    let conversationId: String
    let message: AtlasWebSocketMessage
}

struct AtlasWebSocketConversation: Codable {
    
}

struct AtlasWebSocketMessage: Codable {
    let conversationId: String
}

enum PacketType: String, Codable {
    case conversationUpdated = "CONVERSATION_UPDATED"
    case agentMessage = "AGENT_MESSAGE"
    case botMessage = "BOT_MESSAGE"
    case messageRead = "MESSAGE_READ"
    case chatWidgetRespons = "CHATBOT_WIDGET_RESPONS"
    case conversationHidden = "CONVERSATION_HIDDEN"
}
