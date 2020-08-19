//
//  Photo+Row.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation
import DataSource
import FlickrPhotoSearchAppKit

extension Photo {

    var row: RowType {
        return Row(self)
    }
}
