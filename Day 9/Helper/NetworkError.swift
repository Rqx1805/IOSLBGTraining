import Foundation

// MARK: - Network Error

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(statusCode: Int)
    case noData
    case decodingError
}
