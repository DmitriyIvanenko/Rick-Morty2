//
//  RMEpisodeDetailViewViewModel.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 17.01.2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchepisodeDetail()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?

    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchepisodeDetail()
        }
    }
    
    enum Sectiontype {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var sections: [Sectiontype] = []
    
    //MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    //MARK: - Public
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
                let request = RMRequest(url: url) else {
            return
        }
        RMServise.shared.execute(request, expecting: RMEpisode.self) { [weak self] resul in
            switch resul {
            case .success(let model):
                self?.fetchRelatedCharachter(episode: model)
            case .failure:
                break
            }
            
        }
    }
    
    //MARK: - Private
    
    private func fetchRelatedCharachter(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter() // +20 increments every time
            RMServise.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave() // -20 decrementing
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
            group.notify(queue: .main) {
                self.dataTuple = (
                episode,
                characters
                )
            }
        }
    }
    
}
