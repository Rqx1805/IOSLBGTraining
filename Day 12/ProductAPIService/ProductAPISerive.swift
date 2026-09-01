import Foundation

final class ProductAPISerive: ProductRemoteDataSource {
    
    private let networkClient: any NetworkClientProtocol
    
      init(networkClient: any NetworkClientProtocol) {
        self.networkClient = networkClient
      }

    func getProducts() async throws -> [ProductDTO] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw errorResponse.invalidURL
        }
        return try await networkClient.request(endpoint: url)
    }
}
