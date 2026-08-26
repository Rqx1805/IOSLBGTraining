import Foundation

final class UserService: UserServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchUser() async throws -> [User] {
        guard let url = URL(String: "") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200.299 ~= response.statusCode else {
            throw APIError.serverError(response.statusCode)
        }
        
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
}
