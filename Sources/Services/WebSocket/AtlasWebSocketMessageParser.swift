//
//  AtlasWebSocketMessageParser.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

class AtlasWebSocketMessageParser {

    func parse(_ data: Data) -> AtlasWebSocketPacket? {
        do {
            let packet = try JSONDecoder().decode(AtlasWebSocketPacket.self, from: data)
            return packet
        } catch {
            print("AtlasSDK Error: Can not parse web socket message.")
            return nil
        }
    }
}
