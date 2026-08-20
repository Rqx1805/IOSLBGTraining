import UIKit

// 1. Basic Enum
// Defines a strict set of choices.
enum CompassDirection {
    case north
    case south
    case east
    case west
}

var currentDirection = CompassDirection.north
// Once the type is known, you can use shorthand dot notation
currentDirection = .east

// Enums are commonly used with switch statements
switch currentDirection {
case .north: print("Heading North")
case .south: print("Heading South")
case .east:  print("Heading East")
case .west:  print("Heading West")
}


// 2. Enum with Raw Values
// Assigns a backing literal value (String, Int, Character, or Float) to each case.
enum HTTPResponseCode: Int {
    case success = 200
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
}

let status = HTTPResponseCode.notFound
print("The status code name is \(status), and its raw value is \(status.rawValue)")

if let validResponse = HTTPResponseCode(rawValue: 200) {
    print("Initialization succeeded: \(validResponse)")
}


// 3. Enum with Associated Values
// Allows you to attach additional custom data to each specific case.
enum NetworkResult {
    case success(payload: String)          // Carries data on success
    case failure(errorCode: Int, message: String) // Carries error details on failure
}

// Simulating two different network responses
let appResponse: NetworkResult = .success(payload: "{'user': 'Alex'}")
let apiResponse: NetworkResult = .failure(errorCode: 500, message: "Internal Server Error")

func handleResponse(_ result: NetworkResult) {
    switch result {
    case .success(let data):
        print("Network Success! Data received: \(data)")
    case .failure(let code, let msg):
        print("Network Failure! Code: \(code), Message: \(msg)")
    }
}

handleResponse(appResponse)
handleResponse(apiResponse)

