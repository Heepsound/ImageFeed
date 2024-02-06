//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 03.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController else {
                return
            }
            guard let indexPath = sender as? IndexPath else {
                return
            }
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let cellImage = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.cellImage.image = cellImage
        cell.dateLabel.text = dateFormatter.string(from: Date())
        let likeButtonImage = indexPath.row % 2 == 0 ? UIImage(named: "FavoritesActive") : UIImage(named: "FavoritesNotActive")
        cell.likeButton.setImage(likeButtonImage, for: .normal)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
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
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

