//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 06.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
            return token
        }
        set {
            let isSuccess = KeychainWrapper.standard.set((newValue ?? "") as String, forKey: Keys.token.rawValue)
            guard isSuccess else { return }
        }
    }
}
