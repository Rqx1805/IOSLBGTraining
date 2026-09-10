import Testing
@testable import AppName

@MainActor
struct NetworkServiceTests {

    private var sut: MockNetworkService!

    override func setUp() {
        super.setUp()
        sut = MockNetworkService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    @Test
    func testRequestSuccess() async  {

        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

        let user: User = try await sut.request(
            endPointUrl: url
        )
        
        #expect(user.id == 1)
        #expect(user.name == "Ashish")
        #expect(user.email == "ashish@test.com")
    }
    
    @Test
    func testRequestFailure() async {

        sut.shouldFail = true

        let url = URL(
            string: "https://jsonplaceholder.typicode.com/users"
        )!

        do {

            let _: User = try await sut.request(
                endPointUrl: url
            )

            Issue.record("Expected error")

        } catch {

            #expect(error != nil)
        }
    }
}
