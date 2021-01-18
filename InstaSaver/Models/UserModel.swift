//
//  UserModel.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

class User {
    let userName: String
    let avatarUrl: URL
    var avatarImage: UIImage?
    
    init(username: String, avatarUrl: URL) {
        self.userName = username
        self.avatarUrl = avatarUrl
    }
}
