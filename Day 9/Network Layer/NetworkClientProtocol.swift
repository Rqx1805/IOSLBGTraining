// MARK: - Network Client Protocol

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(
        endpoint: URL
    ) async throws -> T
}

