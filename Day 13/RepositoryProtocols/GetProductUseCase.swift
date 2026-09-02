// Domain Layer - Use Case:

import Foundation

protocol GetProductUseCase {
    func execute() async throws -> [Product]
}

// Domain Layer - Repository Protocol Use Case:

final class GetProdductUseCaseImpl: GetProductUseCase {
    
    private let productRepo: ProductRepository
    
    init(productRepo: ProductRepository) {
        self.productRepo = productRepo
    }
    
    func execute() async throws -> [Product] {
        let products =
        try await productRepo.getProducts()
        
        // Business rule example:
        // Don't show products with invalid prices.
        
        return products.filter {
            $0.price >= 0
        }
    }
    
}
