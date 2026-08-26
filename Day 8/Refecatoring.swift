// Step 1 — Find responsibilities

// If yes → separate it.

// Step 2 — Find concrete dependencies

let service = UserService()

// inside ViewModels.

// Move object creation outside.

// Step 3 — Create protocols

protocol UserServiceProtocol {
    // ...
}

// Step 4 — Inject dependencies

init(service: any UserServiceProtocol)

// Step 5 — Make dependencies immutable

private let service:
    any UserServiceProtocol

// Step 6 — Create mocks

final class MockUserService:
    UserServiceProtocol {
    // ...
}

// Step 7 — Unit test

// Test the ViewModel independently.
