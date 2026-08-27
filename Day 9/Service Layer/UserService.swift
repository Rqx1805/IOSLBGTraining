import Foundation

final class UserService: UserServiceProtocol {
    
    private let networkClient: any NetworkClientProtocol
    
    init(networkClient: any NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchUsers() async throws -> [User] {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await networkClient.request(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let user = try JSONDecoder().decode([User].self, from: data)
            return user
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
