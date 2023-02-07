//
//  RMSearchInputViewViewModel.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 31.01.2023.
//

import Foundation

struct RMSearchInputViewViewModel {
    
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOptions: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var queryArgument: String {
            switch self {
            case .status:
                return "status"
            case .gender:
                return "gender"
            case .locationType:
                return "type"
            }
        }
        
        var choises: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
                
            case .gender:
                return ["famale", "male", "genderless", "unknown" ]
                
            case .locationType:
                return ["cluster", "planet", "microverse"]
            }
        }
    }
    
    // MARK: - Init
    
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    // MARK: - Public
    
    public var  hasDynamicOptions: Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }
    
    public var options: [DynamicOptions] {
        switch self.type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    public var searchPlaceholderText: String {
        switch self.type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return"Episode Title"
        }
    }
}
