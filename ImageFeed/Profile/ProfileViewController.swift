//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 25.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var userPhotoImageView: UIImageView = {
        return UIImageView()
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    private var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(named: "YP Gray")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsideExitButton), for: .touchUpInside)
        return button
    }()
    
    private var userPhoto: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            userPhotoImageView.image = userPhoto
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhoto = UIImage(named: "UserPhoto")
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        addSubview(userPhotoImageView)
        addSubview(nameLabel)
        addSubview(loginNameLabel)
        addSubview(descriptionLabel)
        addSubview(exitButton)
    }

    private func addSubview(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsideExitButton() {
        
    }
}
