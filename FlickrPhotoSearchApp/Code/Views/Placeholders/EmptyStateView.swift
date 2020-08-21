//
//  EmptyStateView.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import StatefulViewController

class EmptyStateView: UIView, StatefulPlaceholderView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var retryLabel: UILabel!

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(retryButtonPressed))
    }()
    
    private var retryClosure: (() -> Void)?

    private var didPressClose: (() -> Void)?
    
    private var viewInsets: UIEdgeInsets = .zero

    @discardableResult
    func prepareForDisplay(with title: String, retryTitle: String? = nil, insets: UIEdgeInsets = .zero, didPressClose: (() -> Void)? = nil, retryClosure: (() -> Void)? = nil) -> EmptyStateView {

        titleLabel.text = title
        retryLabel.text = retryTitle
        retryLabel.isHidden = retryTitle == nil

        viewInsets = insets

        self.retryClosure = retryClosure

        self.didPressClose = didPressClose

        if tapRecognizer.view == nil {
            addGestureRecognizer(tapRecognizer)
        }

        /// UITests
        titleLabel.accessibilityValue = "emptyView.title"
        retryLabel.accessibilityValue = "emptyView.retry"

        return self
    }
    
    func placeholderViewInsets() -> UIEdgeInsets {
        return viewInsets
    }
    
    @objc private func retryButtonPressed() {
        retryClosure?()
    }
}
