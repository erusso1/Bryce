import XCTest
import BryceNetworking
import PromiseKit

class HTTPTests: XCTestCase {
    
    var timeout: TimeInterval = 500
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Bryce.shared.logout()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

// MARK: Authentication

extension HTTPTests {

    func testBasicAuthenticationHeaders() {
        
        let auth: Authorization = .basic(username: "jdoe123", password: "Password123")
        XCTAssertEqual(auth.headerValue, "Basic amRvZTEyMzpQYXNzd29yZDEyMw==")
        
        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let expectation = XCTestExpectation(description: "Basic authentication expectation.")
        
        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .none,
            logLevel: .debug)
        )
        
        Bryce.shared.authorization = auth
        
        let endpoint = Endpoint(components: "posts", "1")
        
        Bryce.shared.request(on: endpoint) { (post: Post?, error: Error?) in
            
            XCTAssertNil(error)
            XCTAssertNotNil(post)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testBearerAuthenticationHeaders() {
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let auth: Authorization = .bearer(token: token, refreshToken: nil)
        XCTAssertEqual(auth.headerValue, "Bearer \(token)")
        
        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let expectation = XCTestExpectation(description: "Basic authentication expectation.")
        
        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .none,
            logLevel: .debug)
        )
        
        Bryce.shared.authorization = auth
        
        let endpoint = Endpoint(components: "posts", "1")
        
        Bryce.shared.request(on: endpoint) { (post: Post?, error: Error?) in
            
            XCTAssertNil(error)
            XCTAssertNotNil(post)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: Certificate Pinning

extension HTTPTests {

    func testValidCertificatePinning() {

        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let expectation = XCTestExpectation(description: "Valid cert pinning expectation.")

        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .certifcatePinning(bundle: .main))
        )
        
        let endpoint = Endpoint(components: "posts", "1")
        
        Bryce.shared.request(on: endpoint) { (post: Post?, error: Error?) in
            
            XCTAssertNil(error)
            XCTAssertNotNil(post)
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeout)
    }
    
    // Un-check valid_cert.crt from Target Membership before running this test.
    /*
    func testInvalidCertificatePinning() {

        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let expectation = XCTestExpectation(description: "Invalid Cert pinning expectation.")
    
        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .certifcatePinning(bundle: .main))
        )
        
        let endpoint = Endpoint(components: "posts", "1")
        
        Bryce.shared.request(on: endpoint) { (post: Post?, error: Error?) in
            
            XCTAssertNotNil(error)
            XCTAssertNil(post)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    */

    func testNoSecurityPolicy() {

        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let expectation = XCTestExpectation(description: "No sercurity policy expectation.")

        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .none,
            logLevel: .debug)
        )
        
        let endpoint = Endpoint(components: "posts", "1")
        
        Bryce.shared.request(on: endpoint) { (post: Post?, error: Error?) in
            
            XCTAssertNil(error)
            XCTAssertNotNil(post)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: Parameter Encoding

extension HTTPTests {

    func testQueryParamEncoding() {

        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let expectation0 = XCTestExpectation(description: "Query param object encoding expectation.")
        let expectation1 = XCTestExpectation(description: "Query param dictionary encoding expectation.")

        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .none)
        )

        struct Parameters: Encodable {

            let postId: Int
        }

        let endpoint = Endpoint(components: "comments")
        
        Bryce.shared.request(on: endpoint, parameters: Parameters(postId: 1)) { (comments: [Comment]?, error: Error?) in
            
            XCTAssertNil(error)
            XCTAssertNotNil(comments)
            XCTAssertEqual(comments!.count, 5)
            XCTAssertEqual(comments!.first!.name, "id labore ex et quam laborum")
            
            expectation0.fulfill()
        }
        
        Bryce.shared.request(on: endpoint, parameters: ["postId" : 1]) { (comments: [Comment]?, error: Error?) in
            
            XCTAssertNil(error)
            XCTAssertNotNil(comments)
            XCTAssertEqual(comments!.count, 5)
            XCTAssertEqual(comments!.first!.name, "id labore ex et quam laborum")
            
            expectation1.fulfill()
        }
    }
}
