import Foundation

final class UserService: UserServiceProtocol {

    private let networkClient: any NetworkServiceProtocol

    init(networkClient: any NetworkServiceProtocol) {
        self.networkClient = networkClient
    }

    func fetchUsers() async throws -> [User] {

        // Endpoint selection belongs to UserService.

        guard let url = URL(
            string: "https://jsonplaceholder.typicode.com/users"
        ) else {
            throw NetworkError.invalidURL
        }

        // NetworkClient handles:
        //
        // URLSession
        // HTTP validation
        // Status code
        // Error mapping
        // JSON decoding

        return try await networkClient.request(
            endpoint: url
        )
    }
}
