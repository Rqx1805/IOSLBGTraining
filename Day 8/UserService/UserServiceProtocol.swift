import Foundation

// Protocol-Based Dependency

protocol UserServiceProtocol {
    func fetchUser() async throws -> [User]
}

// This is the dependency that the ViewModel will consume.
