//
//  AtlasNetworkService.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation

internal class AtlasNetworkService {
    
    func login(appId: String,
               userId: String?,
               userHash: String?,
               userName: String?,
               userEmail: String?,
               _ completion: @escaping (Result<AtlasLoginResponse, AtlasNetworkError>) -> ()) {
        
        let loginRequest = AtlasLoginRequest(
            appId: appId,
            userId: userId,
            userHash: userHash,
            userName: userName,
            userEmail: userEmail
        )
        
        // Use JSONEncoder to convert the Codable object to JSON data
        guard let jsonData = try? JSONEncoder().encode(loginRequest) else {
            completion(.failure(.encodingJSONError("Error: Failed to encode request data")))
            return;
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_API_BASE_URL
        urlComponents.path = AtlasNetworkURLs.LOGIN_URL_PATH
        
        // Ensure the URL is valid
        // https://embed.atlas.so/client-app/company/identify
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
                completion(
                    .failure(
                        AtlasNetworkError.nerworkError(
                            error.localizedDescription)
                    ))
            } else if let data = data {
                // Decode the JSON response
                do {
                    let object
                    = try JSONDecoder().decode(AtlasLoginResponse.self,
                                               from: data)
                    completion(.success(object))
                } catch let error {
                    completion(
                        .failure(
                            AtlasNetworkError.decodingJSONError(
                                error.localizedDescription)
                        ))
                }
            }
        }
        task.resume()
    }
    
    func updateCustomFields(with request: AtlasUpdateCustomFieldsRequest,
                            for userId: String,
                            _ completion: @escaping (Result<AtlasUpdateCustomFieldsResponse, AtlasNetworkError>) -> ()) {
        // Use JSONEncoder to convert the Codable object to JSON data
        guard let jsonData = try? JSONEncoder().encode(request) else {
            completion(.failure(.encodingJSONError("Error: Failed to encode request data")))
            return;
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_API_BASE_URL
        urlComponents.path = AtlasNetworkURLs.UPDATE_TICKET_URL
        urlComponents.path.append(userId)
        urlComponents.path.append(AtlasNetworkURLs.UPDATE_CUSTOM_FIELDS_URL)
        
        // Ensure the URL is valid
        // https://app.atlas.so/client-app/ticket/$userId/update_custom_fields
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
                completion(
                    .failure(
                        AtlasNetworkError.nerworkError(
                            error.localizedDescription)
                    ))
            } else if let data = data {
                // Decode the JSON response
                do {
                    let object
                    = try JSONDecoder()
                        .decode(AtlasUpdateCustomFieldsResponse.self,
                                from: data)
                    completion(.success(object))
                } catch let error {
                    completion(
                        .failure(
                            AtlasNetworkError.decodingJSONError(
                                error.localizedDescription)
                        ))
                }
            }
        }
        task.resume()
    }
    
    func getAllConversations(with atlasId: String ,
                             _ completion: @escaping (Result<AtlasGetConversationsResponse, AtlasNetworkError>) -> ()) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = AtlasNetworkURLs.SCHEME
        urlComponents.host = AtlasNetworkURLs.ATLAS_API_BASE_URL
        urlComponents.path = AtlasNetworkURLs.GET_CONVERSATIONS_URL
        urlComponents.path.append(atlasId)
        
        // Ensure the URL is valid
        //https://app.atlas.so/api/client-app/conversations/41d24dc0-94af-4d83-b0cb-1a457eaae189
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL("Invalid URL.: " + urlComponents.description)));
            return
        }
        
        // Create and configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(
                    .failure(
                        AtlasNetworkError.nerworkError(
                            error.localizedDescription)
                    ))
            } else if let data = data {
                // Decode the JSON response
                do {
                    let object
                    = try JSONDecoder()
                        .decode(AtlasGetConversationsResponse.self,
                                from: data)
                    completion(.success(object))
                } catch let error {
                    completion(
                        .failure(
                            AtlasNetworkError.decodingJSONError(
                                error.localizedDescription)
                        ))
                }
            }
        }
        task.resume()
    }
}
