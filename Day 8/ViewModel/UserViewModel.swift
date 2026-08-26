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

        } catch let error as NetworkError {

            handle(error)

        } catch {

            errorMessage =
                "Something went wrong."
        }
    }

    private func handle(
        _ error: NetworkError
    ) {

        switch error {

        case .invalidURL:
            errorMessage = "Invalid URL."

        case .invalidResponse:
            errorMessage = "Invalid server response."

        case .serverError(let statusCode):
            errorMessage =
                "Server error: \(statusCode)"

        case .decodingFailed:
            errorMessage =
                "Unable to process server data."
        }
    }
}
