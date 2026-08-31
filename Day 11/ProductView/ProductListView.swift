import SwiftUI

struct ProductListView: View {
    @StateObject var productViewModel: ProductViewModel
    
    var body: some View {
        List(productViewModel.products) { product in
            Text(product.name)
            Text(product.price)
        }
        .task {
            await productViewModel.loadProducts()
        }
    }
}
