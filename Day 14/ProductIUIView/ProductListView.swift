import SwiftUI

struct ProductListView: View {

@StateObject private var viewModel: ProductViewModel

init(viewModel: ProductViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
}

var body: some View {

    NavigationStack {

        List(viewModel.products) { product in

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(product.name)
                    .font(.headline)

                .font(.subheadline)
            }
        }
        .navigationTitle("Products")
    }
    .task {
        await viewModel.loadProducts()
    }
}

}
