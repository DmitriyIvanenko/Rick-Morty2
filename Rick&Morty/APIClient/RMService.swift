//
//  Servise.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.01.2023.
//

//import Foundation
//
///// Promary API servise object to get Data
//final class RMService {
//    /// Shared singletone instance
//    static let shared = RMService()
//
//    private let cacheManager = RMAPICacheManager()
//
//    /// Privatized constructor
//    private init() {}
//
//    enum RMServiseError: Error {
//        case failedToCreateRequest
//        case failedToGetData
//    }
//
//    /// Send rick&Morty API Call
//    /// - Parameters:
//    ///  - requst: request Instance
//    ///  - type: The type of object we expect to get back
//    ///  - completion: Callback with data or error
//    public func execute<T: Codable>(
//        _ request: RMRequest,
//        expecting type: T.Type,
//        complition: @escaping (Result<T, Error>) -> Void
//    ) {
//
//        if let cachedData = cacheManager.cachedResponse(
//            for: request.endpoint,
//            url: request.url
//        ) {
//
//            do {
//                let result = try JSONDecoder().decode(type.self, from: cachedData)
//                complition(.success(result))
//            }
//            catch {
//                complition(.failure(error))
//            }
//            return
//        }
//
//        guard let urlRequest = self.request(from: request) else {
//            complition(.failure(RMServiseError.failedToCreateRequest))
//            return
//        }
//        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
//            guard let data = data, error == nil else {
//                complition(.failure(error ?? RMServiseError.failedToGetData))
//                return
//            }
//
//            // Decode response
//
//            do {
//                let result = try JSONDecoder().decode(type.self, from: data)
//                self?.cacheManager.setCache(
//                    for: request.endpoint,
//                    url: request.url,
//                    data: data
//                )
//                complition(.success(result))
//            }
//            catch {
//                complition(.failure(error))
//            }
//        }
//        task.resume()
//    }
//
//    //MARK: - Private
//
//    private func request(from rmRequest: RMRequest) -> URLRequest? {
//        guard let url = rmRequest.url else {
//            return nil
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = rmRequest.httpMethod
//        return request
//    }
//
//}

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()

    private let cacheManager = RMAPICacheManager()

    /// Privatized constructor
    private init() {}

    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }

    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
            return
        }

        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
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
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Private

    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
