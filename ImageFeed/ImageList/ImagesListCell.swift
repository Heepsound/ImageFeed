//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    private var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "FavoritesActive"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsidelikeButton), for: .touchUpInside)
        return button
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "6 января 2024"
        label.textColor = .imageFeedWhite
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var imageURL: String? {
        didSet {
            guard let url = URL(string: imageURL ?? "") else { return }
            cellImage.kf.indicatorType = .activity
            cellImage.kf.setImage(with: url, placeholder: UIImage(named: "Scrible"))
        }
    }
    
    var imageDate: Date? {
        didSet {
            if let date = imageDate {
                dateLabel.text = date.dateString
            } else {
                dateLabel.text = Date().dateString
            }
        }
    }
    
    var isFavorites: Bool? {
        didSet {
            let likeButtonImage = isFavorites ?? false ? UIImage(named: "FavoritesActive") : UIImage(named: "FavoritesNotActive")
            likeButton.setImage(likeButtonImage, for: .normal)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImagesListCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImagesListCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubviewWithoutAutoresizingMask(cellImage)
        contentView.addSubviewWithoutAutoresizingMask(likeButton)
        contentView.addSubviewWithoutAutoresizingMask(dateLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 48),
            likeButton.widthAnchor.constraint(equalToConstant: 48),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsidelikeButton() {
        isFavorites = !(isFavorites ?? false) as Bool
    }
}
