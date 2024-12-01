//
//  AtlasGetConversationsResponse.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/29/24.
//

import Foundation

import Foundation

struct AtlasGetConversationsResponse: Codable {
    let data: [Conversation]
}

struct Conversation: Codable {
    let id: String?
    let startedChannel: Int?
    let status: String?
    let messages: [Message]
    let closedAt: String?
    let activities: [String]
    let lastMessage: Message?
    let assignedAgent: Agent?
    let number: Int?
    let customerId: String?
    let customer: Customer?
    let createdAt: String?
    let subject: String?
    let companyId: String?
    let lastMessageId: String?
    let updatedAt: String?
    let lastMessageAt: String?
}

// MARK: - Message
struct Message: Codable {
    let side: Int?
    let id: MessageID?
    let externalId: String?
    let text: String?
    let sentAt: String?
    let conversationId: String?
    let agent: Agent?
    let read: Bool?
    let type: Int?
    let widget: Widget?
    let createdAt: String?
    let updatedAt: String?
}

struct Agent: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let profileUrl: String?
}

struct Customer: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let fields: String?
}

struct Widget: Codable {
    let id: String?
    let type: String?
    let widget: WidgetDetails?
    let userInput: WidgetUserInput?
    let outputKey: String?
    let state: String?
}

struct WidgetDetails: Codable {
    let name: String?
    let key: String?
    let description: String?
    let type: String?
    let text: String?
    let title: String?
    let options: [String: String]?
    let hasTimeout: Bool?
    let timeout: Int?
}

struct WidgetUserInput: Codable {
    let selected: String?
}

enum MessageID: Codable {
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

enum MessageSide: Int {
    case CUSTOMER = 1
    case AGENT = 2
    case BOT = 3
}
