import Foundation

public struct Constants {
    public struct API {
        static let BASE_URL = "gateway.marvel.com"
        static let PUBLIC_KEY = "484c30c951cae51d6f05b93d96d7fb24"
        static let PRIVATE_KEY = "3a063346b9b24fb1d0e3ba8dc1ecc0aeeabbc10f"
        static let characters = "/v1/public/characters"
        static let characterDetails = "/v1/public/characters/%d"
        static let kContentType = "content-Type"
        static let kApplicationJson = "application/json"
        static let httpsScheme = "https"
        static let apiKey = "apikey"
        static let ts = "ts"
        static let hash = "hash"
        static let httpMethodGET = "GET"
    }
}
