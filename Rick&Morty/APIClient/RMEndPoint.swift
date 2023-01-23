//
//  EndPoint.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.01.2023.
//

import Foundation

///Represent unique API endpoint
@frozen enum RMEndPoint: String, CaseIterable ,Hashable {
    /// Endpoint to get character info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}