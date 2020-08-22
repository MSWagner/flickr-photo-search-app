//
//  Searchbar+Setub.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 22.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit

extension UISearchBar {

    func setupSearchBarColors(customBackgroundColor: UIColor = .white,
                              customTextColor: UIColor = .black,
                              customPlacerholderColor: UIColor = .gray) {

        if #available(iOS 13.0, *) {
            searchTextField.backgroundColor = customBackgroundColor
            searchTextField.tintColor = customTextColor
            searchTextField.textColor = customTextColor
            searchTextField.leftView?.tintColor = customTextColor
        } else {
            for view in self.subviews {
                for subview in view.subviews where subview is UITextField {
                    if let textField: UITextField = subview as? UITextField {

                        textField.backgroundColor = customTextColor
                        textField.textColor = customTextColor
                        textField.tintColor = customTextColor

                        //  Placeholder Color
                        let attributes = [NSAttributedString.Key.foregroundColor: customPlacerholderColor]
                        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                                             attributes: attributes)

                        //  Image Color
                        if let leftView = textField.leftView as? UIImageView {
                            leftView.tintColor = customTextColor
                        }

                        let backgroundView = textField.subviews.first
                        backgroundView?.backgroundColor = customBackgroundColor
                        backgroundView?.layer.cornerRadius = 10.5
                        backgroundView?.layer.masksToBounds = true
                    }
                }

            }
        }
    }

}
