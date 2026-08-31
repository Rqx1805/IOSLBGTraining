import Foundation

final class UserService: UserServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUser() async throws -> [User] {
        guard let url = URL(String: "") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299) contains(response.statusCode) else {
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
        
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
}
