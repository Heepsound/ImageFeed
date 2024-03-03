//
//  AllertPresenter.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 03.03.2024.
//

import UIKit

final class AlertPresenter {
    static func showError(delegate: UIViewController?) {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default) { _ in }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
