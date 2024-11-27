//
//  AtlasNetworkError.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

enum AtlasNetworkError: Error {
    case invalidURL(String)
    case nerworkError(String)
    case noDataRecived(String)
    case encodingJSONError(String)
    case decodingJSONError(String)
    case decodingImageDataError(String)
    case cancelled
    
    var message: String {
        switch self {
        case .invalidURL(let message):
            return message
        case .nerworkError(let message):
            return message
        case .noDataRecived(let message):
            return message
        case .encodingJSONError(let message):
            return message
        case .decodingJSONError(let message):
            return message
        case .decodingImageDataError(let message):
            return message
        case .cancelled:
            return "Network request was canceled"
        }
    }
}
