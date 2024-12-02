//
//  AtlasWebViewMessage.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 12/2/24.
//

import Foundation

struct AtlasWebViewMessage: Codable {
    let type: AtlasWebViewMessageType
    let atlasId: String
    let userId: String?
    let userHash: String?
    let errorMessage: String?
    let ticketId: String?
}

enum AtlasWebViewMessageType: String, Codable {
    case changeIdentity = "atlas:changeIdentity"
    case newTicket = "atlas:newTicket"
    case error = "atlas:error"
}
