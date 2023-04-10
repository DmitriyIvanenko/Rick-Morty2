//
//  RMSettingsOptions.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 23.01.2023.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://rickandmortyapi.com/api")
        case .terms:
            return URL(string: "https://rickandmortyapi.com/api")
        case .privacy:
            return URL(string: "https://rickandmortyapi.com/api")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/api")
        case .viewSeries:
            return URL(string: "https://rickandmortyapi.com/api")
        case .viewCode:
            return URL(string: "https://github.com/afrazCodes/RickAndMortyiOSAPP")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms"
        case .privacy:
            return "Privacy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemBlue
        case .terms:
            return .systemBlue
        case .privacy:
            return .systemBlue
        case .apiReference:
            return .systemBlue
        case .viewSeries:
            return .systemBlue
        case .viewCode:
            return .systemBlue
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    
}
