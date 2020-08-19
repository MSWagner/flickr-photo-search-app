//
//  ErrorStateView.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import StatefulViewController

class ErrorStateView: UIView, StatefulPlaceholderView {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var retryLabel: UILabel!

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(retryButtonPressed))
    }()
    
    private var retryClosure: (() -> Void)?

    private var didPressClose: (() -> Void)?
    
    private var viewInsets: UIEdgeInsets = .zero
    
    @discardableResult
    func prepareForDisplay(with title: String, retryTitle: String? = nil, insets: UIEdgeInsets = .zero, didPressClose: (() -> Void)? = nil, retryClosure: (() -> Void)? = nil) -> ErrorStateView {
        titleLabel.text = title
        retryLabel.text = retryTitle
        retryLabel.isHidden = retryTitle == nil
        self.retryClosure = retryClosure
        viewInsets = insets

        self.didPressClose = didPressClose

        if tapRecognizer.view == nil {
            addGestureRecognizer(tapRecognizer)
        }
        
        return self
    }
    
    func placeholderViewInsets() -> UIEdgeInsets {
        return viewInsets
    }
    
    @objc private func retryButtonPressed() {
        retryClosure?()
    }
}
