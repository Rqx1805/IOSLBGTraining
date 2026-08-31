// MARK: - Network Client Protocol

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: URL
    ) async throws -> T
}


// Why Use a Network Protocol? Instead of:

final class UserService {

    private let session =
        URLSession.shared
}

// we use:

private let networkClient:
    any NetworkServiceProtocol

// We can replace the network implementation.

//Production
//    ↓
//NetworkClient
//
//Testing
//    ↓
//MockNetworkClient

// Trade-off

// For a very small application, this abstraction may be unnecessary.


//Protocol
//Implementation
//Mock
//Dependency Injection
