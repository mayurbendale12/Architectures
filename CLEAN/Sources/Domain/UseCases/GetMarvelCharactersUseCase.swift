import Core

protocol GetMarvelCharactersUseCaseContract {
    func execute(completion: @escaping (Result<[MarvelModel], NetworkError>) -> Void)
}

class GetMarvelCharactersUseCase: GetMarvelCharactersUseCaseContract {
    private let marvelCharactersRepository: MarvelCharactersRepositoryContract

    init(marvelCharactersRepository: MarvelCharactersRepositoryContract) {
        self.marvelCharactersRepository = marvelCharactersRepository
    }

    func execute(completion: @escaping (Result<[MarvelModel], NetworkError>) -> Void) {
        marvelCharactersRepository.getCharacters(completion: completion)
    }
}

