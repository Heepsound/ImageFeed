//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 03.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .imageFeedBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return tableView
    }()
    private lazy var imageListCell: ImagesListCell = {
        return ImagesListCell(style: .default, reuseIdentifier: ImagesListCell.reuseIdentifier)
    }()
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagesListViewController()
    }
    
    private func setupImagesListViewController() {
        view.backgroundColor = .imageFeedBlack
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(tableView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let cellImage = UIImage(named: photosName[indexPath.row]) else { return }
        cell.image = cellImage
        cell.imageDate = Date()
        cell.isFavorites = indexPath.row % 2 == 0
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageCell, with: indexPath)
        return imageCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellImage = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let ratio = (tableView.bounds.width - 32) / cellImage.size.width
        return cellImage.size.height * ratio + 8
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.image = UIImage(named: photosName[indexPath.row])
        self.present(singleImageViewController, animated: false, completion: nil)
    }
}


