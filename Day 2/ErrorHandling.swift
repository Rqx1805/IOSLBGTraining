import UIKit

// 1. Define Custom Errors
// Errors are represented by types that conform to the empty Error protocol.
enum APIError: Error {
    case InvalidURL
    case InvalidResponse
    case ServerError(Int)
    case decodingError
    
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
        }
    }
}
// Struct representing an user in the machine
struct User: Codable {
    let name: String
}

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
        } catch {
            // Decoding Error---
            throw APIError.decodingError
        }
        
    }
}
