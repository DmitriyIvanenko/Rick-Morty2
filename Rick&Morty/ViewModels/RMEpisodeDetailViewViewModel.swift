//
//  RMEpisodeDetailViewViewModel.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 17.01.2023.
//

import UIKit

class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl,
                let request = RMRequest(url: url) else {
            return
        }
        RMServise.shared.execute(request, expecting: RMEpisode.self) { resul in
            switch resul {
            case .success(let success):
                print(String(describing: success))
            case .failure:
                break
            }
            
        }
    }
}
