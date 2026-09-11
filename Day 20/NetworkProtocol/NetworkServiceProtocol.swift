//  NetworkServiceProtocol.swift

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endPointUrl: URL) async throws -> T
}
