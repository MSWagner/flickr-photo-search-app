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
import StatefulViewController
import FlickrPhotoSearchAppKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailImageView: UIImageView!

    private var imageURL: URL!

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
        setupStatefulViews()
        loadImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        detailImageView.af.cancelImageRequest()
    }

    // MARK: - Setup

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.zoomScale = 1
    }

    // MARK: - Load Image

    private func loadImage() {
        detailImageView.af.cancelImageRequest()

        startLoading()
        detailImageView.af.setImage(withURL: imageURL) { [weak self] (response) in
            self?.endLoading(animated: true, error: response.error)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ImageDetailViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detailImageView
    }
}

// MARK: - StatefulViewController

extension ImageDetailViewController: StatefulViewController {

    private func setupStatefulViews() {
        let loadingView: LoadingStateView? = LoadingStateView.loadFromNib()
        self.loadingView = loadingView?.prepareForDisplay(with: Strings.Global.loadingTitle)

        let errorView: ErrorStateView? = ErrorStateView.loadFromNib()
        self.errorView = errorView?.prepareForDisplay(with: Strings.Global.errorTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.loadImage()
        })

        let emptyView: EmptyStateView? = EmptyStateView.loadFromNib()
        self.emptyView = emptyView?.prepareForDisplay(with: Strings.Global.filterEmptyTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.loadImage()
        })
    }

    func hasContent() -> Bool {
        return detailImageView.image != nil
    }
}
