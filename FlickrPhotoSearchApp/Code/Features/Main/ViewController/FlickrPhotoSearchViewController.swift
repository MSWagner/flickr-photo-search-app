//
//  FlickrPhotoSearchViewController.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit
import StatefulViewController
import DataSource
import ReactiveSwift
import FlickrPhotoSearchAppKit

class FlickrPhotoSearchViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private var viewModel: FlickrPhotoSearchViewModel!

    private var disposableBag = CompositeDisposable()

    // MARK: - DataSource

    private lazy var dataSource: DataSource = {
        return DataSource(cellDescriptors: [
            ImageTitleCell.cellDescriptor
                .height { 60 }
        ])
    }()

    // MARK: - LifeCycle

    static func create(viewModel: FlickrPhotoSearchViewModel) -> FlickrPhotoSearchViewController {
        let vc = UIStoryboard(.main).instantiateViewController(self)

        vc.viewModel = viewModel

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupStatefulViews()
        setupBindings()
        setupInitialViewState()

        fetchImages(for: "Halloween")
    }

    // MARK: - Setup

    private func setupViews() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.tableFooterView = UIView()
    }

    private func setupBindings() {
        disposableBag += viewModel.images.producer.startWithValues { [weak self] images in
            guard let self = self, let images = images else { return }

            self.setupDataSource(images: images)
        }
    }

    private func setupDataSource(images: [Photo]) {
        let rows = images.map { $0.row }
        let section = Section(rows: rows)

        dataSource.sections = [section]
        dataSource.reloadData(tableView, animated: true)
    }

    // MARK: - Networking

    private func fetchImages(for tag: String) {
        startLoading()

        viewModel.fetchImages(for: tag)
            .startWithResult { [weak self] (result) -> Void in

                switch result {
                case .success:
                    self?.endLoading(animated: true, error: nil)
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
