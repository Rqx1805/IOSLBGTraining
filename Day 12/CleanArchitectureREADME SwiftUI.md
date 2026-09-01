# 1. Clean Architecture in SwiftUI

                PRODUCT FEATURE

┌────────────────────────────────────────────┐
│              PRESENTATION                  │
│                                            │
│  ProductListView                           │
│          ↓                                 │
│  ProductListViewModel                      │
└──────────────────┬─────────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────────┐
│                  DOMAIN                    │
│                                            │
│  Product Entity                            │
│  GetProductsUseCase                        │
│  ProductRepository Protocol                │
└──────────────────┬─────────────────────────┘
                   │
                   ▲
                   │ implements
┌──────────────────┴─────────────────────────┐
│                   DATA                     │
│                                            │
│  ProductRepositoryImpl                     │
│  ProductDTO                                │
│  NetworkClient                             │
│  URLSession                                │
└────────────────────────────────────────────┘

2. Project Structure

ProductFeature
│
├── Domain
│   ├── Entities
│   │   └── Product.swift
│   │
│   ├── Repositories
│   │   └── ProductRepository.swift
│   │
│   └── UseCases
│       └── GetProductsUseCase.swift
│
├── Data
│   ├── DTO
│   │   └── ProductDTO.swift
│   │
│   ├── Network
│   │   └── NetworkClient.swift
│   │
│   └── Repositories
│       └── ProductRepositoryImpl.swift
│
├── Presentation
│   ├── ProductListView.swift
│   └── ProductListViewModel.swift
│
└── App
    └── DependencyContainer.swift
    
3. DOMAIN Layer

It contains:--

Entity
Use Case
Repository Protocol
Business Rules

It should not contain: --

❌ SwiftUI
❌ UIKit
❌ URLSession
❌ JSONDecoder
❌ Firebase
❌ Core Data
❌ API-specific implementation

4. Domain Entity --

struct Product {

    let id: Int
    let title: String
    let price: Double
}

5. Repository Protocol --

protocol ProductRepository {

    func getProducts() async throws -> [Product]
}

6. Use Case --

protocol GetProductsUseCase {

    func execute() async throws -> [Product]
}

Implementation: --

final class DefaultGetProductsUseCase:
    GetProductsUseCase {

    private let repository: ProductRepository

    init(
        repository: ProductRepository
    ) {
        self.repository = repository
    }

    func execute() async throws -> [Product] {

        let products =
            try await repository.getProducts()

        // Business rule example:
        // Don't show products with invalid prices.

        return products.filter {
            $0.price >= 0
        }
    }
}

8. DATA Layer --

It's contain:-

✓ URLSession
✓ JSONDecoder
✓ API
✓ DTO
✓ Database
✓ Cache
✓ Repository implementation


9. Complete Use Case Flow --

Step 1 — SwiftUI 

.task {
    await viewModel.loadProducts()
}


Step 2 — ViewModel
func loadProducts() async

↓

Step 3 — Use Case
try await getProductUseCase.execute()

↓

Step 4 — Repository
try await repository.getProducts()

↓

Step 5 — Network
try await networkClient.request(
    from: url
)

↓

Step 6 — API
GET /products

↓

Step 7 — DTO
JSON
 ↓
ProductDTO

↓

Step 8 — Domain Model
ProductDTO
 ↓
Product

↓

Step 9 — Use Case

Business rules are applied.

↓

Step 10 — ViewModel
products = result

↓

Step 11 — SwiftUI

SwiftUI observes the state change and redraws the UI.

10. Complete Data Flow Diagram --

USER OPENS SCREEN
       │
       ▼
ProductListView
       │
       │ .task
       ▼
ProductListViewModel
       │
       │ loadProducts()
       ▼
GetProductsUseCase
       │
       │ execute()
       ▼
ProductRepository
       │
       ▼
ProductRepositoryImpl
       │
       │ getProducts()
       ▼
NetworkClient
       │
       ▼
URLSession
       │
       ▼
REST API
       │
       │ JSON
       ▼
ProductDTO
       │
       │ Mapping
       ▼
Product
       │
       ▼
UseCase
       │
       ▼
ViewModel
       │
       ▼
SwiftUI View


11. The dependency graph is: --

URLSessionNetworkClient
          ↓
ProductRepositoryImpl
          ↓
DefaultGetProductsUseCase
          ↓
ProductListViewModel
          ↓
ProductListView


12. Final Real Code Architecture: -

                         PRESENTATION
                  ┌─────────────────────┐
                  │ ProductListView     │
                  │         ↓           │
                  │ ProductListViewModel│
                  └──────────┬──────────┘
                             │
                             ▼
                         DOMAIN
                  ┌─────────────────────┐
                  │ Product             │
                  │                     │
                  │ GetProductsUseCase  │
                  │         ↓           │
                  │ ProductRepository   │
                  │    <<protocol>>     │
                  └──────────▲──────────┘
                             │
                             │ implements
                             │
                           DATA
                  ┌─────────────────────┐
                  │ ProductDTO          │
                  │                     │
                  │ ProductRepository   │
                  │      Impl           │
                  │         ↓           │
                  │ NetworkClient       │
                  │         ↓           │
                  │ URLSession          │
                  └─────────────────────┘
