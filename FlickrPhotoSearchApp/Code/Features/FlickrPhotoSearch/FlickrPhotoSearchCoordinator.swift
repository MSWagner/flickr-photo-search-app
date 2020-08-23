//
//  FlickrPhotoSearchCoordinator.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 23.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import FlickrPhotoSearchAppKit

class FlickrPhotoSearchCoordinator: NavigationCoordinator {

    // MARK: - Properties

    private var viewModel = FlickrPhotoSearchViewModel()

    // MARK: - Start

    func start() {
        let viewController = FlickrPhotoSearchViewController.create(viewModel: viewModel)

        viewController.didPressOnPhoto = { [unowned self] (photo) in
            self.showImageDetailView(with: photo)
        }
        
        push(viewController, animated: true)
    }

    // MARK: - Navigation

    private func showImageDetailView(with photo: Photo) {
        let vc = ImageDetailViewController.create(imageURL: photo.imageURL ?? photo.thumbnailURL, title: photo.title)

        push(vc, animated: true)
    }
}
