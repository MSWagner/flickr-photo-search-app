//
//  ImageDetailViewModel.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 24.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Combine
import FlickrPhotoSearchAppKit

@available(iOS 13.0, *)
class ImageDetailViewModel: ImageAble, ImageReloadAble {

    // MARK: - Properties

    private let photo: Photo

    private var downloader: ImageDownloader

    // MARK: - ImageAble Properties

    @Published var image: UIImage?

    // MARK: - StateAble Properties

    @Published var state: StateFulViewState = .empty

    let emptyTitle = Strings.Global.filterEmptyTitle
    let loadingTitle = Strings.Global.loadingTitle
    let errorTitle = Strings.Global.errorTitle

    // MARK: - Init

    init(photo: Photo, imageDownloader: ImageDownloader = ImageDownloader()) {
        self.photo = photo
        self.downloader = imageDownloader

        loadImage()
    }

    // MARK: - Networking

    private func loadImage() {
        let request = URLRequest(url: photo.imageURL ?? photo.thumbnailURL)

        state = .loading
        downloader.download(request) { [weak self] response in
    
            switch response.result {
            case .success(let image):
                self?.image = image
                self?.state = .content
            case .failure:
                self?.state = .error
            }
        }
    }

    func reloadImage() {
        switch state {
        case .loading, .content:
            return

        case .empty, .error:
            loadImage()
        }
    }
}
