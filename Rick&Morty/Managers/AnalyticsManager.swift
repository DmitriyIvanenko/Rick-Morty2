//
//  AnalyticsManager.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 04.05.2023.
//

import Foundation
import FirebaseAnalytics
// Manager to handle App analytics
final class AnalyticsManager {
    
    private init() {}
    
    static let shared = AnalyticsManager()
    
    public func log(_ event: Analyticsevent) {
        var parameters: [String: Any] = [:]
        switch event {
        case .characterSelected(let rMCharacterSelectedevent):
            do {
                let data = try JSONEncoder().encode(rMCharacterSelectedevent)
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
                parameters = dict
            }
            catch {
                
            }
        }
        
        print("\n Event: \(event.eventName) | Params: \(parameters)")
        
        Analytics.logEvent(event.eventName, parameters: parameters)
    }
}

enum Analyticsevent {
    case characterSelected(RMCharacterSelectedevent)
    
    var eventName: String {
        switch self {
        case .characterSelected: return "character selected"
        }
    }
}

struct RMCharacterSelectedevent: Codable {
    let character: String
    let origin: String
    let timestamp: Date
}
