// Domain Layer - Use Case:

import Foundation

protocol GetProductUseCase {
    func execute() async throws -> [Product]
}

// Domain Layer - Repository Protocol Use Case:

final class GetProdductUseCaseImpl: GetProductUseCase {
    
    let productRepo: ProductRepository
    
    init(productRepo: ProductRepository) {
        self.productRepo = productRepo
    }
    
    func execute() async throws -> [Product] {
        try await productRepo.fetchProduct()
    }
    
}
