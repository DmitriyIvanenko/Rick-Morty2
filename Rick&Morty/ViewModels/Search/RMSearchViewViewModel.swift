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
    
    private var searchResultHandler: (() -> Void)?
    
    // MARK: - Init
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        
        searchText = "Rick"

        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText)
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
            queryParamentrs: queryParams
        )
                    
        RMServise.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print(model.results.count)
            case .failure:
                break
            }
        }
        
        print(request.url?.absoluteString)
        
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
}
