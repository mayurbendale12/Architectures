protocol MarvelLandingPresenterContract {
    func viewLoaded()
    func didTapSearchButton(text: String)
    func didChangeSearchText(text: String)
    func didTapSearchCancelButton()
    func didSelect(at index: Int)
}

class MarvelLandingPresenter: MarvelLandingPresenterContract {
    private weak var view: MarvelLandingViewContract?
    private let getMarvelCharactersUseCase: GetMarvelCharactersUseCaseContract
    private let navigator: MarvelLandingNavigatorContract

    private(set) var marvelModels = [MarvelModel]()
    private(set) var filterdMarvelModels: [MarvelModel] = [] {
        didSet {
            let viewModels = filterdMarvelModels.map { marvel in
                MarvelLandingViewModel(name: marvel.name ?? "",
                                       imageURL: marvel.thumbnail?.url)
            }
            view?.render(viewModels: viewModels)
        }
    }

    init(view: MarvelLandingViewContract,
         getMarvelCharactersUseCase: GetMarvelCharactersUseCaseContract,
         navigator: MarvelLandingNavigatorContract) {
        self.view = view
        self.getMarvelCharactersUseCase = getMarvelCharactersUseCase
        self.navigator = navigator
    }

    func viewLoaded() {
        view?.showSpinner()

        getMarvelCharactersUseCase.execute { [weak self] result in
            self?.view?.hideSpinner()
            switch result {
            case .success(let marvelModels):
                self?.marvelModels = marvelModels
                self?.filterdMarvelModels = marvelModels
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    func didSelect(at index: Int) {
        let marvel = filterdMarvelModels[index]
        navigator.navigateToDetail(id: marvel.id)
    }

    func didTapSearchButton(text: String) {
        fiterMarvelResults(searchText: text)
    }

    func didChangeSearchText(text: String) {
        fiterMarvelResults(searchText: text)
    }

    func didTapSearchCancelButton() {
        filterdMarvelModels = marvelModels
    }

    private func fiterMarvelResults(searchText: String) {
        guard !searchText.isEmpty else {
            filterdMarvelModels = marvelModels
            return
        }

        filterdMarvelModels = marvelModels.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) }
    }
}
