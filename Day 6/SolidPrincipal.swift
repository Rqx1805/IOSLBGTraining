//S → Single Responsibility Principle
//O → Open/Closed Principle
//L → Liskov Substitution Principle
//I → Interface Segregation Principle
//D → Dependency Inversion Principle


// 1. Single Responsibility Principle

class UserViewController: UIViewController {

    // UI
    // API
    // JSON parsing
    // Business logic
    // Validation
    // Database
    // Navigation
}

// 2. Open/Closed Principle

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}

final class UserService: UserServiceProtocol {

    func fetchUsers() async throws -> [User] {
        // Real API
    }
}

// 3. Liskov Substitution Principle

let productionViewModel = UserListViewModel(
    service: UserService()
)

// 4. Interface Segregation Principle

// A class that only needs users is forced to depend on unrelated methods.
protocol UserServiceProtocol {

    func fetchUsers()

    func createUser()

}

// Now components depend only on what they need.
protocol UserFetching {

    func fetchUsers() async throws -> [User]
}

protocol UserCreating {

    func createUser(
        name: String,
        email: String
    ) async throws
}

// 5. Dependency Inversion Principle

final class UserListViewModel {

    private let service: any UserServiceProtocol

    init(service: any UserServiceProtocol) {
        self.service = service
    }
}

┌───────────────────┐
│ UserService       │
│ Real API          │
└─────────┬─────────┘
          │
          ↓
   UserServiceProtocol
          ↑
          │
┌─────────┴─────────┐
│                   │
UserListViewModel    MockUserService
