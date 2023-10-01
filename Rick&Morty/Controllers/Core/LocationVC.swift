//
//  LocationVC.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 02.01.2023.
//

import UIKit

/// Controller to show and search  for Locations
final class LocationVC: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelagate {

    private let primaryView = RMLocationView()
    
    private let vieModel = RMLocationViewViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryView.delegate = self
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        addConstraint()
        vieModel.delegate = self
        vieModel.fetchLocations()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - RMLocationViewDelegate
    
    func rmLoacationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailVC(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Location ViewModel Delegate
    
    func didFetchInitialLocations() {
        primaryView.configure(with: vieModel)
    }
 
}
