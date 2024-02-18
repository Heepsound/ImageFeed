//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.02.2024.
//

import UIKit

final class OAuth2Service: NetworkClientDelegate {
    weak var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let networkClient = NetworkClient(self)
        var urlComponents = URLComponents(string: ApiConstants.unsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ApiConstants.accessKey),
            URLQueryItem(name: "client_secret", value: ApiConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: ApiConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        networkClient.sendPostRequest(url: urlComponents.url!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        handler(.success(oAuthTokenResponseBody.accessToken))
                        self.task = nil
                    } catch {
                        self.lastCode = nil
                        handler(.failure(error))
                    }
                case .failure(let error):
                    self.lastCode = nil
                    handler(.failure(error))
                }
            }
        }
    }
}
