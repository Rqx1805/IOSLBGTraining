//
//  NetworkService.swift
//  DemoChek
//
//  Created by Ashish Soni on 08/09/26.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func request<T>(endPointUrl: URL) async throws -> T where T : Decodable {
        do  {
            let (data, response) = try await session.data(from: endPointUrl)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(response.statusCode) else {
                throw APIError.invalidStatusCode(response.statusCode)
            }
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.dcodingError(error)
        }
    }
    
    
}
