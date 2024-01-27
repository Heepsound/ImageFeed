//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 25.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private weak var userPhotoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var exitButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction private func touchUpInsideExitButton() {
        
    }
}

