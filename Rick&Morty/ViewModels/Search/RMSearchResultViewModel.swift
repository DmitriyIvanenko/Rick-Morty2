//
//  RMSearchResultRepresenteble.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.03.2023.
//

import Foundation

enum RMSearchResultViewModel {
    case charachters([RMCharacterCollectionViewCellViewModel])
    case episodes ([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations ([RMLocationTableViewCellViewModel])
}
