//
//  RMGetAllEpisodesResponse.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 17.01.2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
