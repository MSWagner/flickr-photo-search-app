//
//  Stubs.swift
//  FlickrPhotoSearchAppKit
//
//  Created by Matthias Wagner on 21.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation

public class Stub {

    let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    public func jsonData() -> Data {
        let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
}
