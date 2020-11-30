//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/16/20.
//

import UIKit
import SDWebImage

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var spot: Spot!
    var photo: Photo! {
        didSet {
            if let url = URL(string: self.photo.photoURL) {
                self.photoImageView.sd_setTransition = .fade
                self.photoImageView.sd_setTransition?.duration = 0.2
                self.photoImageView.sd_setImage(with: url)
            } else {
                print("Error: URL didn't work \(self.photo.photoURL)")
                self.photo.loadImage(spot: self.spot) { (success) in
                    self.photo.saveData(spot: self.spot) { (success) in
                        print("image updated with URL \(self.photo.photoURL)")
                    }
                }
            }

        }
    }
}
