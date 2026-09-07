@MainActor
func testLoadProductsCallsUseCase() async {

    let mockUseCase =
        MockGetProductsUseCase()

    let viewModel =
        ProductViewModel(
            getProductsUseCase:
                mockUseCase
        )

    await viewModel.loadProducts()

    XCTAssertEqual(
        mockUseCase.executeCallCount,
        1
    )
}



@MainActor
func testLoadProductsWithEmptyResponse() async {

    // Arrange
    let mockUseCase =
        MockGetProductsUseCase()

    mockUseCase.productsToReturn = []

    let viewModel =
        ProductViewModel(
            getProductsUseCase:
                mockUseCase
        )

    // Act
    await viewModel.loadProducts()

    // Assert
    XCTAssertTrue(
        viewModel.products.isEmpty
    )

    XCTAssertNil(
        viewModel.errorMessage
    )

    XCTAssertFalse(
        viewModel.isLoading
    )
}



@MainActor
func testLoadProductsFailure() async {

    // Arrange
    let mockUseCase =
        MockGetProductsUseCase()

    mockUseCase.errorToThrow =
        ProductTestError.networkFailure

    let viewModel =
        ProductViewModel(
            getProductsUseCase:
                mockUseCase
        )

    // Act
    await viewModel.loadProducts()

    // Assert
    XCTAssertTrue(
        viewModel.products.isEmpty
    )

    XCTAssertFalse(
        viewModel.isLoading
    )

    XCTAssertEqual(
        viewModel.errorMessage,
        "Unable to load products."
    )
}
