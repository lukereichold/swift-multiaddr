import XCTest
@testable import Multiaddr

final class MultiaddrTests: XCTestCase {
    func testExample() {
        print(Protocol.ip4)
        let m = Multiaddr("/ip4/127.0.0.1/udp/1234")
        
        var protoComponents = "/ip4/127.0.0.1/udp/1234".split{$0 == "/"}.map(String.init)
//        print(protoComponents)
        
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

