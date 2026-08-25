import Foundation

@MainActor
final class UserListViewModel {

    private let service: any UserServiceProtocol

    private(set) var users: [User] = []

    private(set) var isLoading = false

    private(set) var errorMessage: String?

    init(service: any UserServiceProtocol) {
        self.service = service
    }

    func loadUsers() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            users = try await service.fetchUsers()

        } catch {

            errorMessage =
                "Unable to load users."
        }
    }
}
