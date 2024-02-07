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
