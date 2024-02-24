//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 19.02.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private weak var task: URLSessionTask?
    
    func fetchProfile(_ token: String, handler: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        var urlComponents = URLComponents(url: ApiConstants.defaultBaseURL, resolvingAgainstBaseURL: false)!
        urlComponents.path = "/me"
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    let profile = Profile(username: responseBody.userName,
                                          firstName: responseBody.firstName,
                                          lastName: responseBody.lastName,
                                          bio: (responseBody.bio ?? "") as String)
                    self?.profile = profile
                    handler(.success(profile))
                case .failure(let error):
                    handler(.failure(error))
                    URLSession.printError(service: "fetchProfile", errorType: "DataError", desc: "Ошибка создания модели профиля")
                }
                self?.task = nil
            }
        }
        task?.resume()
    }
}
