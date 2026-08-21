import Foundation

// MARK: - 1. Custom Errors

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case invalidUsername
    case invalidPassword

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."

        case .decodingError:
            return "Unable to decode the response."

        case .invalidUsername:
            return "Username is invalid."

        case .invalidPassword:
            return "Password is invalid."
        }
    }
}


// MARK: - 2. User Model

struct User: Codable {
    let id: Int
    let name: String
}


// MARK: - 3. Async/Await API Service

final class AsyncAPIService {

    func checkAPIIssue() async throws -> [User] {

        guard let url = URL(
            string: "https://jsonplaceholder.typicode.com/users"
        ) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Rename downcast result to httpResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Use contains instead of ~= operator
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(
                [User].self,
                from: data
            )
        } catch {
            throw APIError.decodingError
        }
    }
}


// MARK: - 4. UIKit Completion-Based API Service

final class APIService {

    func fetchUsers(
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        guard let url = URL(
            string: "https://jsonplaceholder.typicode.com/users"
        ) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in

            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(
                        .failure(
                            APIError.serverError(
                                httpResponse.statusCode
                            )
                        )
                    )
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }

            do {
                let users = try JSONDecoder().decode(
                    [User].self,
                    from: data
                )

                DispatchQueue.main.async {
                    completion(.success(users))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIError.decodingError))
                }
            }
        }
        .resume()
    }
}


// MARK: - 5. ViewModel

final class UserViewModel {

    private let apiService = APIService()

    func loadUsers() {

        apiService.fetchUsers { result in

            switch result {

            case .success(let users):
                print("Users count: \(users.count)")

            case .failure(let error):
                // LocalizedError automatically provides
                // the custom errorDescription here.
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: - Usage

let viewModel = UserViewModel()

viewModel.loadUsers()
