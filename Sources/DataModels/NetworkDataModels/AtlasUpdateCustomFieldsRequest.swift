//
//  UpdateCustomFieldsRequest.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/29/24.
//

import Foundation

struct AtlasUpdateCustomFieldsRequest: Codable {
    let conversationId: String
    let customFields: [String: Data]
}

