import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."

        case .invalidResponse:
            return "Invalid response."

        case .invalidStatusCode(let statusCode):
            return "Server Error \(statusCode)."

        case .networkError:
            return "Network Error."

        case .decodingError:
            return "Unable to decode response."
        }
    }
}
