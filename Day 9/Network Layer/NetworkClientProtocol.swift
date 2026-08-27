import Foundation

protocol NetworkServiceProtocol {

    func request(
        from url: URL
    ) async throws -> (Data, URLResponse)
}

