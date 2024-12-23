import Combine
import Foundation

struct MarvelDetailModel {
    let name: String
    let description: String?
    let imageURL: URL?
}

enum MarvelDetailState {
    case initial
    case loading
    case render(MarvelDetailModel)
}

class MarvelDetailViewModel: ObservableObject {
    @Published var state: MarvelDetailState = .initial
    private let apiClient: APIProtocol
    private let id: Int?

    init(apiClient: APIProtocol, id: Int?) {
        self.apiClient = apiClient
        self.id = id
    }

    func viewLoaded() {
        guard let id else {
            return
        }

        state = .loading
        apiClient.get(endpoint: .detail(id: id)) { [weak self] (result: Result<MarvelCharacterModel, NetworkError>) in
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

        let marvelDetailModel = MarvelDetailModel(name: marvelResult.name ?? "",
                                                  description: marvelResult.description,
                                                  imageURL: marvelResult.thumbnail?.url)
        state = .render(marvelDetailModel)
    }
}
