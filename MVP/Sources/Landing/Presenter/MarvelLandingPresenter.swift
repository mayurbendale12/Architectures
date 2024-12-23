protocol MarvelLandingPresenterContract {
    func viewLoaded()
    func didTapSearchBUtton(text: String)
    func didChangeSearchText(text: String)
    func didTapSearchCancelButton()
    func didSelect(at index: Int)
}

class MarvelLandingPresenter: MarvelLandingPresenterContract {
    private let apiClient: APIProtocol
    private weak var view: MarvelLandingViewContract?
    private let navigator: MarvelLandingNavigatorContract

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

    init(apiClient: APIProtocol, view: MarvelLandingViewContract, navigator: MarvelLandingNavigatorContract) {
        self.apiClient = apiClient
        self.view = view
        self.navigator = navigator
    }

    func viewLoaded() {
        view?.showSpinner()

        apiClient.get(endpoint: .list) { [weak self] (result: Result<MarvelCharacterModel, NetworkError>) in
            guard let self else { return }
            self.view?.hideSpinner()
            switch result {
            case .success(let model):
                self.marvels = model.data?.results ?? []
                self.filterdMarvels = self.marvels
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    func didSelect(at index: Int) {
        let marvel = filterdMarvels[index]
        navigator.navigateToDetail(id: marvel.id)
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

    private func fiterMarvelResults(searchText: String) {
        guard !searchText.isEmpty else {
            filterdMarvels = marvels
            return
        }

        filterdMarvels = marvels.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) }
    }
}
