//
//  JsonModel.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import Foundation

struct InstaJson: Codable {
    let graphql: Graph?
}

struct Graph: Codable {
    let shortcodeMedia: ShortcodeMedia?
}

struct ShortcodeMedia: Codable {
    let displayUrl: String?
    let videoUrl: String?
    let owner: Owner?
    let edgeSidecarToChildren: EdgeSidecarToChildren?
}

struct Owner: Codable {
    let username: String?
    let profilePicUrl: String?
}

struct EdgeSidecarToChildren: Codable {
    let edges: [Edges]?
}

struct Edges: Codable {
    let node: Node?
}

struct Node: Codable {
    let displayUrl: String?
    let videoUrl: String?
}
