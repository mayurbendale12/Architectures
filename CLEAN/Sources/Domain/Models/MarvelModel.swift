import Foundation

struct MarvelModel: Equatable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: MarvelThumbnailModel?
}

struct MarvelThumbnailModel: Equatable {
    let path: String?
    let imageExtension: String?

    var url: URL? {
        let path = path ?? ""
        let imageExtension = imageExtension ?? ""
        let urlString = String(format: "%@.%@", path, imageExtension)
        return URL(string: urlString)
    }
}
