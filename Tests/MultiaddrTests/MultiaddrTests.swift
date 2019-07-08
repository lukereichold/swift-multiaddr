import XCTest
@testable import Multiaddr

final class MultiaddrTests: XCTestCase {
    func testCreateMultiaddrFromString() {
        let m = try! Multiaddr("/ip4/127.0.0.1/udp/1234")
        let expectedAddress1 = Address(protocolCode: .ip4, address: "127.0.0.1")
        let expectedAddress2 = Address(protocolCode: .udp, address: "1234")
        
        XCTAssertEqual(m.addresses.first, expectedAddress1)
        XCTAssertEqual(m.addresses.last, expectedAddress2)
    }
    
    func testCreateMultiaddrFromString_LeadingSlashRequired() {
        XCTAssertThrowsError(try Multiaddr("ip4/127.0.0.1/udp/1234")) { error in
            XCTAssertEqual(error as! MultiaddrError, MultiaddrError.invalidFormat)
        }
    }
    
    func testCreateMultiaddrFromString_WithoutAddressValue() {
        let m = try! Multiaddr("/dns6/foo.com/tcp/443/https")
        let expectedAddress1 = Address(protocolCode: .dns6, address: "foo.com")
        let expectedAddress2 = Address(protocolCode: .tcp, address: "443")
        let expectedAddress3 = Address(protocolCode: .https, address: nil)
        
        XCTAssertEqual(m.addresses[0], expectedAddress1)
        XCTAssertEqual(m.addresses[1], expectedAddress2)
        XCTAssertEqual(m.addresses[2], expectedAddress3)
    }
    
    func testCreateMultiaddrFromString_AddressValueHasMultipleSlashes() {
        let m = try! Multiaddr("/dns4/foo.com/tcp/80/http/bar/baz.jpg/onion")
        let expectedAddress1 = Address(protocolCode: .dns4, address: "foo.com")
        let expectedAddress2 = Address(protocolCode: .tcp, address: "80")
        let expectedAddress3 = Address(protocolCode: .http, address: "bar/baz.jpg")
        
        XCTAssertEqual(m.addresses[0], expectedAddress1)
        XCTAssertEqual(m.addresses[1], expectedAddress2)
        XCTAssertEqual(m.addresses[2], expectedAddress3)
    }
    
    func testCreateMultiaddrFromString_AddressValueHasColons() {
        let m = try! Multiaddr("/ip6/::1/tcp/3217")
        let expectedAddress1 = Address(protocolCode: .ip6, address: "::1")
        let expectedAddress2 = Address(protocolCode: .tcp, address: "3217")
        
        XCTAssertEqual(m.addresses[0], expectedAddress1)
        XCTAssertEqual(m.addresses[1], expectedAddress2)
    }
    
    static var allTests = [
        ("testLinuxTestSuiteIncludesAllTests",
         testLinuxTestSuiteIncludesAllTests),
        ("testCreateMultiaddrFromString", testCreateMultiaddrFromString),
        ("testCreateMultiaddrFromString_LeadingSlashRequired", testCreateMultiaddrFromString_LeadingSlashRequired),
        ("testCreateMultiaddrFromString_WithoutAddressValue", testCreateMultiaddrFromString_WithoutAddressValue),
        ("testCreateMultiaddrFromString_AddressValueHasMultipleSlashes", testCreateMultiaddrFromString_AddressValueHasMultipleSlashes),
        ("testCreateMultiaddrFromString_AddressValueHasColons", testCreateMultiaddrFromString_AddressValueHasColons),

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

