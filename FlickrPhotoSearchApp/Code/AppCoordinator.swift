import UIKit
import FlickrPhotoSearchAppKit
import ReactiveSwift

class AppCoordinator: Coordinator {
    
    static let shared = AppCoordinator()
    
    var window: UIWindow!
    let mainCoordinator = FlickrPhotoSearchCoordinator()
    
    func start(window: UIWindow) {
        self.window = window
        
        mainCoordinator.start()
        addChild(mainCoordinator)
       
        window.rootViewController = mainCoordinator.rootViewController
        window.makeKeyAndVisible()
        
        printRootDebugStructure()
    }
    
    func reset(animated: Bool) {
        childCoordinators
            .filter { $0 !== mainCoordinator }
            .forEach { removeChild($0) }
        
        mainCoordinator.popToRoot(animated: animated)
        
        printRootDebugStructure()
    }
}
