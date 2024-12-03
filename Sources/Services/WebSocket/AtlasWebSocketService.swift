//
//  AtlasWebSocketService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

protocol WebSocketConnection {
    var delegate: WebSocketConnectionDelegate? { get set }
    
    func sendMessage(_ message: AtlasWebSocketMessage)
    func connect(atlasId: String)
    func disconnect()
}

protocol WebSocketConnectionDelegate: AnyObject {
    func onConnected(connection: WebSocketConnection)
    func onMessage(connection: WebSocketConnection, data: AtlasWebSocketPacket)
    func onDisconnected(connection: WebSocketConnection, error: Error?)
    func onError(connection: WebSocketConnection, error: Error)
}

class AtlasWebSocketService: NSObject, WebSocketConnection, URLSessionWebSocketDelegate {
    weak var delegate: WebSocketConnectionDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private let delegateQueue = OperationQueue()
    private let webSocketMessageParser = AtlasWebSocketMessageParser()
    
    func connect(atlasId: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.ATLAS_WEB_SOCKET_SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_WEB_SOCKET_BASE_URL
        urlComponents.path = AtlasNetworkURLs.ATLAS_WEB_SOCKET_CUSTOMER_PATH.appending(atlasId)
        
        /// Ensure the URL is valid
        guard let url = urlComponents.url else {
            print("Invalid URL.: " + urlComponents.description)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        let urlRequest = URLRequest(url: url, timeoutInterval: 60)
        
        urlSession = URLSession(configuration: configuration,
                                delegate: self,
                                delegateQueue: delegateQueue)
        webSocketTask = urlSession?.webSocketTask(with: urlRequest)
        
        webSocketTask?.resume()
        
        listen()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.onError(connection: self, error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    guard
                        let jsonData = text.data(using: .utf8),
                        let parsedMessage = self.webSocketMessageParser.parse(jsonData)
                    else { return }
                    
                    self.delegate?.onMessage(connection: self, data: parsedMessage)
                case .data(let data):
                    guard let parsedMessage = self.webSocketMessageParser.parse(data) else { return }
                    self.delegate?.onMessage(connection: self, data: parsedMessage)
                @unknown default:
                    fatalError()
                }
                
                self.listen()
            }
        }
    }
    
    func sendMessage(_ message: AtlasWebSocketMessage) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            let stringData = String(data: jsonData, encoding: .utf8) ?? ""
            let message = URLSessionWebSocketTask.Message.string(stringData)
            webSocketTask?.send(message) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.delegate?.onError(connection: self, error: error)
                }
            }
        } catch {
            delegate?.onError(connection: self, error: error)
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.onConnected(connection: self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.onDisconnected(connection: self, error: nil)
    }
}
