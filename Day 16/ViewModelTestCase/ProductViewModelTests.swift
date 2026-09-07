import XCTest

@MainActor
final class ProductViewModelTests:
    XCTestCase {

    func testLoadProductsSuccess() async {

        // Arrange
        let mockUseCase =
            MockGetProductsUseCase()

        mockUseCase.productsToReturn = [

            Product(
                id: 1,
                title: "iPhone",
                price: 79999
            ),

            Product(
                id: 2,
                title: "MacBook",
                price: 149999
            )
        ]

        let viewModel =
            ProductViewModel(
                getProductsUseCase:
                    mockUseCase
            )

        // Act
        await viewModel.loadProducts()

        // Assert
        XCTAssertEqual(
            viewModel.products.count,
            2
        )

        XCTAssertEqual(
            viewModel.products[0].title,
            "iPhone"
        )

        XCTAssertFalse(
            viewModel.isLoading
        )

        XCTAssertNil(
            viewModel.errorMessage
        )
    }
}
