import Core

protocol MarvelLandingInteractorContract {
    func fetchMarvelData(completion: @escaping (Result<[MarvelResult], NetworkError>) -> Void)
}

class MarvelLandingInteractor: MarvelLandingInteractorContract {
    private let apiClient: APIProtocol

    init(apiClient: APIProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMarvelData(completion: @escaping (Result<[MarvelResult], NetworkError>) -> Void) {
        apiClient.get(endpoint: .list) { (result: Result<MarvelCharacterModel, NetworkError>) in
            switch result {
            case .success(let model):
                let marvels = model.data?.results ?? []
                completion(.success(marvels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
