//
//  Constants.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 03.02.2024.
//

import Foundation

enum ApiConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
    static let accessKey = "JGzANjYM-bgAuOib94v2tU7d9pgnoNZ6t0remLwMpn4"
    static let secretKey = "Qsw1XAugiMQh8Q3H55aFITGHXkriDMzp5sGbcJFrtnI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: ApiConstants.accessKey,
                                     secretKey: ApiConstants.secretKey,
                                     redirectURI: ApiConstants.redirectURI,
                                     accessScope: ApiConstants.accessScope,
                                     authURLString: ApiConstants.unsplashAuthorizeURLString,
                                     defaultBaseURL: ApiConstants.defaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
