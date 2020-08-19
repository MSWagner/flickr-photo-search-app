//
//  FlickrPhotoSearchViewController.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import StatefulViewController
import FlickrPhotoSearchAppKit

class FlickrPhotoSearchViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private var viewModel: FlickrPhotoSearchViewModel!

    // MARK: - LifeCycle

    static func create(viewModel: FlickrPhotoSearchViewModel) -> FlickrPhotoSearchViewController {
        let vc = UIStoryboard(.main).instantiateViewController(self)

        vc.viewModel = viewModel

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStatefulViews()
        setupInitialViewState()

        fetchImages(for: "Halloween")
    }

    // MARK: - Networking

    private func fetchImages(for tag: String) {
        startLoading()

        viewModel.fetchImages(for: tag)
            .startWithResult { [weak self] (result) -> Void in

                switch result {
                case .success: break
                case .failure(let error):
                    self?.endLoading(animated: true, error: error)
                }
            }
    }

    private func reloadImages() {
        fetchImages(for: viewModel.currentTag)
    }
}

// MARK: - StatefulViewController

extension FlickrPhotoSearchViewController: StatefulViewController {

    private func setupStatefulViews() {
        let loadingView: LoadingStateView? = LoadingStateView.loadFromNib()
        self.loadingView = loadingView?.prepareForDisplay(with: Strings.Global.loadingTitle)

        let errorView: ErrorStateView? = ErrorStateView.loadFromNib()
        self.errorView = errorView?.prepareForDisplay(with: Strings.Global.errorTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.reloadImages()
        })

        let emptyView: EmptyStateView? = EmptyStateView.loadFromNib()
        self.emptyView = emptyView?.prepareForDisplay(with: Strings.Global.emptyTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.reloadImages()
        })
    }

    func hasContent() -> Bool {
        return viewModel.hasContent
    }
}
