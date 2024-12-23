protocol MarvelDetailPresenterContract {
    func viewLoaded()
}

class MarvelDetailPresenter: MarvelDetailPresenterContract {
    private weak var view: MarvelDetailViewContract?
    private let interactor: MarvelDetailInteractorContract
    private let router: MarvelDetailRouterContract
    private let id: Int?

    init(view: MarvelDetailViewContract,
         interactor: MarvelDetailInteractorContract,
         router: MarvelDetailRouterContract,
         id: Int?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.id = id
    }

    func viewLoaded() {
        guard let id else { return }
        view?.showSpinner()
        interactor.fetchMarvelData(id: id) { [weak self] result in
            switch result {
            case .success(let model):
                self?.view?.hideSpinner()
                let viewModel = MarvelDetailViewModel(name: model.name ?? "",
                                                      description: model.description,
                                                      imageURL: model.thumbnail?.url)
                self?.view?.render(viewModel: viewModel)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}
