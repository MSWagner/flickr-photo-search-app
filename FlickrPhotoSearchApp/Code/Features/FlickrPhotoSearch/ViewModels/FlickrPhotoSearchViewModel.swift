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
import Combine
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

    private var _isSorted = MutableProperty<Bool>(false)
    lazy var canSort: Property<Bool> = {
        return Property
            .combineLatest(_images, _isSorted)
            .map { (images, isSorted) -> Bool in
                let hasContent = images != nil &&  images!.count > 0

                return hasContent && !isSorted
            }
    }()

    var hasContent: Bool {
        return images.value != nil &&  images.value!.count > 0
    }

    // MARK: - Networking

    func fetchImages(for tag: String) -> SignalProducer<[Photo], FetchError> {
        _currentTag.value = tag
        _isSorted.value = false

        return API.Flickr
            .fetchImages(for: tag)
            .requestModel()
            .on { [weak self] (images) in
                self?._images.value = images
            }
    }

    func sortPhotos() {
        if let images = images.value {
            _images.value = images.sorted()
            _isSorted.value = true
        }
    }

    // MARK: - Reset

    func resetImages() {
        _images.value = nil
    }
}
