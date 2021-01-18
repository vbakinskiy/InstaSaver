//
//  InstaManager.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

typealias Json = [String : Any]

final class InstaManager {
    static func checkTheLink(_ link: String) -> String? {
        let regex = try! NSRegularExpression(pattern: "^https://(www.)?instagram.com/.*/", options: .caseInsensitive)
        let matches = regex.matches(in: link, options: [], range: NSMakeRange(0, link.count))
        guard !matches.isEmpty else {
            return nil
        }
        if let activeLink = link.components(separatedBy: "?").first {
            return activeLink
        } else {
            return nil
        }
    }
    
    static func getMediaPost(with link: String, completion: @escaping (Post?) -> ()) {
        getJson(link) { json in
            guard let json = json else {
                return DispatchQueue.main.async {
                    completion(nil)
                }
            }
            parseJson(json) { post in
                DispatchQueue.main.async {
                    completion(post)
                }
            }
        }
    }
    
    private static func getJson(_ link: String, completion: @escaping (InstaJson?) -> ()) {
        let url = URL(string: "\(link)?__a=1")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Can't fetch data")
                return completion(nil)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let json = try? decoder.decode(InstaJson.self, from: data) {
                completion(json)
            } else {
                print("Can't decode json")
                completion(nil)
            }
        }.resume()
    }
    
    private static func parseJson(_ json: InstaJson, completion: @escaping (Post?) -> ()) {
        guard let avatarUrl = json.graphql?.shortcodeMedia?.owner?.profilePicUrl?.url,
              let username = json.graphql?.shortcodeMedia?.owner?.username else {
            return completion(nil)
        }
        
        let user = User(username: username, avatarUrl: avatarUrl)
        var videoUrls: [URL]? = []
        
        if let videoUrl = json.graphql?.shortcodeMedia?.videoUrl?.url {
            videoUrls?.append(videoUrl)
        }
        
        var imageUrls: [URL] = []
        var images: [UIImage] = []
        
        URLSession.getImage(url: avatarUrl) { avatarImage in
            user.avatarImage = avatarImage
            
            if let edges = json.graphql?.shortcodeMedia?.edgeSidecarToChildren?.edges {
                for edge in edges {
                    if let url = edge.node?.displayUrl?.url {
                        imageUrls.append(url)
                    }
                    
                    if let url = edge.node?.videoUrl?.url {
                        videoUrls?.append(url)
                    }
                }
            } else {
                guard let imageUrl = json.graphql?.shortcodeMedia?.displayUrl?.url
                else { return completion(nil) }
                imageUrls.append(imageUrl)
            }
            
            let post = Post(user: user, imageUrls: imageUrls, videoUrls: videoUrls)
            var count = 0
            
            for imageUrl in imageUrls {
                URLSession.getImage(url: imageUrl) { image in
                    guard let image = image else { return completion(nil) }
                    count += 1
                    images.append(image)
                    post.images = images
                    
                    if count == imageUrls.count {
                        completion(post)
                    }
                }
            }
        }
    }
}
