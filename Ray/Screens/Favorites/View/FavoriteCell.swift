//
//  FavoriteCell.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit

class FavoriteCell: UITableViewCell {
    private let imageHeight: CGFloat = 120
    private let imageWidth: CGFloat = 120
    private let imagePadding: CGFloat = 10
    
    static let identifier: String = "FavoriteCell"
    
    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    private func configureUI() {
        contentView.addSubview(pictureImageView)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imagePadding),
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: imagePadding),
            pictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -imagePadding),
            pictureImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            pictureImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: imagePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -imagePadding),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: imagePadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -imagePadding)
        ])
    }
    
    func configure(withImage image: UIImage?, description: String) {
        pictureImageView.image = image
        descriptionLabel.text = description
    }
}

