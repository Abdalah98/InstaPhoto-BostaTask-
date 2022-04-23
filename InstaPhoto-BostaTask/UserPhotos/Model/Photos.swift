//
//  Photos.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//

import Foundation
// MARK: - Albums
struct Photos: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

 
