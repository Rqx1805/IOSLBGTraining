import Foundation

enum errorResponse: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
}
