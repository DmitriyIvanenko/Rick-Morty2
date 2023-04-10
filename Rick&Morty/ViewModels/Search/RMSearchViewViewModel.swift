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
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]

    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void)?
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
    private var searchResultModel: Codable?
    
    // MARK: - Init
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {

        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOptions = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Ctreate request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchApiCall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchApiCall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchApiCall(RMGetAllLocationsResponse .self, request: request)
        }
    }
    
    private func makeSearchApiCall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                // Episodes, Characters - Collection View | Location - Table View
                self?.processSearchResult(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResult(model: Codable ) {
        var resultsVM: RMSearchResultType?
        var nextUrl: String?
        if let charachterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .charachters(charachterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
            nextUrl = charachterResults.info.next
        }
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            nextUrl = episodesResults.info.next
        }
        else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0 )
            }))
            nextUrl = locationsResults.info.next
        }
        if let results = resultsVM {
            self.searchResultModel = model
            let vm = RMSearchResultViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        } else {
            // Falback Error
            handleNoResults()
        }
    }
    
    public func handleNoResults() {
        noResultsHandler?()
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOptions) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChargeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void) {
            self.optionMapUpdateBlock = block
    }
    
    public func locationSearchResultAt(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}


