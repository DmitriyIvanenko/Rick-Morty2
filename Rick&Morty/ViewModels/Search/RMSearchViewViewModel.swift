//
//  RMSearchViewViewModel.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 31.01.2023.
//

import Foundation

// Responsibilities
// - show search result
// - show no result view
// Kick of API requests

final class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
