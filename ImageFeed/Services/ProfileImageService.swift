//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 20.02.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private weak var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, token: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        var urlComponents = URLComponents(url: ApiConstants.defaultBaseURL, resolvingAgainstBaseURL: false)!
        urlComponents.path = "/users/\(username)"
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    self?.avatarURL = responseBody.profileImage.small
                    NotificationCenter.default.post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: ["URL": responseBody.profileImage.small])
                    handler(.success(responseBody.profileImage.small))
                case .failure(let error):
                    handler(.failure(error))
                    URLSession.printError(service: "fetchProfileImageURL", errorType: "DataError", desc: "Ошибка получения URL аватара профиля")
                }
                self?.task = nil
            }
        }
        task?.resume()
    }
}
