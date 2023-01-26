//
//  RMEpisodeInfoCollectionViewCell.swift
//  Rick&Morty
//
//  Created by Dmytro Ivanenko on 25.01.2023.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    private let titleLabal: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabal: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(titleLabal, valueLabal)
        setUpLayer()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabal.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabal.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            valueLabal.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabal.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            titleLabal.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            valueLabal.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabal.text = nil
        valueLabal.text = nil
    }
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        titleLabal.text = viewModel.title
        valueLabal.text = viewModel.value
    }
}
