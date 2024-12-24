import Foundation

public enum Endpoint {
    case list
    case detail(id: Int)

    public var path: String {
        switch self {
        case .list:
            return Constants.API.characters
        case .detail(let id):
            return String(format: Constants.API.characterDetails, id)
        }
    }

    public var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.setValue(Constants.API.kApplicationJson, forHTTPHeaderField: Constants.API.kContentType)
        return urlRequest
    }

    public var url: URL? {
        var component = URLComponents()
        component.scheme = Constants.API.httpsScheme
        component.host = Constants.API.BASE_URL
        component.path = path
        component.queryItems = [
            URLQueryItem(name: Constants.API.apiKey, value: Constants.API.PUBLIC_KEY),
            URLQueryItem(name: Constants.API.ts, value: Utility.timestamp),
            URLQueryItem(name: Constants.API.hash, value: Utility.hash)
        ]
        return component.url
    }

    public var httpMethod: String {
        return Constants.API.httpMethodGET
    }
}
