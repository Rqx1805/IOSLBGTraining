import UIKit

// 1. Define Custom Errors
// Errors are represented by types that conform to the empty Error protocol.
enum APIError: Error {
    case InvalidURL
    case InvalidResponse
    case ServerError(Int)
    case decodingError
    case invalidUsername
    case invalidPassword
    
    var errorDescription: String? {
        switch self {
        case .InvalidURL:
            return "InvalidURL"
        case .InvalidResponse:
            return "InvalidResponse"
        case .ServerError(let statusCode):
            return "Server Error\(statusCode)"
        case .decodingError:
            return "Decoding Error"
        case .invalidUsername:
            return "Username Invalid"
        case .invalidPassword:
            return "Password Invalid"
        }
    }
}
// Struct representing an user in the machine
struct User: Codable {
    let id: Int
    let name: String
}

// SwiftUI
class APIService {
    // 2. A Function That Throws Errors
    // The 'throws' keyword indicates that this function can fail and throw an error.
    func checkAPIIssue() async throws -> [User] {
        // Invalid URL---
        guard let url = URL(string: "") else {
            throw APIError.InvalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Invalid Response ---
        guard let response = response as? HTTPURLResponse else {
            throw APIError.InvalidResponse
        }
        // Server Error---
        guard 200...299 ~= response.statusCode else {
            throw APIError.ServerError(response.statusCode)
        }
        // 3. Handling Errors Using Do-Catch
        do {
            let user = try JSONDecoder().decode([User].self, from: data)
            return user
        }catch APIError.invalidUsername {
            print("Username cannot be empty")

        } catch LoginError.invalidPassword {
            print("Password must contain at least 4 characters")

        }
        catch {
            // Decoding Error---
            throw APIError.decodingError
        }
        
    }
}

// UIKIT
final class APIService {

    func fetchUsers(
        completion: @escaping (Result<[User], Error>) -> Void
    ) {

        guard let url = URL(
            string: ""
        ) else {
            completion(.failure(APIError.InvalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.InvalidResponse))
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

        }.resume()
    }
}


final class UserViewModel {

    private let apiService = APIService()

    func loadUsers() {

        apiService.fetchUsers { result in

            switch result {

            case .success(let users):
                print("Users count: \(users.count)")

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
