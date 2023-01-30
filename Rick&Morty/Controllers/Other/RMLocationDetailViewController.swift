//
//  RMLoactionDetailViewController.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 30.01.2023.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {

    private let location: RMLocation
    
    //MARK: - Init
    
    init(location: RMLocation) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifececle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.backgroundColor = .systemBackground

    }
  
}
