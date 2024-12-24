import Core

protocol MarvelCharacterDetailRepositoryContract {
    func getCharacter(id: Int, completion: @escaping (Result<MarvelModel, NetworkError>) -> Void)
}

class MarvelCharacterDetailRepository: MarvelCharacterDetailRepositoryContract {
    private let apiClient: APIProtocol

    init(apiClient: APIProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getCharacter(id: Int, completion: @escaping (Result<MarvelModel, NetworkError>) -> Void) {
        apiClient.get(endpoint: .detail(id: id)) { (result: Result<MarvelCharacterEntity, NetworkError>) in
            switch result {
            case .success(let entity):
                guard let marvelResult = entity.data?.results?.first else {
                    return completion(.failure(.invalidResponse))
                }
                let thumbnail = MarvelThumbnailModel(path: marvelResult.thumbnail?.path,
                                                     imageExtension: marvelResult.thumbnail?.imageExtension)
                let marvelModel = MarvelModel(id: marvelResult.id,
                                              name: marvelResult.name,
                                              description: marvelResult.description,
                                              thumbnail: thumbnail)
                completion(.success(marvelModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
