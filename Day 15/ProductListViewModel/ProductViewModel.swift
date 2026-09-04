import Foundation

@MainActor
final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private let getProductUseCase: GetProductUseCase
    
    init(getProductUseCase: GetProductUseCase) {
        self.getProductUseCase = getProductUseCase
    }
    
    func loadProducts() async {
        Task {
            do {
                products = try await getProductUseCase.execute()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
