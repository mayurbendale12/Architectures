import UIKit

protocol MarvelLandingNavigatorContract {
    func navigateToDetail(id: Int?)
}

class MarvelLandingNavigator: MarvelLandingNavigatorContract {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func navigateToDetail(id: Int?) {
        let marvelDetailViewController = MarvelDetailViewController.instantiate()
        marvelDetailViewController.id = id
        viewController?.navigationController?.pushViewController(marvelDetailViewController, animated: true)
    }
}
