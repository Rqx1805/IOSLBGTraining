import Foundation

final class NetworkClientService:
    NetworkClientProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request(from url: URL) async throws -> (Data, URLResponse) {
        
        try await session.data(from: url)
    }
}
