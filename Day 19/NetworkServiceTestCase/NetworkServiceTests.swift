import XCTest
@testable import AppName

final class NetworkServiceTests: XCTestCase {

    private var sut: MockNetworkService!

    override func setUp() {
        super.setUp()
        sut = MockNetworkService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testRequestSuccess() async throws {

        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

        let user: User = try await sut.request(
            endPointUrl: url
        )

        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Ashish")
        XCTAssertEqual(user.email, "ashish@test.com")
    }

    func testRequestFailure() async {

        sut.shouldFail = true

        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

        do {
            let _: User = try await sut.request(
                endPointUrl: url
            )

            XCTFail("Expected error")

        } catch {

            XCTAssertNotNil(error)
        }
    }
}
