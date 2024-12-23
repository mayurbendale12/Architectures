import Foundation

struct MarvelCharacterEntity: Codable {
    let data: MarvelCharacterData?
}

struct MarvelCharacterData: Codable {
    let results: [MarvelResultEntity]?
}

struct MarvelResultEntity: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: MarvelThumbnailEntity?
}

struct MarvelThumbnailEntity: Codable {
    let path: String?
    let imageExtension: String?

    var url: URL? {
        let path = path ?? ""
        let imageExtension = imageExtension ?? ""
        let urlString = String(format: "%@.%@", path, imageExtension)
        return URL(string: urlString)
    }

    private enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}
