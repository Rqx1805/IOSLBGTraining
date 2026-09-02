import Foundation

final class NetworkClientService: NetworkClientProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    
    func request<T: Decodable>(endPointUrl: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: endPointUrl)
            
            // MARK: Validate Response
            
            guard let response = response as? HTTPURLResponse else {
                throw errorResponse.invalidResponse
            }
            
            guard (200.299).contains(response.statusCode) else {
                throw errorResponse.invalidStatusCode(response.statusCode)
            }
            
            return try decode.decode(T.self, from: data)
        } catch {
            throw throw errorResponse.decodingError(error)
        }
    }
}

