//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 20.02.2024.
//

import Foundation

extension URLSession {
    private enum NetworkError: Error {
        case codeError
        case dataError
    }
    
    func objectTask<T: Decodable>(for request: URLRequest, handler: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard let data = data else {
                handler(.failure(NetworkError.dataError))
                return
            }
            do {
                let responseBody = try JSONDecoder().decode(T.self, from: data)
                handler(.success(responseBody))
            } catch {
                handler(.failure(error))
            }
        })
        return task
    }
}
