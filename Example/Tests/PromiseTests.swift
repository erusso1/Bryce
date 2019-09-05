//import XCTest
//import BryceNetworking
//
//class PromiseTests: XCTestCase {
//    
//    var timeout: TimeInterval = 500
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        Bryce.shared.logout()
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//}
//
//// MARK: Authentication
//
//extension PromiseTests {
//    
//    func testBasicAuthenticationHeaders() {
//        
//        let auth: Authorization = .basic(username: "jdoe123", password: "Password123", expiration: nil)
//        XCTAssertEqual(auth.headerValue, "Basic amRvZTEyMzpQYXNzd29yZDEyMw==")
//        
//        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
//        let expectation = XCTestExpectation(description: "Basic authentication expectation.")
//        
//        Bryce.shared.use(Configuration.init(
//            baseUrl: baseURL,
//            securityPolicy: .none,
//            logLevel: .debug)
//        )
//        
//        Bryce.shared.authorization = auth
//        
//        let endpoint = Endpoint(components: "posts", "1")
//        
//        firstly {
//            
//            Bryce.shared.request(on: endpoint, responseType: Post.self)
//            }.get { post in
//                
//                print("Successfully retreived post: \(post)")
//                XCTAssertEqual(post.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
//            }.catch { error in
//                
//                print("An error occurred: \(error)")
//                XCTAssert(false)
//                
//            }.finally {
//                
//                expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//    
//    func testBearerAuthenticationHeaders() {
//        
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
//        let auth: Authorization = .bearer(token: token, refreshToken: nil, expiration: nil)
//        XCTAssertEqual(auth.headerValue, "Bearer \(token)")
//        
//        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
//        let expectation = XCTestExpectation(description: "Basic authentication expectation.")
//        
//        Bryce.shared.use(Configuration.init(
//            baseUrl: baseURL,
//            securityPolicy: .none,
//            logLevel: .debug)
//        )
//        
//        Bryce.shared.authorization = auth
//        
//        let endpoint = Endpoint(components: "posts", "1")
//        
//        firstly {
//            
//            Bryce.shared.request(on: endpoint, responseType: Post.self)
//            }.get { post in
//                
//                print("Successfully retreived post: \(post)")
//                XCTAssertEqual(post.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
//            }.catch { error in
//                
//                print("An error occurred: \(error)")
//                XCTAssert(false)
//                
//            }.finally {
//                
//                expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//}
//
//// MARK: Certificate Pinning
//
//extension PromiseTests {
//    
//    func testValidCertificatePinning() {
//        
//        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
//        let expectation = XCTestExpectation(description: "Valid cert pinning expectation.")
//        
//        Bryce.shared.use(Configuration.init(
//            baseUrl: baseURL,
//            securityPolicy: .certifcatePinning(bundle: .main))
//        )
//        
//        firstly {
//            
//            Bryce.shared.request(on: baseURL.appendingPathComponent("posts").appendingPathComponent("1"), responseType: Post.self)
//            
//        }.done { post in
//                
//            print("Successfully retreived the post: \(post)")
//            XCTAssert(true)
//                
//        }.catch { error in
//                
//            print("An error occurred: \(error)")
//            XCTAssert(false)
//                
//        }.finally {
//                
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//    
//    // Un-check valid_cert.crt from Target Membership before running this test.
//    /*
//    func testInvalidCertificatePinning() {
//        
//        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
//        let expectation = XCTestExpectation(description: "Invalid Cert pinning expectation.")
//        
//        Bryce.shared.use(Configuration.init(
//            baseUrl: baseURL,
//            securityPolicy: .certifcatePinning(bundle: .main))
//        )
//        
//        firstly {
//            
//            Bryce.shared.request(on : baseURL.appendingPathComponent("posts").appendingPathComponent("1"), responseType: Post.self)
//            
//        }.done { post in
//                
//            print("Successfully retreived the post: \(post)")
//            XCTAssert(false)
//                
//        }.catch { error in
//                
//            print("An error occurred: \(error)")
//            XCTAssert(false)
//                
//        }.finally {
//                
//            XCTAssert(true)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//    */
//    
//    func testNoSecurityPolicy() {
//        
//        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
//        let expectation = XCTestExpectation(description: "No sercurity policy expectation.")
//        
//        Bryce.shared.use(Configuration.init(
//            baseUrl: baseURL,
//            securityPolicy: .none,
//            logLevel: .debug)
//        )
//        
//        firstly {
//            
//            Bryce.shared.request(on: baseURL.appendingPathComponent("posts").appendingPathComponent("1"), responseType: Post.self)
//            
//        }.get { post in
//                
//            print("Successfully retreived post: \(post)")
//            XCTAssertEqual(post.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
//                
//        }.then { post in
//                
//            Bryce.shared.request(on: "https://jsonplaceholder.typicode.com/posts/2", responseType: Post.self)
//                
//        }.get { post in
//                
//            print("Successfully retreived post: \(post)")
//            XCTAssertEqual(post.title, "qui est esse")
//                
//        }.catch { error in
//                
//            print("An error occurred: \(error)")
//            XCTAssert(false)
//                
//        }.finally {
//                
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//}
//
//// MARK: Parameter Encoding
//
//extension PromiseTests {
//    
//    func testQueryParamEncoding() {
//        
//        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
//        let expectation = XCTestExpectation(description: "Query param encoding expectation.")
//        
//        Bryce.shared.use(Configuration.init(
//            baseUrl: baseURL,
//            securityPolicy: .none)
//        )
//        
//        struct Parameters: Encodable {
//            
//            let postId: Int
//        }
//        
//        firstly {
//            
//            Bryce.shared.request(on: baseURL.appendingPathComponent("comments"), parameters: Parameters(postId: 1), encoding: URLEncoding.queryString, responseType: [Comment].self)
//            
//        }.get { comments in
//                
//            print("Successfully retreived \(comments.count) comments.")
//            XCTAssertEqual(comments.count, 5)
//            XCTAssertEqual(comments.first?.name, "id labore ex et quam laborum")
//                
//        }.then { comments in
//                
//            Bryce.shared.request(on: baseURL.appendingPathComponent("comments"), parameters: ["postId" : 1], encoding: URLEncoding.queryString, responseType: [Comment].self)
//                
//        }.done { comments in
//                
//            print("Successfully retreived \(comments.count) comments.")
//            XCTAssertEqual(comments.count, 5)
//            XCTAssertEqual(comments.first?.name, "id labore ex et quam laborum")
//                
//        }.catch { error in
//                
//            print("An error occurred: \(error)")
//            XCTAssert(false)
//                
//        }.finally {
//                
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//}
