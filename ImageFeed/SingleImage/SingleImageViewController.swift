//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 26.01.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "Scrible")
        return imageView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Backward"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsideBackButton), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsideShareButton), for: .touchUpInside)
        return button
    }()
    
    var imageURL: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSingleImageViewController()
    }
    
    private func setupSingleImageViewController() {
        view.backgroundColor = .imageFeedBlack
        addSubViews()
        applyConstraints()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2
        rescaleAndCenterImageInScrollView()
        loadImage()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(scrollView)
        scrollView.addSubviewWithoutAutoresizingMask(imageView)
        view.addSubviewWithoutAutoresizingMask(backButton)
        view.addSubviewWithoutAutoresizingMask(shareButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
        NSLayoutConstraint.activate([
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36)
        ])
    }
    
    private func loadImage() {
        guard let url = URL(string: imageURL ?? "") else { return }
        imageView.kf.indicatorType = .activity
        UIBlockingProgressHUD.animate()
        imageView.kf.setImage(with: url) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(_):
                    self?.rescaleAndCenterImageInScrollView()
                case .failure:
                    self?.showError()
                }
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView() {
        guard let image = imageView.image else { return }
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / image.size.width
        let vScale = visibleRectSize.height / image.size.height
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let x = (scrollView.contentSize.width - visibleRectSize.width) / 2
        let y = (scrollView.contentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Попробовать еще раз?",
                                      preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Не надо", style: .default) { _ in }
        alert.addAction(actionCancel)
        let actionRepeat = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadImage()
        }
        alert.addAction(actionRepeat)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsideBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func touchUpInsideShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
