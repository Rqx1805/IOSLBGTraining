//
//  NetworkServiceProtocol.swift
//  DemoChek
//
//  Created by Ashish Soni on 08/09/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endPointUrl: URL) async throws -> T
}
