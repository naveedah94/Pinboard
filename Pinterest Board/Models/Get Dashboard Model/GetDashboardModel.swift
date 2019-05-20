//
//  GetDashboardModel.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

struct GetDashboardModel: Codable {
    let id: String?
    let createdAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let likes: Int?
    let likedByUser: Bool?
    let userDetails: User?
    let urls: Urls?
    let categories: [Category]?
}

extension GetDashboardModel {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case userDetails = "user"
        case urls = "urls"
        case categories = "categories"
    }
}


struct User: Codable {
    let id: String?
    let userName: String?
    let name: String?
    let profileImage: ProfileImage?
    let links: Link?
}

extension User {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case name = "name"
        case profileImage = "profile_image"
        case links = "links"
    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

extension ProfileImage {
    enum CodingKeys: String, CodingKey {
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
}

struct Link: Codable {
    let selfUrl: String?
    let htmlUrl: String?
    let photosUrl: String?
    let likesUrl: String?
}

extension Link {
    enum CodingKeys: String, CodingKey {
        case selfUrl = "self"
        case htmlUrl = "html"
        case photosUrl = "photos"
        case likesUrl = "likes"
    }
}

struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

extension Urls {
    enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
        case thumb = "thumb"
    }
}

struct Category: Codable {
    let id: Int?
    let title: String?
    let photoCount: Int?
    let links: Link?
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case photoCount = "photo_count"
        case links = "links"
    }
}
