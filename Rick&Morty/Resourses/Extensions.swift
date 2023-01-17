//
//  Extensions.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 04.01.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
