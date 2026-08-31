import Foundation

// MARK: - Network Client Service
//
// Responsibility:
//
// 1. Make network calls
// 2. Validate HTTP response
// 3. Handle HTTP status codes
// 4. Map networking errors
// 5. Decode JSON
//
// It should NOT know anything about users,
// products, orders, etc.

final class NetworkClientService: NetworkServiceProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(
        endpoint: URL
    ) async throws -> T {

        do {
            // MARK: Make Network Call

            let (data, response) = try await session.data(
                from: endpoint
            )

            // MARK: Validate HTTP Response

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            // MARK: Validate HTTP Status Code

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidStatusCode(
                    statusCode: httpResponse.statusCode
                )
            }

            // MARK: Validate Data

            guard !data.isEmpty else {
                throw NetworkError.noData
            }

            // MARK: JSON Decoding

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }

        } catch let error as NetworkError {
            // Already mapped network error
            throw error

        } catch {
            // Map URLSession/network errors
            throw mapNetworkError(error)
        }
    }

    // MARK: Error Mapping

    private func mapNetworkError(_ error: Error) -> NetworkError {

        if let urlError = error as? URLError {

            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost:
                return .invalidResponse

            default:
                return .invalidResponse
            }
        }

        return .invalidResponse
    }
}
