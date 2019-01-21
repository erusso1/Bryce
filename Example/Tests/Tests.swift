import XCTest
import Bryce

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicAuthenticationHeaders() {
        
        let auth: Bryce.Authorization = .basic(username: "jdoe123", password: "Password123")
        XCTAssertEqual(auth.headers, ["Authorization" : "Basic amRvZTEyMzpQYXNzd29yZDEyMw=="])
    }
    
    func testBearerAuthenticationHeaders() {
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let auth: Bryce.Authorization = .bearer(token: token)
        XCTAssertEqual(auth.headers, ["Authorization" : "Bearer \(token)"])
    }
    
    func testCertificatePinning() {
        
        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let certPath = Bundle.main.url(forResource: "test_cert", withExtension: "crt")!
        
        Bryce.configuration = .init(
            baseUrl: baseURL,
            securityPolicy: .certifcatePinning(path: certPath)
        )

    }
}
