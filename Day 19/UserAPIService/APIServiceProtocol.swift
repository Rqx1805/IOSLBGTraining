//  APIServiceProtocol.swift

import Foundation

protocol APIServiceProtocol {
    func fetchUser() async throws -> [User]
}
