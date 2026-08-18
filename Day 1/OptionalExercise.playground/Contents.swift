import Foundation

// 1. Declaring Optionals
// The question mark (?) indicates the variable can hold a String or be nil.
var jobTitle: String? = "iOS Developer"
var middleName: String? = nil // Explicitly has no value

print("--- 1. Initial Values ---")
print("Job: \(String(describing: jobTitle))")
print("Middle Name: \(String(describing: middleName))")


// 2. Unwrapping safely using 'if let' (Optional Binding)
// This is the most common way to check for and extract a value.
print("\n--- 2. Safe Unwrapping (if let) ---")
if let actualJob = jobTitle {
    // Inside this block, actualJob is a regular, non-optional String
    print("Success! The person works as a \(actualJob).")
} else {
    print("The person is currently unemployed.")
}


// 3. Unwrapping safely using 'guard let'
// Used early in functions to exit if a value is missing.
print("\n--- 3. Safe Unwrapping (guard let) ---")
func printMiddleName(name: String?) {
    guard let actualMiddleName = name else {
        print("No middle name provided. Exiting function.")
        return
    }
    // actualMiddleName is available for the rest of the function scope
    print("Middle name is: \(actualMiddleName)")
}
printMiddleName(name: middleName)


// 4. Providing a default value using Nil Coalescing (??)
// If the optional is nil, it falls back to the default value on the right.
print("\n--- 4. Nil Coalescing ---")
let currentStatus = jobTitle ?? "Searching for a job..."
let passportName = middleName ?? "(N/A)"

print("Status: \(currentStatus)")
print("Passport Middle Name: \(passportName)")


// 5. Force Unwrapping (!)
// WARNING: Only use this if you are 100% sure the variable is not nil.
// If it is nil, your app WILL crash.
print("\n--- 5. Force Unwrapping ---")
jobTitle = "Senior Engineer"
print("Force unwrapped job: \(jobTitle!)")

// Unleashing a crash on purpose to show what happens:
// middleName! // <-- Uncommenting this line will crash your Playground because middleName is nil.

