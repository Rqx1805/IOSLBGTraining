import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(endPointUrl: URL)  async throws -> T
}


