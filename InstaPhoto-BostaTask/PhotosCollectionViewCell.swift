//
//  PhotosCollectionViewCell.swift
//  InstaPhoto-BostaTask
//
//  Created by Abdallah on 4/19/22.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    func set(photo:Photos){
        self.userPhotoImageView.loadImageUsingCacheWithURLString(photo.url, placeHolder: UIImage(named: "no_image_placeholder"))
    }
}
