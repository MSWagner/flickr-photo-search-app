//
//  FlickrPhoto.swift
//  FlickrPhotoSearchAppKit
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation

public struct Photo: Codable {
    public let url_sq: URL
    public let title: String

    public init(title: String, url_sq: URL) {
        self.title = title
        self.url_sq = url_sq
    }
}
