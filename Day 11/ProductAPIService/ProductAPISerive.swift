import Foundation

final class ProductAPISerive: ProductRemoteDataSource {
    
    func getProducts() async throws -> [ProductDTO] {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw errorResponse.invalidURL
        }
       
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpRespons = response as? HTTPURLResponse else {
            throw errorResponse.invalidResponse
        }
        guard (200...299).contains(httpRespons.statusCode) else {
            throw errorResponse.invalidStatusCode(httpRespons.statusCode)
        }
        do {
            let user = try JSONDecoder().decode([ProductDTO].self, from: data)
            return user
        } catch {
            throw errorResponse.decodingError(error)
        }
    }
}
