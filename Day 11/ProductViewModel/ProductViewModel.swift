import Foundation

@MainActor
final class ProductViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let getProductUseCase: GetProductUseCase
    
    init(getProductUseCase: GetProductUseCase) {
        self.getProductUseCase = getProductUseCase
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        do {
            products = try await getProductUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
}
