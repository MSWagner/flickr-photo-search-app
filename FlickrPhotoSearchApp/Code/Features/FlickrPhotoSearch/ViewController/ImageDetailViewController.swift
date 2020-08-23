//
//  ImageDetailViewController.swift
//  Toolsense
//
//  Created by Matthias Wagner on 25.02.20.
//  Copyright © 2020 aaa - all about apps Gmbh. All rights reserved.
//

import UIKit
import Photos
import AlamofireImage

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailImageView: UIImageView!

    private var image: UIImage?

    private var imageURL: URL?

    // MARK: - LifeCycle

    static func create(imageURL: URL, title: String?) -> ImageDetailViewController {
        let vc = UIStoryboard(.flickrPhotoSearch).instantiateViewController(self)

        vc.imageURL = imageURL
        vc.title = title

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()

        detailImageView.image = image

        if let url = imageURL {
            detailImageView.af.setImage(withURL: url, placeholderImage: Asset.photoPlaceholder.image)
        }
    }

    // MARK: - Setup

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.zoomScale = 1
    }
}

// MARK: - UIScrollViewDelegate

extension ImageDetailViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detailImageView
    }
}
