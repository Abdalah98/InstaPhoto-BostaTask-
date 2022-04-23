//
//  Albums.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//
import Foundation

// MARK: - Album
struct Albums: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
