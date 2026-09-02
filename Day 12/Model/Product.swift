// Domain Layer - Entities:

import Foundation

struct Product: Identifiable {
    let id: Int
    let name: String
}



// Data Transfer Object

struct ProductDTO: Codable {
    let id: Int
    let name: String
}
