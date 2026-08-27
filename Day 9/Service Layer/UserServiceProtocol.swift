import Foundation

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}
