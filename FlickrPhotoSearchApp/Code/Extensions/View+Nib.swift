//
//  View+Nib.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit

protocol Nibable {
    static func loadFromNib<T: UIView>(from bundle: Bundle) -> T?
}

extension UIView: Nibable {
    /// Tries to load a view from its nib if possible
    /// - Returns: Nil if there is no such nib
    static func loadFromNib<T: UIView>(from bundle: Bundle = Bundle.main) -> T? {
        guard let nibContent = bundle.loadNibNamed("\(self)", owner: self, options: nil)?.first as? T else { return nil }

        return nibContent
    }
}
