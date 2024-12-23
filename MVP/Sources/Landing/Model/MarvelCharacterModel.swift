import Foundation

struct MarvelCharacterModel: Codable {
    let data: MarvelCharacterData?
}

struct MarvelCharacterData: Codable {
    let results: [MarvelResult]?
}

struct MarvelResult: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: MarvelThumbnail?
}

struct MarvelThumbnail: Codable {
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
