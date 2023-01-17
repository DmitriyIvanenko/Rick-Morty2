//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 10.01.2023.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    // IMage will be taken from previous screen, not downloading it one more time.
    
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
                
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
    
    
}

