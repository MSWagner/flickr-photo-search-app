//
//  Photo+Sorted.swift
//  FlickrPhotoSearchAppKit
//
//  Created by Matthias Wagner on 22.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation

extension Array where Element == Photo {

    public func sorted() -> [Photo] {
        return self.sorted { (firstPhoto, secondPhoto) -> Bool in
            return firstPhoto.title.lowercased() < secondPhoto.title.lowercased()
        }
    }
}
