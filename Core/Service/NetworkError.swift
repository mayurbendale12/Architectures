import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case serverError

    public var errorDescription: String {
        switch self {
        case .invalidResponse:
            return "marvel_API_invalid_response".localize()
        case .serverError:
            return "marvel_API_server_error".localize()
        }
    }
}
