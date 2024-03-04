//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 25.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .imageFeedWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    private var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .imageFeedGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .imageFeedWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsideExitButton), for: .touchUpInside)
        return button
    }()
        
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileViewController()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
    }
    
    private func setupProfileViewController() {
        view.backgroundColor = .imageFeedBlack
        addSubViews()
        applyConstraints()
        updateAvatar()
        updateProfileDetails()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(userPhotoImageView)
        view.addSubviewWithoutAutoresizingMask(nameLabel)
        view.addSubviewWithoutAutoresizingMask(loginNameLabel)
        view.addSubviewWithoutAutoresizingMask(descriptionLabel)
        view.addSubviewWithoutAutoresizingMask(exitButton)
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
            nameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func updateAvatar() {
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        guard let profileImageURL = ProfileImageService.shared.avatarURL, let url = URL(string: profileImageURL) else { return }
        userPhotoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpeg"), options: [.processor(processor)])
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsideExitButton() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) { _ in
            self.profileLogoutService.logout()
        }
        alert.addAction(actionYes)
        let actionNo = UIAlertAction(title: "Нет", style: .default) { _ in }
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
}
