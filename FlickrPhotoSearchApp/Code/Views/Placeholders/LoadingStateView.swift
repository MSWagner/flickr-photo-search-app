//
//  LoadingStateView.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import StatefulViewController

class LoadingStateView: UIView, StatefulPlaceholderView {
    
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!

    private var didPressClose: (() -> Void)?

    private var viewInsets: UIEdgeInsets = .zero
    
    @discardableResult
    func prepareForDisplay(with title: String, insets: UIEdgeInsets = .zero, didPressClose: (() -> Void)? = nil) -> LoadingStateView {
        titleLabel.text = title
        loadingIndicator.startAnimating()
        viewInsets = insets
        self.didPressClose = didPressClose

        return self
    }
    
    func placeholderViewInsets() -> UIEdgeInsets {
        return viewInsets
    }
}
