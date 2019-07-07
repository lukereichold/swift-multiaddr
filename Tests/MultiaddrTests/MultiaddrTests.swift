import XCTest
@testable import Multiaddr

final class MultiaddrTests: XCTestCase {
    func testCreateMultiaddrFromString() {
        let m = Multiaddr("/ip4/127.0.0.1/udp/1234")!
        let expectedAddress1 = Address(protocolCode: .ip4, address: "127.0.0.1")
        let expectedAddress2 = Address(protocolCode: .udp, address: "1234")
        
        XCTAssertEqual(m.addresses.first, expectedAddress1)
        XCTAssertEqual(m.addresses.last, expectedAddress2)
    }
    
    func testCreateMultiaddrFromString_LeadingSlashRequired() {
        let m = Multiaddr("ip4/127.0.0.1/udp/1234")!
        let expectedAddress1 = Address(protocolCode: .ip4, address: "127.0.0.1")
        let expectedAddress2 = Address(protocolCode: .udp, address: "1234")
        
        XCTAssertEqual(m.addresses.first, expectedAddress1)
        XCTAssertEqual(m.addresses.last, expectedAddress2)
    }
    
//    func testCreateMultiaddrFromString() {
//        let m = Multiaddr("/ip4/127.0.0.1/udp/9090/quic")!
//        let expectedAddress1 = Address(protocolCode: .ip4, address: "127.0.0.1")
//        let expectedAddress2 = Address(protocolCode: .udp, address: "1234")
//
//        XCTAssertEqual(m.addresses.first, expectedAddress1)
//        XCTAssertEqual(m.addresses.last, expectedAddress2)
//    }

    static var allTests = [
        ("testLinuxTestSuiteIncludesAllTests",
         testLinuxTestSuiteIncludesAllTests),
        ("testCreateMultiaddrFromString", testCreateMultiaddrFromString),
    ]
    
    /// Credit: https://oleb.net/blog/2017/03/keeping-xctest-in-sync/
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        #if swift(>=4.0)
        let darwinCount = thisClass
            .defaultTestSuite.testCaseCount
        #else
        let darwinCount = Int(thisClass
            .defaultTestSuite().testCaseCount)
        #endif
        XCTAssertEqual(linuxCount, darwinCount,
                       "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}



///ip6/::1/tcp/3217
///ip4/127.0.0.1/tcp/80/http/baz.jpg
///dns4/foo.com/tcp/80/http/bar/baz.jpg
///dns6/foo.com/tcp/443/https
