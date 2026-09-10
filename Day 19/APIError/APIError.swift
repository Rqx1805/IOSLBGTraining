//  APIError.swift

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
}
