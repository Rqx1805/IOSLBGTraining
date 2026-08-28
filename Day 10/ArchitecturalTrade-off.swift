// Architectural Trade-off

// Choosing one benefit while accepting some cost or limitation.

// Protocol + Dependency Injection

Benefits:
✓ Testable
✓ Loosely coupled
✓ Easy to replace implementation



//Costs:
//✗ More files
//✗ More abstractions
//✗ More code
//✗ Potential over-engineering for a tiny feature

                                    
Requirement
    ↓
Architecture decision
    ↓
Benefits
    ↓
Trade-offs
    ↓
Why this decision is appropriate

//UIKit
//MVVM
//Protocol-based Dependency Injection
//Constructor Injection
//URLSession
//async/await
//SOLID
//XCTest
                                    
                    
┌──────────────────────────────┐
│ UserListViewController       │
│                              │
│ UIKit / UITableView          │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ UserListViewModel            │
│                              │
│ State / Business Logic       │
└──────────────┬───────────────┘
               │
               ▼
      UserServiceProtocol
               │
        ┌──────┴───────┐
        ▼              ▼
   UserService     MockUserService
        │
        ▼
 NetworkClientProtocol
        │
        ▼
    URLSession


Architecture Decision:

Use UIKit + MVVM with protocol-based
constructor dependency injection.

Reason:

The feature contains UI state, networking,
business logic, and requires unit testing.

The ViewController remains responsible for
UI rendering.

The ViewModel owns screen state and presentation
logic.

The service layer handles data retrieval.

Protocols are used at the service/network
boundaries to support mocking and replacement.

Constructor injection makes dependencies explicit,
immutable, and testable.
    
// Trade-off #1 — MVVM vs MVC

// MVC: -

ViewController
   │
   ├── UI
   ├── State
   ├── Business logic
   └── Networking

// MVVM: -

ViewController
      │
      ▼
ViewModel
      │
      ▼
Service

// Trade-off #2 — Protocol vs Concrete Type

// Concrete dependency -

private let service: UserService

// Protocol -

private let service: any UserServiceProtocol

// Trade-off #3 — Constructor DI vs Singleton

// Singleton: -

final class NetworkManager {
    static let shared = NetworkManager()
}

// Usage:

NetworkManager.shared.request()

// Constructor DI -

init(networkClient: any NetworkClientProtocol)

// Trade-off #4 — Repository Layer

ViewModel
 ↓
UseCase
 ↓
Repository
 ↓
Service
 ↓
Network

Simple feature
→ Keep architecture simple

Complex business rules
→ Use UseCase

Multiple data sources
→ Use Repository

Large application
→ Stronger boundaries


// Trade-off #5 — async/await vs Completion Handlers

// Completion -

service.fetchUsers { result in

    switch result {

    case .success(let users):
        // Handle users

    case .failure(let error):
        // Handle error
    }
}

// async/await -

do {

    let users =
        try await service.fetchUsers()

} catch {

    // Handle error
}
