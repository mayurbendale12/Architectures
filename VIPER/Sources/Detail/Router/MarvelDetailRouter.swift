protocol MarvelDetailRouterContract {
    static func createModule(id: Int?) -> MarvelDetailViewController
}

class MarvelDetailRouter: MarvelDetailRouterContract {
    static func createModule(id: Int?) -> MarvelDetailViewController {
        let marvelDetailViewController = MarvelDetailViewController.instantiate()
        marvelDetailViewController.id = id
        return marvelDetailViewController
    }
}
