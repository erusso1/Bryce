import XCTest
import BryceNetworking
import PromiseKit

class KeychainTests: XCTestCase {
    
    var timeout: TimeInterval = 500
    
    var keychainService = "com.bryce.test"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        
        Bryce.shared.use(Configuration.init(
            baseUrl: baseURL,
            securityPolicy: .none,
            logLevel: .debug)
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

extension KeychainTests {
    
    func testKeychainPersistence() {
        
        func persist() {
            
            let auth: Authorization = .basic(username: "jdoe123", password: "Password123")
            XCTAssertEqual(auth.headerValue, "Basic amRvZTEyMzpQYXNzd29yZDEyMw==")
            XCTAssertNotNil(Bryce.authorizationObserver)
            Bryce.shared.authorization = auth
            XCTAssertNotNil(Bryce.shared.authorization)
        }
        
        func read(expectsValue: Bool) {
            
            if expectsValue {
                XCTAssertNotNil(Bryce.shared.authorization)
                XCTAssertEqual(Bryce.shared.authorization?.headerValue, "Basic amRvZTEyMzpQYXNzd29yZDEyMw==")
            }
            else {
                XCTAssertNil(Bryce.shared.authorization)
            }
        }
        
        func clear() {
            Bryce.shared.logout()
            XCTAssertNil(Bryce.shared.authorization)
        }

        Bryce.shared.usePersistedAuthorization(service: keychainService)
        persist()
        read(expectsValue: true)
        clear()
        read(expectsValue: false)
        clear()
        clear()
    }
}
