//
//  RMLocationDetailViewViewModel.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 30.01.2023.
//

import Foundation

    protocol RMLocationDetailViewViewModelDelegate: AnyObject {
        func didFetchLocationDetails()
    }

    final class RMLocationDetailViewViewModel {
        
        private let endpointUrl: URL?
        
        private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
            didSet {
                createCellviewModels()
                delegate?.didFetchLocationDetails()
            }
        }
        
        enum Sectiontype {
            case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
            case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
        }
        
        public weak var delegate: RMLocationDetailViewViewModelDelegate?
        
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
            let location = dataTuple.location
            let characters = dataTuple.characters
            
            // Formatting date
            var createdString = location.created
            if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormater.date(from: location.created) {
                createdString = RMCharacterInfoCollectionViewCellViewModel.shaortDateFormater.string(from: date)
            }
            
            cellViewModels = [
                .information(viewModels: [
                    .init(title: "Location Name", value: location.name),
                    .init(title: "Tyoe", value: location.type),
                    .init(title: "Dimantion", value: location.dimension),
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
        
        /// Fetch backing location model
        public func fetchLocationData() {
            guard let url = endpointUrl,
                    let request = RMRequest(url: url) else {
                return
            }
            RMServise.shared.execute(request, expecting: RMLocation.self) { [weak self] resul in
                switch resul {
                case .success(let model):
                    self?.fetchRelatedCharachter(location: model)
                case .failure:
                    break
                }
                
            }
        }
        
        private func fetchRelatedCharachter(location: RMLocation) {
            let requests: [RMRequest] = location.residents.compactMap({
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
                        location: location,
                        characters: characters
                    )
                }
            }
        }
        
    }

