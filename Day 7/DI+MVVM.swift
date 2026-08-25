import Foundation

// Now the ViewModel creates everything.

final class UserViewModel {

    private let service = UserService()

    private let analytics =
        AnalyticsService()

    private let database =
        DatabaseService()
}

// Tight coupling
// Difficult testing
// Difficult replacement
// Hard to maintain
// Violates Dependency Inversion



// Now all dependencies are injectable.
final class UserViewModel {

    private let service: any UserServiceProtocol

    private let analytics: any AnalyticsProtocol

    private let database: any UserRepositoryProtocol

    init(
        service: any UserServiceProtocol,
        analytics: any AnalyticsProtocol,
        database: any UserRepositoryProtocol
    ) {

        self.service = service
        self.analytics = analytics
        self.database = database
    }
}

// Concrete dependency

init(service: UserService) // The ViewModel knows the exact implementation.

// Protocol dependency

init(service: any UserServiceProtocol) // The ViewModel knows only the contract.

// Constructor DI

final class UserViewModel {

    private let service: any UserServiceProtocol

    init(service: any UserServiceProtocol) {
        self.service = service
    }
}

// Property injection

final class UserViewModel {

    var service: (any UserServiceProtocol)?
}

let viewModel = UserViewModel()

viewModel.service = service

// Prefer constructor injection when the dependency is required.


┌──────────────────────────┐
│ UserListViewController   │
└────────────┬─────────────┘
             │
             │ Constructor DI
             ▼
┌──────────────────────────┐
│ UserListViewModel        │
│                          │
│ Depends on:              │
│ UserServiceProtocol      │
└────────────┬─────────────┘
             │
             │ Protocol
             ▼
┌──────────────────────────┐
│ UserServiceProtocol      │
└────────────┬─────────────┘
             │
       ┌─────┴──────┐
       ▼            ▼
┌────────────┐ ┌─────────────┐
│ UserService│ │ MockService │
│ Production │ │ Unit Test   │
└────────────┘ └─────────────┘
