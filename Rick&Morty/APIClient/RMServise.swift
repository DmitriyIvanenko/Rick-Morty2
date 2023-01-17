//
//  Servise.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.01.2023.
//

import Foundation

/// Promary API servise object to get Data
final class RMServise {
    /// Shared singletone instance
    static let shared = RMServise()
    
    private let cacheManager = RMAPICacheManager()
    
    /// Privatized constructor
    private init() {}
    
    enum RMServiseError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send rick&Morty API Call
    /// - Parameters:
    ///  - requst: request Instance
    ///  - type: The type of object we expect to get back
    ///  - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        complition: @escaping (Result<T, Error>) -> Void
    ) {
        
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            print("Using cached API Response")

            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                complition(.success(result))
            }
            catch {
                complition(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            complition(.failure(RMServiseError.failedToCreateRequest))
            return
        }
//        print("API Call: \(request.url?.absoluteString ?? "")")
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                complition(.failure(error ?? RMServiseError.failedToGetData))
                return
            }
            
            // Decode response
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
                complition(.success(result))
            }
            catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: - Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
    
}
