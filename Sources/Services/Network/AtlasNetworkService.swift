//
//  AtlasNetworkService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

internal class AtlasNetworkService {
    
    func login(appId: String,
               atlasUser: AtlasUser,
               _ completion: @escaping (Result<LoginResponse, NetworkError>) -> ()) {
        
        let loginRequest = LoginRequest(
            appId: appId,
            userId: atlasUser.id,
            userHash: atlasUser.hash,
            userName: atlasUser.name,
            userEmail: atlasUser.email
        )
        
        // Use JSONEncoder to convert the Codable object to JSON data
        guard let jsonData = try? JSONEncoder().encode(loginRequest) else {
            completion(.failure(.encodingJSONError("Error: Failed to encode request data")))
            return;
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AtlasNetworkURLs.ATLAS_WIDGET_BASE_URL
        urlComponents.path = AtlasNetworkURLs.LOGIN_URL_PATH
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL("Invalid URL.: " + urlComponents.description)));
            return
        }
        
        // Create and configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(
                    .failure(
                        NetworkError.nerworkError(
                            error.localizedDescription)
                    ))
            } else if let data = data {
                print("Response Data: \(data)")
                // Decode the JSON response
                do {
                    let object
                    = try JSONDecoder()
                        .decode(LoginResponse.self,
                                from: data)
                    completion(.success(object))
                } catch let error {
                    completion(
                        .failure(
                            NetworkError.decodingJSONError(
                                error.localizedDescription)
                        ))
                }
            }
        }
        task.resume()
    }
    
}