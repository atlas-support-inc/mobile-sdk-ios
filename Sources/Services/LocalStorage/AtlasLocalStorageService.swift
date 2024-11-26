//
//  AtlasLocalStorageService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

internal class AtlasLocalStorageService {
    // The key for storing userId in UserDefaults
    private let userIdKey = "Atlas.UserId"
    
    // Shared instance to access the service globally (singleton)
    static let shared = AtlasLocalStorageService()
    
    private init() {} // Prevent instantiation from outside
    
    func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    
    func updateUserId(_ newUserId: String) {
        UserDefaults.standard.set(newUserId, forKey: userIdKey)
    }
    
    func removeUserId() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
}
