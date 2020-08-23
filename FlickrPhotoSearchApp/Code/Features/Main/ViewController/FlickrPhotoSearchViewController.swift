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

    @IBOutlet weak var sortingButton: UIButton!

    // MARK: - Properties

    private var viewModel: FlickrPhotoSearchViewModel!

    private var disposableBag = CompositeDisposable()

    private let searchController = UISearchController(searchResultsController: nil)

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

        reloadImages()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bottomInset = sortingButton.isHidden ? 0 : view.safeAreaInsets.bottom + sortingButton.frame.height
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        
        tableView.contentInset = contentInsets
    }

    // MARK: - Setup

    private func setupViews() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.tableFooterView = UIView()

        sortingButton.isHidden = !viewModel.hasContent
        sortingButton.layer.cornerRadius = sortingButton.bounds.height / 2
        sortingButton.setTitle(Strings.Buttons.sorting, for: .normal)

        setupNotSearchingStateButtons()
    }

    private func setupNotSearchingStateButtons() {
        navigationItem.titleView = nil
        searchController.searchBar.text = nil

        let newSearchButton = UIBarButtonItem(title: Strings.NavigationBar.newSearch, style: .done, target: self, action: #selector(setupSearchBar))
        let refreshButton = UIBarButtonItem(title: Strings.NavigationBar.refresh, style: .done, target: self, action: #selector(reloadImages))

        navigationItem.leftBarButtonItem = newSearchButton
        navigationItem.rightBarButtonItem = refreshButton

        /// UITests
        newSearchButton.accessibilityIdentifier = "searchButton"
        refreshButton.accessibilityIdentifier = "refreshButton"
    }

    @objc private func setupSearchBar() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil

        searchController.searchBar.delegate = self

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal

        searchController.searchBar.setupSearchBarColors(customBackgroundColor: .white,
                                                        customTextColor: .black,
                                                        customPlacerholderColor: .gray)

        /// UITests
        searchController.searchBar.accessibilityTraits = .searchField
        searchController.searchBar.accessibilityIdentifier = "searchTextView"

        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true

        navigationItem.titleView?.becomeFirstResponder()
    }

    private func setupBindings() {
        disposableBag += viewModel.images.producer.startWithValues { [weak self] images in
            guard let self = self, let images = images else { return }

            self.setupDataSource(images: images)
        }

        disposableBag += viewModel.title.producer.startWithValues { [weak self] title in
            self?.title = title
        }

        disposableBag += viewModel.canSort.producer.startWithValues { [weak self] (canSort) in
            self?.sortingButton.isHidden = !canSort
            self?.view.setNeedsLayout()
        }
    }

    private func setupDataSource(images: [Photo]) {
        let rows = images.map { $0.row }
        let section = Section(rows: rows)

        dataSource.sections = [section]
        dataSource.reloadData(tableView, animated: true)
    }

    // MARK: - Networking

    private func fetchImages(for tag: String, force: Bool = false) {
        guard tag != viewModel.currentTag.value || force else { return }

        viewModel.resetImages()
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

    // MARK: - Actions

    @objc private func reloadImages() {
        fetchImages(for: viewModel.currentTag.value, force: true)
    }

    @IBAction func onSortingButton(_ sender: Any) {
        viewModel.sortPhotos()
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
        self.emptyView = emptyView?.prepareForDisplay(with: Strings.Global.filterEmptyTitle, retryTitle: Strings.Global.retryTitle, retryClosure: { [weak self] in
            self?.reloadImages()
        })
    }

    func hasContent() -> Bool {
        return viewModel.hasContent
    }
}

// MARK: - UISearchBarDelegate

extension FlickrPhotoSearchViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setupNotSearchingStateButtons()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newTag = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !newTag.isEmpty {
            fetchImages(for: newTag)
        }

        searchController.isActive = false
    }
}
