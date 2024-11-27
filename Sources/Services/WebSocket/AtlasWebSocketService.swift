//
//  AtlasWebSocketService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

protocol AtlasWebSocketServiceDelegate {
    func onNewMessage(_ message: WebSocketMessage)
    func onError(_ error: Error)
}

class AtlasWebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private var webSocketMessageHandler: AtlasWebSocketServiceDelegate?
    private let urlSession = URLSession.shared
    private let webSocketMessageParser = AtlasWebSocketMessageParser()
    
    func setWebSocketMessageHandler(_ handler: AtlasWebSocketServiceDelegate?) {
        self.webSocketMessageHandler = handler
    }

    func connect(atlasId: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.ATLAS_WEB_SOCKET_SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_WEB_SOCKET_BASE_URL
        urlComponents.path = AtlasNetworkURLs.ATLAS_WEB_SOCKET_CUSTOMER_PATH
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            print("Invalid URL.: " + urlComponents.description)
            return
        }
    
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        let request = WebSocketRequest(
            channelId: atlasId,
            channelKind: "CUSTOMER",
            packetType: "SUBSCRIBE",
            payload: "{}"
        )
        
        sendMessage(request) {[weak self] error in
            if error == nil {
                self?.listenForMessages()
            }
        }
    }

    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    private func sendMessage(_ request: WebSocketRequest, _ completion: @escaping (Error?) -> ()) {
        do {
            let jsonData = try JSONEncoder().encode(request)
            let message = URLSessionWebSocketTask.Message.data(jsonData)
            webSocketTask?.send(message) { [weak self] error in
                if let error = error {
                    print("AtlasSDK Error: Failed to send message: \(error)")
                    self?.webSocketMessageHandler?.onError(error)
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } catch {
            print("AtlasSDK Error: Failed serializing JSON: \(error)")
            self.webSocketMessageHandler?.onError(error)
            completion(error)
        }
    }

    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("AtlasSDK Error:: Failed to receive message: \(error)")
                self?.webSocketMessageHandler?.onError(error)
            case .success(let message):
                self?.handleMessage(message)
            }
            // Continue listening for messages
            self?.listenForMessages()
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            guard let parsedMessage = webSocketMessageParser.parse(data) else { return }
            webSocketMessageHandler?.onNewMessage(parsedMessage)
        case .string(let text):
            guard let parsedMessage = webSocketMessageParser.parse(text) else { return }
            webSocketMessageHandler?.onNewMessage(parsedMessage)
        @unknown default:
            break
        }
    }
}

