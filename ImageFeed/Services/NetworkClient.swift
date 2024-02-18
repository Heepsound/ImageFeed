//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.02.2024.
//

import Foundation

protocol NetworkClientDelegate: AnyObject {
    var task: URLSessionTask? { get set }
}

struct NetworkClient {
    weak var delegate: NetworkClientDelegate?
    private enum NetworkError: Error {
        case codeError
    }
    
    func sendPostRequest(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard let data = data else { return }
            handler(.success(data))
        }
        delegate?.task = task
        task.resume()
    }
    
    // MARK: - Lifecycle
    
    init(_ delegate: NetworkClientDelegate? = nil) {
        self.delegate = delegate
    }
}
