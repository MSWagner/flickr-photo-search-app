//
//  ActivityIndicator.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 24.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
struct ActivityIndicator: UIViewRepresentable {

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView()

        return v
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
