//
//  FlickrPhotoSearchViewModel.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Fetch
import FlickrPhotoSearchAppKit

class FlickrPhotoSearchViewModel {

    // MARK: - Properties

    private let _images = MutableProperty<[Photo]?>(nil)
    lazy var images: Property<[Photo]?> = {
        return Property(_images)
    }()

    var hasContent: Bool {
        return images.value != nil
    }

    private(set) var currentTag: String = "Halloween"

    // MARK: - Networking

    func fetchImages(for tag: String) -> SignalProducer<[Photo], FetchError> {
        currentTag = tag

        return API.Flickr
            .fetchImages(for: tag)
            .requestModel()
            .on { [weak self] (images) in
                self?._images.value = images
            }
    }
}
