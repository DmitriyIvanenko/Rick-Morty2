//
//  Request.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.01.2023.
//

import Foundation

//MARK: - Object that represent a single API call

final class RMRequest {
    // Base url - API Constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    // Desired Endpoint
   let endpoint: RMEndPoint
    
    // Path components for API, if any
    private let pathComponents: [String]
    
    // Query paramentres for API, if any
    private let queryParamentrs: [URLQueryItem]
    
    // Constructed URL for the API request in string format
    private var urlString: String {
        var string =  Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParamentrs.isEmpty {
            string += "?"
            // name+value&name+value
            let argumentString = queryParamentrs.compactMap({
                string += "/\($0)" // $0 - current element in iteration
                guard let value = $0.value
                else {
                    return nil
                }
                return"\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    // Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    //Desired HTTP Method
    public let httpMethod = "GET"
    
    //MARK: - PUBLIC
    // Specifying constructor for this class
    
    /// Construct request
    /// - Parameters:
    ///    - endpoint: Target Endpoint
    ///    - pathComponents: Collection of Path components
    ///    - queryParamentrs: Collection of query parameters
    public init(
        endpoint: RMEndPoint,
        pathComponents: [String] = [],
        queryParamentrs: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParamentrs = queryParamentrs
    }
    
    /// Attempt to ocreate request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndPoint(
                    rawValue: endpointString
                ) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
            
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParamentrs: queryItems)
                    return
                }
            }
        }
        return nil
    }
    
    
}


extension RMRequest {
    static let listCharactersRequets = RMRequest(endpoint: .character)
}
