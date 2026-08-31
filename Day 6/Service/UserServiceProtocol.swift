import Foundation

protocol UserServiceProtocol {
    func fetchUser() async throws -> User
}

final class UserService: UserServiceProtocol {

    func fetchUser() async throws -> User {
        try await Task.sleep(for: .seconds(1))

        return User(
            id: 1,
            name: "Ashish",
            email: "ashish@gmail.com"
        )
    }
}
