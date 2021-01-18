//
//  PostModel.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

class Post {
    let user: User
    let imageUrls: [URL]
    var images: [UIImage]?
    let videoUrls: [URL]?
    
    init(user: User, imageUrls: [URL], videoUrls: [URL]?) {
        self.user = user
        self.imageUrls = imageUrls
        self.videoUrls = videoUrls
    }
}
