//  APIService.swift

import Foundation

final class APIService: APIServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchUser() async throws -> [User] {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw APIError.invalidURL
        }
        
        return try await networkService.request(endPointUrl: url)
    }
}
