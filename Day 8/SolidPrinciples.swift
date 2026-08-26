// SOLID #1 — Single Responsibility Principle

// Our responsibilities are now separated.

// UserService -

// a. Networking
// b. API request
// c. Response validation
// d. JSON decoding


// UserListViewModel -

// a. Screen state
// b. Business logic
// c. Error state

// UserListViewController -

// a.UIKit
// b. UITableView
// c. Displaying state
// d. User interaction

// User model -

// A. Data representation

// ViewModel -

import Foundation

@MainActor
final class UserListViewModel {

    private let service: any UserServiceProtocol

    private(set) var users: [User] = []

    private(set) var isLoading = false

    private(set) var errorMessage: String?

    init(
        service: any UserServiceProtocol
    ) {
        self.service = service
    }

    func loadUsers() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            users = try await service.fetchUsers()

        } catch let error as NetworkError {

            handle(error)

        } catch {

            errorMessage =
                "Something went wrong."
        }
    }

    private func handle(
        _ error: NetworkError
    ) {

        switch error {

        case .invalidURL:
            errorMessage = "Invalid URL."

        case .invalidResponse:
            errorMessage = "Invalid server response."

        case .serverError(let statusCode):
            errorMessage =
                "Server error: \(statusCode)"

        case .decodingFailed:
            errorMessage =
                "Unable to process server data."
        }
    }
}

// SOLID #2 — Open/Closed Principle

final class CachedUserService:
    UserServiceProtocol {

    private let users: [User]

    init(users: [User]) {
        self.users = users
    }

    func fetchUsers() async throws -> [User] {
        return users
    }
}

// We didn't modify

UserListViewModel

// It already works with:

UserServiceProtocol

// We can inject:

let service =
    CachedUserService(
        users: cachedUsers
    )

let viewModel =
    UserListViewModel(
        service: service
    )

// That's Open/Closed Principle.

// SOLID #3 — Liskov Substitution Principle

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}

let productionViewModel =
    UserListViewModel(
        service: UserService()
    )

// The ViewModel doesn't need to know which implementation it received.

// That's the practical use of LSP.

// SOLID #4 — Interface Segregation Principle


// Multiple Function Protocol
protocol ApplicationServiceProtocol {

    func fetchUsers() async throws -> [User]

    func login() async throws

    func sendAnalytics()

}

// Convert into small protocols:

// User Service:

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}

// Authentication:

protocol AuthServiceProtocol {

    func login(
        email: String,
        password: String
    ) async throws
}

// Analytics:

protocol AnalyticsProtocol {

    func sendAnalytics(
        event: String
    )
}

// Example LoginViewModel -

@MainActor
final class LoginViewModel {

    private let authService:
        any AuthServiceProtocol

    init(
        authService:
            any AuthServiceProtocol
    ) {
        self.authService = authService
    }

    func login(
        email: String,
        password: String
    ) async {

        do {

            try await authService.login(
                email: email,
                password: password
            )

        } catch {

            // Handle error
        }
    }
}

// SOLID #5 — Dependency Inversion Principle - This is especially important in MVVM.

// The ViewModel directly depends on: UserService

final class UserListViewModel {

    private let service:
        any UserServiceProtocol

    init(
        service:
            any UserServiceProtocol
    ) {
        self.service = service
    }
}

ViewModel
    ↓
UserServiceProtocol
    ↑
    │
UserService
