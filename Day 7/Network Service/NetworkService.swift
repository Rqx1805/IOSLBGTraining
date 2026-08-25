import Foundation

protocol NetworkServiceProtocol {

    func request(
        from url: URL
    ) async throws -> (Data, URLResponse)
}

final class NetworkClient:
    NetworkServiceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request(
        from url: URL
    ) async throws -> (Data, URLResponse) {

        try await session.data(
            from: url
        )
    }
}
