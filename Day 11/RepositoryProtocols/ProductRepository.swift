// Domain Layer - Repository Protocol:

import Foundation

protocol ProductRepository {
    func fetchProducts() async throws -> [Product]
}

// Data Layer -

final class ProductRepoImpl: ProductRepository {
    private let remoteDataSource: ProductRemoteDataSource
    
    init(remoteDataSource: ProductRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchProducts() async throws -> [Product] {
        let product = try await remoteDataSource.getProducts()
        return product
    }

}

protocol ProductRemoteDataSource {
    func getProducts() async throws -> [ProductDTO]
}
