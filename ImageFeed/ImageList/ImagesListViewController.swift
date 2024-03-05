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
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagesListViewController()
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
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
    
    func updateTableViewAnimated() {
        guard let newPhotosCount = imagesListService.lastLoadedPhotosCount else { return }
        if newPhotosCount == 0 { return }
        tableView.performBatchUpdates {
            let photosCount = imagesListService.photos.count
            let indexPaths = (photosCount - newPhotosCount..<photosCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        let photo = imagesListService.photos[indexPath.row]
        imageCell.delegate = self
        imageCell.imageURL = photo.thumbImageURL
        imageCell.imageDate = photo.createdAt
        imageCell.isFavorites = photo.isLiked
        return imageCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = imagesListService.photos[indexPath.row]
        let ratio = (tableView.bounds.width - 32) / photo.size.width
        return photo.size.height * ratio + 8
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let photo = imagesListService.photos[indexPath.row]
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.imageURL = photo.largeImageURL
        self.present(singleImageViewController, animated: false, completion: nil)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = imagesListService.photos[indexPath.row]
        UIBlockingProgressHUD.animate()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] (result: Result<Void, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    cell.isFavorites = self?.imagesListService.photos[indexPath.row].isLiked
                    UIBlockingProgressHUD.dismiss()
                case .failure(_):
                    UIBlockingProgressHUD.dismiss()
                    AlertPresenter.showError(delegate: self)
                }
            }
        }
    }
}


