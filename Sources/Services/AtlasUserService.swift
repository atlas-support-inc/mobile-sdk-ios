//
//  AtlasUserService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

internal class AtlasUserService {
    
    private(set) var atlasUser: AtlasUser? = nil
    private(set) var userId: String? = nil {
        didSet {
            // Re-open web socket connection every time when settin userId and it's value new
            if userId != oldValue { subscribeToWatchStats() }
        }
    }
    private let localStorage = AtlasLocalStorageService.shared
    private let networkService = AtlasNetworkService()
    private let webSocketService = AtlasWebSocketService()
    
    init() { self.userId = localStorage.getUserId() }
    
    func setNewUserId(_ newUserId: String) {
        self.userId = newUserId
        localStorage.saveUserId(newUserId)
    }
    
    func restorUser(appId: String,
                    atlasUser: AtlasUser,
                    _ completion: @escaping (Result<AtlasUser, Error>) ->()) {
        networkService.login(
            appId: appId,
            atlasUser: atlasUser) { [weak self] result in
                switch result {
                case .success(let loginResponse):
                    let atlasUser = AtlasUser(id: atlasUser.id,
                                              hash: atlasUser.hash,
                                              atlasId: loginResponse.id,
                                              name: atlasUser.name,
                                              email: atlasUser.email)
                    self?.atlasUser = atlasUser
                    self?.setNewUserId(atlasUser.atlasId ?? "")
                    completion(.success(atlasUser))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func subscribeToWatchStats() {
        guard let userId = self.userId else {
            print("AtlasSDK Error: Failed to establish web socket connection. userId is not defined")
            return
        }
        
        webSocketService.close()
        webSocketService.setWebSocketMessageHandler(self)
        webSocketService.connect(atlasId: userId)
    }
    
    func logout() {
        userId = nil
        atlasUser = nil
        localStorage.removeUserId()
    }
}

extension AtlasUserService: AtlasWebSocketServiceDelegate {
    func onNewMessage(_ message: WebSocketMessage) {
        
    }
    
    func onError(_ error: any Error) {
        
    }
}
