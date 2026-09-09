import XCTest
@testable import YourAppName

final class MockNetworkService: NetworkServiceProtocol {

    var shouldFail = false

    func request<T: Decodable>(
        endPointUrl: URL
    ) async throws -> T {

        if shouldFail {
            throw APIError.invalidResponse
        }

        let user = User(
            id: 1,
            name: "Ashish",
            email: "ashish@test.com"
        )

        return user as! T
    }
}
