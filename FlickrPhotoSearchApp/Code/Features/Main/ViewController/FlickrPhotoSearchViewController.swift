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
    }

    // MARK: - Networking

    private func loadData() {
//        if let loadingViewModel = viewModel as? LoadDataActionAble {
//            startLoading()
//            requestDisposable = loadingViewModel.loadDataAction.apply().startWithResult { [weak self] result in
//
//                switch result {
//                case .success:
//                    self?.endLoading(animated: true, error: nil, completion: nil)
//                case .failure(let error):
//                    self?.endLoading(animated: true, error: error, completion: nil)
//                }
//            }
//        }
    }
}

// MARK: - StatefulViewController

extension FlickrPhotoSearchViewController: StatefulViewController {

    private func setupStatefulViews() {
        let loadingView: LoadingStateView? = LoadingStateView.loadFromNib()
        self.loadingView = loadingView?.prepareForDisplay(with: Strings.Global.loadingTitle)

        let errorView: ErrorStateView? = ErrorStateView.loadFromNib()
        self.errorView = errorView?.prepareForDisplay(with: Strings.Global.errorTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.loadData()
        })

        let emptyView: EmptyStateView? = EmptyStateView.loadFromNib()
        self.emptyView = emptyView?.prepareForDisplay(with: Strings.Global.emptyTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.loadData()
        })
    }

    func hasContent() -> Bool {
        return viewModel.hasContent
    }
}
