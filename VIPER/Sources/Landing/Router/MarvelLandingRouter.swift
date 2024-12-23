import UIKit

protocol MarvelLandingRouterContract {
    func navigateToDetail(id: Int?)
}

class MarvelLandingRouter: MarvelLandingRouterContract {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func navigateToDetail(id: Int?) {
        let marvelDetailViewController = MarvelDetailRouter.createModule(id: id)
        viewController?.navigationController?.pushViewController(marvelDetailViewController, animated: true)
    }
}
