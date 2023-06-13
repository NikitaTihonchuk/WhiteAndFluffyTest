import Foundation
import UIKit

final class TabBarController: UITabBarController {
    let moyaGetter = UnsplashAPIProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.main, .profile]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .main:
                let photoManager = PhotoManager(moyaGetter: moyaGetter)
                let mainController = MainViewController(photoManager: photoManager)
                    return self.wrappedInNavigationController(with: mainController, title: $0.title)
            case .profile:
                let profileController = ProfileViewController()
                    return self.wrappedInNavigationController(with: profileController, title: $0.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
        }
    }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
            return UINavigationController(rootViewController: with)
    }
 
    
    
    
}

private enum TabBarItem {
    case profile
    case main
   
    
    var title: String {
        switch self {
        case .main:
            return "Главная"
        case .profile:
            return "Профиль"
        }
    }
    
    var iconName: String {
        switch self {
        case .main:
            return "house.fill"
        case .profile:
            return "person.fill"
        }
    }
}

