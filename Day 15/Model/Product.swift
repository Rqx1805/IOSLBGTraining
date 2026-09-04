// Domain Layer - Entities:

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
