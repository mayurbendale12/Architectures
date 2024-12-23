protocol MarvelDetailInteractorContract {
    func fetchMarvelData(id: Int, completion: @escaping (Result<MarvelResult, NetworkError>) -> Void)
}

class MarvelDetailInteractor: MarvelDetailInteractorContract {
    private let apiClient: APIProtocol

    init(apiClient: APIProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchMarvelData(id: Int, completion: @escaping (Result<MarvelResult, NetworkError>) -> Void) {
        apiClient.get(endpoint: .detail(id: id)) { (result: Result<MarvelCharacterModel, NetworkError>) in
            switch result {
            case .success(let model):
                guard let marvelResult = model.data?.results?.first else { return }
                completion(.success(marvelResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
