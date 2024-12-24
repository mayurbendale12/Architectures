import Core
protocol MarvelDetailPresenterContract {
    func viewLoaded()
}

class MarvelDetailPresenter: MarvelDetailPresenterContract {
    private let apiClient: APIProtocol
    private weak var view: MarvelDetailViewContract?
    private let id: Int?

    init(apiClient: APIProtocol, view: MarvelDetailViewContract, id: Int?) {
        self.apiClient = apiClient
        self.view = view
        self.id = id
    }

    func viewLoaded() {
        guard let id else {
            return
        }

        view?.showSpinner()
        apiClient.get(endpoint: .detail(id: id)) { [weak self] (result: Result<MarvelCharacterModel, NetworkError>) in
            self?.view?.hideSpinner()
            switch result {
            case .success(let model):
                self?.handleMarvelCharacterDetailResponse(model: model)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    private func handleMarvelCharacterDetailResponse(model: MarvelCharacterModel) {
        guard let marvelResult = model.data?.results?.first else { return }

        let viewModel = MarvelDetailViewModel(name: marvelResult.name ?? "",
                                              description: marvelResult.description,
                                              imageURL: marvelResult.thumbnail?.url)
        view?.render(viewModel: viewModel)
    }
}
