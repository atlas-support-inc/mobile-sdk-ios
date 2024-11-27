//
//  AtlasWebSocketMessageParser.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

class AtlasWebSocketMessageParser {

    func parse(_ data: Data) -> WebSocketMessage? {
        guard let messageString = String(data: data, encoding: .utf8) else {
            print("AtlasSDK Error: Can not parse web socket message.")
            return nil
        }
        return WebSocketMessage(content: messageString)
    }

    func parse(_ text: String) -> WebSocketMessage? {
        return WebSocketMessage(content: text)
    }
}
