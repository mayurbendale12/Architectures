import Core

protocol MarvelLandingPresenterContract {
    func viewLoaded()
    func didTapSearchBUtton(text: String)
    func didChangeSearchText(text: String)
    func didTapSearchCancelButton()
    func didSelect(at index: Int)
}

class MarvelLandingPresenter: MarvelLandingPresenterContract {
    private weak var view: MarvelLandingViewContract?
    private let interactor: MarvelLandingInteractorContract
    private let router: MarvelLandingRouterContract

    private(set) var marvels = [MarvelResult]()
    private(set) var filterdMarvels: [MarvelResult] = [] {
        didSet {
            let viewModels = filterdMarvels.map { marvel in
                MarvelLandingViewModel(name: marvel.name ?? "",
                                       imageURL: marvel.thumbnail?.url)
            }
            view?.render(viewModels: viewModels)
        }
    }

    init(view: MarvelLandingViewContract?,
         interactor: MarvelLandingInteractorContract,
         router: MarvelLandingRouterContract) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewLoaded() {
        view?.showSpinner()
        interactor.fetchMarvelData { [weak self] result in
            switch result {
            case .success(let marvels):
                self?.marvels = marvels
                self?.filterdMarvels = marvels
                self?.view?.hideSpinner()
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    func didTapSearchBUtton(text: String) {
        fiterMarvelResults(searchText: text)
    }

    func didChangeSearchText(text: String) {
        fiterMarvelResults(searchText: text)
    }

    func didTapSearchCancelButton() {
        filterdMarvels = marvels
    }

    func didSelect(at index: Int) {
        let marvel = filterdMarvels[index]
        router.navigateToDetail(id: marvel.id)
    }

    private func fiterMarvelResults(searchText: String) {
        guard !searchText.isEmpty else {
            filterdMarvels = marvels
            return
        }

        filterdMarvels = marvels.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) }
    }
}
