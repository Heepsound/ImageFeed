//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImageListCell"
}
