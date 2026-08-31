import Foundation

@MainActor
final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private let getProductUseCase: GetProductUseCase
    
    init(getProductUseCase: getProductUseCase) {
        self.getProductUseCase = getProductUseCase
    }
    
    func loadProducts() async {
        products = try await getProductUseCase.excute()
    }
    
}
