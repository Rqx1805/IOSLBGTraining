// Domain Layer - Repository Protocol:

import Foundation

protocol ProductRepository {
    func fetchProducts() async throws -> [Product]
}

// Data Layer -

final class ProductRepoImpl: ProductRepository {
    let remoteDataSource: ProductRemoteDataSource
    
    init(remoteDataSource: ProductRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchProducts() async throws -> [Product] {
        let product = try await remoteDataSource.getProducts()
        
        return product.map {
            product(id: $0.id, name: $0.name, price: $0.price)
        }
    }

}

protocol ProductRemoteDataSource {
    func getProducts() async throws -> [ProductDTO]
}
