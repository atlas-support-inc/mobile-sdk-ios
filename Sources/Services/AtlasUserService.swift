//
//  AtlasUserService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

internal class AtlasUserService {
    
    private(set) var atlasId: String? = nil {
        /// Re-open web socket connection every time when settin userId and it's value new
        didSet { if atlasId != oldValue { subscribeToWatchStats() } }
    }
    private let localStorage = AtlasLocalStorageService.shared
    private let networkService = AtlasNetworkService()
    private let webSocketService = AtlasWebSocketService()
    
    init() { self.atlasId = localStorage.getUserId() }
    
    func setAtlasId(_ newUserId: String) {
        self.atlasId = newUserId
        localStorage.saveUserId(newUserId)
    }
    
    func restorUser(appId: String,
                    userId: String?,
                    userHash: String?,
                    userName: String?,
                    userEmail: String?,
                    _ completion: @escaping (Result<AtlasUser, Error>) ->()) {
        networkService.login(
            appId: appId,
            userId: userId,
            userHash: userHash,
            userName: userName,
            userEmail: userEmail) { [weak self] result in
                switch result {
                case .success(let loginResponse):
                    let atlasUser = AtlasUser(id: loginResponse.id,
                                              hash: loginResponse.detail ?? "",
                                              atlasId: loginResponse.id)
                    self?.setAtlasId(atlasUser.atlasId)
                    completion(.success(atlasUser))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func subscribeToWatchStats() {
        guard let atlasId = self.atlasId else {
            print("AtlasSDK Error: Failed to establish web socket connection. userId is not defined")
            return
        }
        
        webSocketService.close()
        webSocketService.setWebSocketMessageHandler(self)
        webSocketService.connect(atlasId: atlasId)
    }
    
    func logout() {
        atlasId = nil
        localStorage.removeUserId()
        webSocketService.close()
    }
}

extension AtlasUserService: AtlasWebSocketServiceDelegate {
    func onNewMessage(_ message: AtlasWebSocketMessage) {
        
    }
    
    func onError(_ error: any Error) {
        
    }
}
