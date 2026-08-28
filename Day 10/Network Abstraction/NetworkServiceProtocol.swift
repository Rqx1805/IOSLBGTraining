import Foundation

protocol NetworkServiceProtocol {

    func request(
        from url: URL
    ) async throws -> (Data, URLResponse)
}


// Why Use a Network Protocol? Instead of:

final class UserService {

    private let session =
        URLSession.shared
}

// we use:

private let networkClient:
    any NetworkClientProtocol

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
