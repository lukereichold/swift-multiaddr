import XCTest
@testable import Multiaddr

class ProtocolsTests: XCTestCase {

    func testVarIntEncoding() {
        let proto1 = Protocol.ip6
        let expectedPackedValueAsHex1 = "29"
        let varIntEncodedBytes1 = proto1.varIntCode().hexString()
        XCTAssertEqual(varIntEncodedBytes1, expectedPackedValueAsHex1)
        
        let proto2 = Protocol.ip4
        let expectedPackedValueAsHex2 = "04"
        let varIntEncodedBytes2 = proto2.varIntCode().hexString()
        XCTAssertEqual(varIntEncodedBytes2, expectedPackedValueAsHex2)
    }
}

extension Data {
    func hexString() -> String {
        return map { String(format:"%02x", $0) }.joined()
    }
}
