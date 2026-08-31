import Foundation

// MARK: - User Service Protocol
//
// UserService is responsible for:
//
// 1. User-specific endpoint selection
// 2. User-specific business/data logic
// 3. Returning User domain models
//
// It should NOT handle:
//
// ❌ HTTP status codes
// ❌ URLSession
// ❌ JSONDecoder
// ❌ Generic network errors

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}
