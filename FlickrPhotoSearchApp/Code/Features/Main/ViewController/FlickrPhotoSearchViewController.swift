//
//  FlickrPhotoSearchViewController.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import UIKit

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
    }
}
