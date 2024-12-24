import Core

protocol MarvelCharactersRepositoryContract {
    func getCharacters(completion: @escaping (Result<[MarvelModel], NetworkError>) -> Void)
}

class MarvelCharactersRepository: MarvelCharactersRepositoryContract {
    private let apiClient: APIProtocol

    init(apiClient: APIProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getCharacters(completion: @escaping (Result<[MarvelModel], NetworkError>) -> Void) {
        apiClient.get(endpoint: .list) { [weak self] (result: Result<MarvelCharacterEntity, NetworkError>) in
            guard let self else { return }
            Spinner.stop()
            switch result {
            case .success(let entity):
                let marvelResults = entity.data?.results ?? []
                let marvelModels = marvelResults.map { marvelResult in
                    let thumbnail = MarvelThumbnailModel(path: marvelResult.thumbnail?.path,
                                                         imageExtension: marvelResult.thumbnail?.imageExtension)
                    return MarvelModel(id: marvelResult.id,
                                       name: marvelResult.name,
                                       description: marvelResult.description,
                                       thumbnail: thumbnail)
                }
                completion(.success(marvelModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
