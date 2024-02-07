//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.02.2024.
//

import UIKit

final class OAuth2Service {
    private enum AuthError: Error {
        case codeError
    }
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        let networkClient = NetworkClient()
        var urlComponents = URLComponents(string: ApiConstants.unsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ApiConstants.accessKey),
            URLQueryItem(name: "client_secret", value: ApiConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: ApiConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        networkClient.fetch(url: urlComponents.url!) { result in
            switch result {
            case .success(let data):
                do {
                    let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(oAuthTokenResponseBody.accessToken))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
