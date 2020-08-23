//
//  FlickrPhoto.swift
//  FlickrPhotoSearchAppKit
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation

public struct Photo: Codable {

    // MARK: - Properties

    public let title: String

    public let thumbnailURL: URL
    public let imageURL: URL?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case title

        case thumbnailURL = "url_sq"
        case imageURL = "url_o"
    }
}
