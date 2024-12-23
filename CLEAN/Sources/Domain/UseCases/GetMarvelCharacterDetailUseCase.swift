protocol GetMarvelCharacterDetailUseCaseContract {
    func execute(id: Int, completion: @escaping (Result<MarvelModel, NetworkError>) -> Void)
}

class GetMarvelCharacterDetailUseCase: GetMarvelCharacterDetailUseCaseContract {
    private let marvelCharacterDetailRepository: MarvelCharacterDetailRepositoryContract

    init(marvelCharacterDetailRepository: MarvelCharacterDetailRepositoryContract) {
        self.marvelCharacterDetailRepository = marvelCharacterDetailRepository
    }
    
    func execute(id: Int, completion: @escaping (Result<MarvelModel, NetworkError>) -> Void) {
        marvelCharacterDetailRepository.getCharacter(id: id, completion: completion)
    }
}

