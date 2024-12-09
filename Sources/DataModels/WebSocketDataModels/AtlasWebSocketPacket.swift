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
    let conversation: String?
    let conversationId: String?
    let message: String?
    
    var atlasWebSocketPayloadMessage: AtlasWebSocketPayloadMessage? {
        if let data = message?.data(using: .utf8) {
            do {
                let message = try JSONDecoder().decode(AtlasWebSocketPayloadMessage.self, from: data)
                return message
            } catch {
//                print("AtlasSDK Error: Can not parse web socket message.")
                return nil
            }
        }
        return nil
    }
    
    var atlasWebSocketConversation: AtlasWebSocketConversation? {
        if let data = conversation?.data(using: .utf8) {
            do {
                let conversation = try JSONDecoder().decode(AtlasWebSocketConversation.self, from: data)
                return conversation
            } catch {
//                print("AtlasSDK Error: Can not parse web socket message.")
                return nil
            }
        }
        return nil
    }
}

struct AtlasWebSocketConversation: Codable {
    let id: AtlasWebSocketConversationID?
    let status: String?
    let messages: [AtlasWebSocketPayloadMessage]?
}

struct AtlasWebSocketPayloadMessage: Codable {
    let side: Int?
    let conversationId: String?
    let read: Bool?
}

enum PacketType: String, Codable {
    case conversationUpdated = "CONVERSATION_UPDATED"
    case agentMessage = "AGENT_MESSAGE"
    case botMessage = "BOT_MESSAGE"
    case messageRead = "MESSAGE_READ"
    case chatWidgetRespons = "CHATBOT_WIDGET_RESPONS"
    case conversationHidden = "CONVERSATION_HIDDEN"
    case agentTyping = "AGENT_TYPING"
    case pong = "PONG"
    case undefined
}

enum AtlasWebSocketConversationID: Codable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(MessageID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Int or String for MessageID"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}
