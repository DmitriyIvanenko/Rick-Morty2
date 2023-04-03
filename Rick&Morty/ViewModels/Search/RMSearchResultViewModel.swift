//
//  RMSearchResultRepresenteble.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.03.2023.
//

import Foundation

final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType // To overwright - public private(set)
    private var next: String?
    
    // MARK: - Init
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
     
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(comletion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMServise.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next // Capture new pagination url
                
                //print(info.next)
                
                let aditionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                let newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .locations(let existingResults):
                    let newResults = existingResults + aditionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                case .charachters, .episodes:
                    break
                }
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    // Notify via callback
                    comletion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }
    
    public func fetchAdditionalResults(comletion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
            // Charachters
        case .charachters(let existingResults):
            RMServise.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next // Capture new pagination url
                    
                    //print(info.next)
                    
                    let aditionalResults = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus:  $0.status, characterImageUrl: URL(string: $0.image))
                    })
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + aditionalResults
                    strongSelf.results = .charachters(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        // Notify via callback
                        comletion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
            // Episodes
        case .episodes(let existingResults):
            RMServise.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next // Capture new pagination url
                    
                    //print(info.next)
                    
                    let aditionalResults = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string:  $0.url))
                    })
                    var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = existingResults + aditionalResults
                    strongSelf.results = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        // Notify via callback
                        comletion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            // TableView case
            break
        }
    }
}

enum RMSearchResultType {
    case charachters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

