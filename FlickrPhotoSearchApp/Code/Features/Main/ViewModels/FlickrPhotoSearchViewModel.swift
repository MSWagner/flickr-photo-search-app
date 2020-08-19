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

    private var _currentTag = MutableProperty<String>("Halloween")
    lazy var currentTag: Property<String> = {
        return Property(_currentTag)
    }()

    lazy var title: Property<String> = {
        return Property(_currentTag).map { "#\($0)" }
    }()

    var hasContent: Bool {
        return images.value != nil
    }

    // MARK: - Networking

    func fetchImages(for tag: String) -> SignalProducer<[Photo], FetchError> {
        _currentTag.value = tag

        return API.Flickr
            .fetchImages(for: tag)
            .requestModel()
            .on { [weak self] (images) in
                self?._images.value = images
            }
    }

    // MARK: - Reset

    func resetImages() {
        _images.value = nil
    }
}
