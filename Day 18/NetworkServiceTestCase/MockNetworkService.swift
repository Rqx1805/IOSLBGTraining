import XCTest
@testable import AppName

final class MockNetworkService: NetworkServiceProtocol {

    var shouldFail = false

    func request<T: Decodable>(
        endPointUrl: URL
    ) async throws -> T {

        if shouldFail {
            throw APIError.invalidResponse
        }

        return T
    }
}
