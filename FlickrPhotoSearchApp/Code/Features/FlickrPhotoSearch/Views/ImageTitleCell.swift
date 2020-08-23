//
//  ImageTitleCell.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import DataSource
import AlamofireImage
import FlickrPhotoSearchAppKit

class ImageTitleCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.af.cancelImageRequest()
        photoImageView.image = nil
        titleLabel.text = nil
    }

    // MARK: - Configure

    func configure(with photo: Photo) {
        titleLabel.text = photo.title

        photoImageView.af.setImage(withURL: photo.thumbnailURL, placeholderImage: Asset.photoPlaceholder.image)
    }
}

// MARK: - Datasource

extension ImageTitleCell {

    static var cellDescriptor: CellDescriptor<Photo, ImageTitleCell> {
        return CellDescriptor().configure { (photo, cell, _) in
            cell.configure(with: photo)
        }
    }
}
