import Foundation

final class ProductAPIService: ProductRemoteDataSource {
    
    let networkClientProtocol: NetworkClientProtocol
    
    init(networkClientProtocol: NetworkClientProtocol) {
        self.networkClientProtocol = networkClientProtocol
    }
    
    func getProducts() async throws -> [ProductDTO] {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }
        
        return try await networkClientProtocol.request(endPointUrl: url)
       
    }
}
