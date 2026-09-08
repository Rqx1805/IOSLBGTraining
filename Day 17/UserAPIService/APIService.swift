//  APIService.swift

import Foundation

final class APIService: APIServiceProtocol {

    func fetchUser() async throws -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(response.statusCode) else {
            throw APIError.invalidStatusCode(response.statusCode)
        }

        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw APIError.dcodingError(error)
        }
    }
}
