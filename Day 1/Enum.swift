// MARK: - 1. Basic Enum

// No UIKit import because this file does not use UIKit.

enum CompassDirection: CaseIterable {
    case north, south, east, west
}

// Usage
var currentDirection: CompassDirection = .north
currentDirection = .east

switch currentDirection {
case .north:
    print("Heading North")

case .south:
    print("Heading South")

case .east:
    print("Heading East")

case .west:
    print("Heading West")
}

// CaseIterable usage
print("Total directions: \(CompassDirection.allCases.count)")

for direction in CompassDirection.allCases {
    print(direction)
}


// MARK: - 2. Enum with Raw Values

enum HTTPResponseCode: Int {
    case success = 200
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404

    // Computed property
    var message: String {
        switch self {
        case .success:
            return "Request completed successfully"

        case .badRequest:
            return "Bad Request"

        case .unauthorized:
            return "Unauthorized"

        case .notFound:
            return "Resource not found"
        }
    }

    // Function to handle response
    func handleResponse() {
        switch self {
        case .success:
            print("Success: \(message)")

        default:
            print("Error \(rawValue): \(message)")
        }
    }
}


// Usage with guard instead of if let
func processResponse(statusCode: Int) {
    guard let response = HTTPResponseCode(rawValue: statusCode) else {
        print("Unknown HTTP status code: \(statusCode)")
        return
    }

    response.handleResponse()
}

processResponse(statusCode: 200)
processResponse(statusCode: 404)
processResponse(statusCode: 500)


// MARK: - 3. Enum with Associated Values

enum NetworkResult {
    case success(String)
    case failure(Int, message: String)

    func handle() {
        switch self {
        case .success(let data):
            print("Network Success! Data received: \(data)")

        case .failure(let code, let message):
            print("Network Failure! Code: \(code), Message: \(message)")
        }
    }
}


// Usage
let appResponse: NetworkResult = .success("{'user': 'Alex'}")

let apiResponse: NetworkResult = .failure(
    500,
    message: "Internal Server Error"
)

appResponse.handle()
apiResponse.handle()
