import UIKit

class MainCoordinator: NavigationCoordinator {
    
    func start() {
        let viewController = FlickrPhotoSearchViewController()
        
        push(viewController, animated: true)
    }
}
