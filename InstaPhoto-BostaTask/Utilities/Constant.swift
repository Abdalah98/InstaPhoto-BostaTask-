//
//  Constant.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//

import Foundation

// MARK: URL
enum Urls {
    static let  baseURL              = "https://jsonplaceholder.typicode.com/users"
    private static let userId        = "6"
}

// MARK: CollectionViewCell
enum Cell {
    static let photosCollectionViewCell = "PhotosCollectionViewCell"
    static let albumTableViewCell       = "AlbumTableViewCell"
}

// MARK: UICollectionView
enum StoryBoard {
    static let photoDetails         = "PhotoDetails"
    static let photoDetailsVC       = "PhotoDetailsVC"
    
    static let photo                = "Photo"
    static let userPhotosVC         = "UserPhotosVC"
}

