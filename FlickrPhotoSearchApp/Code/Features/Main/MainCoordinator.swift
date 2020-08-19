import UIKit

class MainCoordinator: NavigationCoordinator {

    private var viewModel = FlickrPhotoSearchViewModel()
    
    func start() {
        let viewController = FlickrPhotoSearchViewController.create(viewModel: viewModel)
        
        push(viewController, animated: true)
    }
}
