// Dependency Injection (DI) Root of Application

import SwiftUI

@main
struct AppName: App {

private let viewModel: ProductViewModel

init() {

    // 1. Network Client
    let networkClient: any NetworkClientProtocol =
        NetworkClientService()

    // 2. Remote Data Source
    let remoteDataSource: any ProductRemoteDataSource =
        ProductAPISerive(
            networkClient: networkClient
        )

    // 3. Repository
    let repository: any ProductRepository =
        ProductRepoImpl(
            remoteDataSource: remoteDataSource
        )

    // 4. Use Case
    let useCase: any GetProductUseCase =
        GetProdductUseCaseImpl(
            productRepo: repository
        )

    // 5. ViewModel
    self.viewModel = ProductViewModel(
        getProductUseCase: useCase
    )
}

var body: some Scene {

    WindowGroup {
        ProductListView(
            viewModel: viewModel
        )
    }
}
    
}

