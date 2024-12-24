import Core
import Foundation

enum LandingViewState {
    case initial
    case loading
    case render([LandingMarvelCharacterModel])
}

struct LandingMarvelCharacterModel {
    let name: String
    let imageUrl: URL?
}

protocol MarvelLandingViewModelContract {
    var state: Observable<LandingViewState> { get set }

    func viewLoaded()
    func didTapSearchButton(text: String)
    func didChangeSearchText(text: String)
    func didTapSearchCancelButton()
    func didSelect(at index: Int)
}

class MarvelLandingViewModel: MarvelLandingViewModelContract {
    var state: Observable<LandingViewState> = Observable(.initial)

    private let apiClient: APIProtocol
    private let navigator: MarvelLandingNavigatorContract
    private var marvels = [MarvelResult]()
    private(set) var filterdMarvels: [MarvelResult] = [] {
        didSet {
            let marvelCharacters = filterdMarvels.map { marvelCharacter in
                LandingMarvelCharacterModel(name: marvelCharacter.name ?? "",
                                            imageUrl: marvelCharacter.thumbnail?.url)
            }
            state.value = .render(marvelCharacters)
        }
    }

    init(apiClient: APIProtocol, navigator: MarvelLandingNavigatorContract) {
        self.apiClient = apiClient
        self.navigator = navigator
    }

    func viewLoaded() {
        state.value = .loading

        apiClient.get(endpoint: .list) { [weak self] (result: Result<MarvelCharacterModel, NetworkError>) in
            guard let self else { return }
            Spinner.stop()
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

    func didTapSearchButton(text: String) {
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
