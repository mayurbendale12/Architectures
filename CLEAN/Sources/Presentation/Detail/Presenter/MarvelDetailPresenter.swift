protocol MarvelDetailPresenterContract {
    func viewLoaded()
}

class MarvelDetailPresenter: MarvelDetailPresenterContract {
    private let getCharacterDetailUseCase: GetMarvelCharacterDetailUseCase
    private weak var view: MarvelDetailViewContract?
    private let id: Int?

    init(view: MarvelDetailViewContract,
         getCharacterDetailUseCase: GetMarvelCharacterDetailUseCase,
         id: Int?) {
        self.view = view
        self.getCharacterDetailUseCase = getCharacterDetailUseCase
        self.id = id
    }

    func viewLoaded() {
        guard let id else {
            return
        }

        view?.showSpinner()
        getCharacterDetailUseCase.execute(id: id) { [weak self] result in
            self?.view?.hideSpinner()
            switch result {
            case .success(let marvelModel):
                self?.handleMarvelCharacterDetailResponse(model: marvelModel)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    private func handleMarvelCharacterDetailResponse(model: MarvelModel) {
        let viewModel = MarvelDetailViewModel(name: model.name ?? "",
                                              description: model.description,
                                              imageURL: model.thumbnail?.url)
        view?.render(viewModel: viewModel)
    }
}
