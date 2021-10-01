//
//  ImageCell.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with ImageInfo: Document) {
        if let thumbnailURL = URL(string: ImageInfo.thumbnailURL) {
            self.imageView.kf.setImage(with: thumbnailURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
