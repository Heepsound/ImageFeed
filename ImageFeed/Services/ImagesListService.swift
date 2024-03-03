//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 29.02.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private weak var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private(set) var lastLoadedPhotosCount: Int?
    
    private init() { }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPhotosCount = 0
        guard var urlComponents = URLComponents(url: ApiConstants.defaultBaseURL, resolvingAgainstBaseURL: false) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage))
        ]
        urlComponents.path = "/photos"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResponseBody], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    for item in responseBody {
                        self?.photos.append(Photo(photoResponceBody: item))
                    }
                    self?.lastLoadedPage = nextPage
                    self?.lastLoadedPhotosCount = responseBody.count
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                case .failure(_):
                    URLSession.printError(service: "fetchPhotosNextPage", errorType: "DataError", desc: "Ошибка создания модели массива фото")
                }
                self?.task = nil
            }
        }
        task?.resume()
    }
}

