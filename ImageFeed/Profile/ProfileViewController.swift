//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 25.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var userPhotoImageView: UIImageView!
    private var userPhoto: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            userPhotoImageView.image = userPhoto
        }
    }
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var exitButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndManualAutolayout()
    }
    
    private func createAndManualAutolayout() {
        userPhotoImageView = UIImageView()
        addSubview(userPhotoImageView)
        NSLayoutConstraint.activate([
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        userPhoto = UIImage(named: "UserPhoto")
        
        nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor)
        ])
        
        loginNameLabel = UILabel()
        addSubview(loginNameLabel)
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor)
        ])
        
        descriptionLabel = UILabel()
        addSubview(descriptionLabel)
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor)
        ])
        
        exitButton = UIButton(type: .custom)
        exitButton.addTarget(self, action: #selector(Self.touchUpInsideExitButton), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func addSubview(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subView)
    }
    
    // MARK: - Actions
    
    @objc
    private func touchUpInsideExitButton() {

    }
}
