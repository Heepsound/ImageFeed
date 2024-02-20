//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.02.2024.
//

import UIKit

final class OAuth2Service {
    private weak var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        var urlComponents = URLComponents(string: ApiConstants.unsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ApiConstants.accessKey),
            URLQueryItem(name: "client_secret", value: ApiConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: ApiConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    self?.task = nil
                    handler(.success(responseBody.accessToken))
                case .failure(let error):
                    self?.lastCode = nil
                    handler(.failure(error))
                }
            }
        }
        task?.resume()
    }
}
