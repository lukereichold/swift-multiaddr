import XCTest
@testable import Multiaddr

class ProtocolsTests: XCTestCase {

    func testVarIntEncoding() {
        let proto1 = Protocol.ip6
        let expectedPackedValueAsHex1 = "29"
        let varIntEncodedBytes1 = proto1.packedCode().hexString()
        XCTAssertEqual(varIntEncodedBytes1, expectedPackedValueAsHex1)
        
        let proto2 = Protocol.ip4
        let expectedPackedValueAsHex2 = "04"
        let varIntEncodedBytes2 = proto2.packedCode().hexString()
        XCTAssertEqual(varIntEncodedBytes2, expectedPackedValueAsHex2)
    }
    
    static var allTests = [
        ("testVarIntEncoding", testVarIntEncoding)
    ]

}

extension Data {
    func hexString() -> String {
        return map { String(format:"%02x", $0) }.joined()
    }
}

