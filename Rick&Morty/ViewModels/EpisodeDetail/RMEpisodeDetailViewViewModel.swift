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
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellviewModels()
            delegate?.didFetchepisodeDetail()
        }
    }
    
    enum Sectiontype {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [Sectiontype] = []
    
    //MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    //MARK: - Private
    
    public func createCellviewModels() {
        
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        // Formatting date
        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormater.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shaortDateFormater.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }
    
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
                    episode: episode,
                    characters: characters
                )
            }
        }
    }
    
}
