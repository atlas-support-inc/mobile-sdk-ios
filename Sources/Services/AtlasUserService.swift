//
//  AtlasUserService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

internal class AtlasUserService {
    
    private(set) var atlasId: String? = nil
    private(set) var conversations: [AtlasConversationStats] = []
    
    private let localStorage = AtlasLocalStorageService.shared
    private let networkService = AtlasNetworkService()
    private let webSocketService = AtlasWebSocketService()
    
    private var webSocketConnection: WebSocketConnection = AtlasWebSocketService()
    
    init() { 
        guard let atlasId = localStorage.getUserId() else { return }
        setAtlasId(atlasId)
    }
    
    func setAtlasId(_ newUserId: String) {
        self.atlasId = newUserId
        localStorage.saveUserId(newUserId)
        getAllConversations()
    }
    
    func restorUser(appId: String,
                    userId: String?,
                    userHash: String?,
                    userName: String?,
                    userEmail: String?,
                    phoneNumber: String?) {
        networkService.login(
            appId: appId,
            userId: userId,
            userHash: userHash,
            userName: userName,
            userEmail: userEmail,
            phoneNumber: phoneNumber) { [weak self] result in
                switch result {
                case .success(let loginResponse):
                    let atlasUser = AtlasUser(atlasId: loginResponse.id)
                    self?.setAtlasId(atlasUser.atlasId)
                case .failure(let error):
                    AtlasSDK.onError(error.message)
                }
            }
    }
    
    func updateCustomFields(ticketId: String,
                            data: [String : Any]) {
        guard let atlasId = self.atlasId else {
            print("AtlasSDK Error: Failed to update custom field. userId is not defined.")
            return
        }

        networkService.updateCustomFields(with: data,
                                          ticketId: ticketId,
                                          for: atlasId) { result in
            switch result {
            case .success(_):
                // TO DO: How to handle success?
                print("AtlasSDK Update Custom Fields request Succeed")
            case .failure(let error):
                AtlasSDK.onError(error.message)
            }
        }
    }
    
    func getAllConversations() { 
        guard let atlasId = self.atlasId else {
            print("AtlasSDK Error: Failed to fetch user's conversations. userId is not defined.")
            return
        }
        networkService.getAllConversations(with: atlasId) { [weak self] result in
            /// Attempt to open a socket connection.
            self?.subscribeToWatchStats()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.conversations.removeAll()
                self.conversations.append(
                    contentsOf: 
                        response
                        .data
                        .map { (self.getConversationStats(conversation: $0)) }
                )
                AtlasSDK.onStatsUpdate(self.conversations)
            case .failure(let error):
                AtlasSDK.onError(error.message)
            }
        }
    }
    
    func subscribeToWatchStats() {
        guard let atlasId = self.atlasId else {
            print("AtlasSDK Error: Failed to establish web socket connection. userId is not defined")
            return
        }
        
        webSocketConnection.delegate = self
        webSocketConnection.connect(atlasId: atlasId)
    }
}

extension AtlasUserService: WebSocketConnectionDelegate {
    func onConnected(connection: any WebSocketConnection) {
        guard let atlasId = self.atlasId else {
            print("AtlasSDK Error: Failed to establish web socket connection. userId is not defined")
            return
        }
        let request = AtlasWebSocketMessage(
            channelId: atlasId,
            channelKind: "CUSTOMER",
            packetType: "SUBSCRIBE",
            payload: Payload()
        )
        
        webSocketConnection.sendMessage(request)
    }
    
    func onMessage(connection: any WebSocketConnection, data: AtlasWebSocketPacket) {
        switch data.packet_type {
        case .conversationUpdated, .botMessage, .messageRead, .agentMessage:
            if let conversation = data.payload.atlasWebSocketConversation {
                let atlasConversation = getConversationStats(conversation: conversation)
                updateConversationStats(conversation: atlasConversation)
            }
        case .chatWidgetRespons:
            addChatBotResponseCount(conversation: data)
        case .conversationHidden:
            conversations = conversations.filter { $0.id != data.payload.conversationId }
        case .agentTyping:
            break
        case .undefined, .pong:
            break
        }
    }
    
    func onDisconnected(connection: any WebSocketConnection, error: (any Error)?) {
        /// WebSocket connection is not stable. It disconnects time to time (gets killed by the system). Reconnecting when disconnecting
        subscribeToWatchStats()
    }
    
    func onError(connection: any WebSocketConnection, error: any Error) {
        
    }
}


extension AtlasUserService {
    /// Update conversations array by searching given conversation by id.
    func addChatBotResponseCount(conversation: AtlasWebSocketPacket) {
        guard let message = conversation.payload.atlasWebSocketPayloadMessage else { return }
        if let messageIndex
            = conversations
            .firstIndex(where: { $0.id == message.conversationId }) {
            conversations[messageIndex]
            = AtlasConversationStats(id: conversations[messageIndex].id,
                                     closed: conversations[messageIndex].closed,
                                     unreadCount: conversations[messageIndex].unreadCount + 1)
        } else {
            conversations.append(AtlasConversationStats(id: message.conversationId ?? "",
                                                        closed: false,
                                                        unreadCount: 1))
        }
    }
    
    
    /// Update conversations array by searching given conversation by id.
    func updateConversationStats(conversation: AtlasConversationStats) {
        if let conversationIndex
            = conversations
            .firstIndex(where: { $0.id == conversation.id }) {
            self.conversations[conversationIndex] = conversation
        } else {
            self.conversations.append(conversation)
        }
        AtlasSDK.onStatsUpdate(self.conversations)
    }
    
    /// Transform AtlasGetConversationsResponse to AtlasConversationStats.
    func getConversationStats(conversation: Conversation) -> AtlasConversationStats {
        let unreadCount = conversation.messages.filter { message in
            guard let isRead = message.read, !isRead else { return false }
            return message.side == MessageSide.BOT.rawValue || message.side == MessageSide.AGENT.rawValue
        }.count
        
        let id = conversation.id ?? "unknown"
        let closed = conversation.status == "closed" // Assuming `status` indicates if it's closed
        
        return AtlasConversationStats(id: id, closed: closed, unreadCount: unreadCount)
    }
    
    func getConversationStats(conversation: AtlasWebSocketConversation) -> AtlasConversationStats {
        let unreadCount = conversation.messages?.filter { message in
            guard let isRead = message.read, !isRead else { return false }
            return message.side == MessageSide.BOT.rawValue || message.side == MessageSide.AGENT.rawValue
        }.count
        
        var id = ""
        switch conversation.id {
        case .int(let intId):
            id = String(intId)
        case .string(let intId):
            id = intId
        default:
            id = ""
        }
        
        let closed = conversation.status == "closed" // Assuming `status` indicates if it's closed
        
        return AtlasConversationStats(id: id, closed: closed, unreadCount: unreadCount ?? 0)
    }
    
}
