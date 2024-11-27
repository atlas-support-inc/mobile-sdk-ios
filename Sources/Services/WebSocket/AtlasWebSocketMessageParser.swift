//
//  AtlasWebSocketMessageParser.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

class AtlasWebSocketMessageParser {

    func parse(_ data: Data) -> AtlasWebSocketMessage? {
        guard let messageString = String(data: data, encoding: .utf8) else {
            print("AtlasSDK Error: Can not parse web socket message.")
            return nil
        }
        return AtlasWebSocketMessage(content: messageString)
    }

    func parse(_ text: String) -> AtlasWebSocketMessage? {
        return AtlasWebSocketMessage(content: text)
    }
}
