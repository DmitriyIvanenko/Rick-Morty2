//
//  RMSearchViewController.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 25.01.2023.
//

import UIKit

// Dynamic search option view
// Render status
// Render no rezult zero state
// Search / API call

/// Configurable controller to search
class RMSearchViewController: UIViewController {

    //MARK: - Configuration for search session
    
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode // name
            case location // name | type
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let viewModel: RMSearchViewViewModel
    private let searcView: RMSearchView
    
    //MARK: - Init
    
    init(config: Config) {
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searcView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searcView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch))
    }
    
    @objc
    
    private func didTapExecuteSearch() {
//        viewModel.executeSearch()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searcView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searcView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searcView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searcView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
