import Foundation

protocol APIProtocol {
    func get<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class APIClient: APIProtocol {
    static let shared = APIClient()
    private init() {}

    func get<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = endpoint.urlRequest else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.serverError))
                }
                guard let data = data,
                      let model = try? JSONDecoder().decode(T.self, from: data) else {
                    return completion(.failure(.invalidResponse))
                }

                completion(.success(model))
            }
        }
        task.resume()
    }
}
