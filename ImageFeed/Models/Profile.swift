//
//  Profile.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 19.02.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(username: String, firstName: String, lastName: String, bio: String) {
        self.username = username
        self.name = "\(firstName) \(lastName)"
        self.loginName = "@" + self.username
        self.bio = bio
    }
}
