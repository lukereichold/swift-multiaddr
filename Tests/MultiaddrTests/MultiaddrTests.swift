import XCTest
@testable import Multiaddr

final class MultiaddrTests: XCTestCase {
    func testCreateMultiaddrFromString() {
        let m = try! Multiaddr("/ip4/127.0.0.1/udp/1234")
        let expectedAddress1 = Address(addrProtocol: .ip4, address: "127.0.0.1")
        let expectedAddress2 = Address(addrProtocol: .udp, address: "1234")
        
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
        let expectedAddress1 = Address(addrProtocol: .dns6, address: "foo.com")
        let expectedAddress2 = Address(addrProtocol: .tcp, address: "443")
        let expectedAddress3 = Address(addrProtocol: .https, address: nil)
        
        XCTAssertEqual(m.addresses[0], expectedAddress1)
        XCTAssertEqual(m.addresses[1], expectedAddress2)
        XCTAssertEqual(m.addresses[2], expectedAddress3)
    }
    
    func testCreateMultiaddrFromString_AddressValueHasMultipleSlashes() {
        let m = try! Multiaddr("/dns4/foo.com/tcp/80/http/bar/baz.jpg/onion")
        let expectedAddress1 = Address(addrProtocol: .dns4, address: "foo.com")
        let expectedAddress2 = Address(addrProtocol: .tcp, address: "80")
        let expectedAddress3 = Address(addrProtocol: .http, address: "bar/baz.jpg")
        
        XCTAssertEqual(m.addresses[0], expectedAddress1)
        XCTAssertEqual(m.addresses[1], expectedAddress2)
        XCTAssertEqual(m.addresses[2], expectedAddress3)
    }
    
    func testCreateMultiaddrFromString_AddressValueHasColons() {
        let m = try! Multiaddr("/ip6/::1/tcp/3217")
        let expectedAddress1 = Address(addrProtocol: .ip6, address: "::1")
        let expectedAddress2 = Address(addrProtocol: .tcp, address: "3217")
        
        XCTAssertEqual(m.addresses[0], expectedAddress1)
        XCTAssertEqual(m.addresses[1], expectedAddress2)
    }
    
    func testEncapsulated_BasedOnStringEquality() {
        let m1 = try! Multiaddr("/ip4/127.0.0.1")
        let m2 = try! Multiaddr("/udt")
    
        let encapsulated = m1.encapsulate(m2)
        XCTAssertEqual(String(describing: encapsulated), "/ip4/127.0.0.1/udt")
        
        let m3 = try! Multiaddr("/ip4/127.0.0.1")
        let encapsulated2 = try! m3.encapsulate("/udp/1234")
        XCTAssertEqual(String(describing: encapsulated2), "/ip4/127.0.0.1/udp/1234")
    }
    
    func testEncapsulated_BasedOnObjectEquality() {
        let m1 = try! Multiaddr("/ip4/127.0.0.1")
        let m2 = try! Multiaddr("/udt")
        
        let expected = try! Multiaddr("/ip4/127.0.0.1/udt")
        XCTAssertEqual(m1.encapsulate(m2), expected)
    }
    
    func testDecapsulate() {
        let full = try! Multiaddr("/ip4/1.2.3.4/tcp/80")
        let m1 = try! Multiaddr("/tcp/80")
        let m2 = try! Multiaddr("/ip4/1.2.3.4")
        
        XCTAssertEqual(full.decapsulate(m1), m2)
        XCTAssertEqual(full.decapsulate(m2), m1)
    }
    
    // TODO: Perform validation on INIT! (Not once it's already created on binaryPacked())
    func testCreateMultiaddrFromString_FailsWithInvalidStrings() {
        let addresses = ["notAProtocol",
                   "/ip4/tcp/alsoNotAProtocol",
                   "////ip4/tcp/21432141///",
                   "////ip4///////tcp////"]
        
        for addr in addresses {
            XCTAssertThrowsError(try Multiaddr(addr)) { error in
                print("\(addr) was invalid")
                XCTAssertEqual(error as! MultiaddrError, MultiaddrError.invalidFormat)
            }
        }
    }

    func testBinaryPackedReturnsCorrectValue_For16BitProtocolPort() {
        let expected = "0601bb"
        let m = try! Multiaddr("/tcp/443")
        let actual = try! m.binaryPacked().hexString()
        XCTAssertEqual(actual, expected)
    }
    
    func testBinaryPackedReturnsCorrectValue_ForIPv4Address() {
        let expected = "04c000022a"
        let m = try! Multiaddr("/ip4/192.0.2.42")
        let actual = try! m.binaryPacked().hexString()
        XCTAssertEqual(actual, expected)
    }
    
    func testBinaryPackedThrowsError_ForInvalidIPv4Address() {
        XCTAssertThrowsError(try Multiaddr("/ip4/555.55.55.5").binaryPacked()) { error in
            XCTAssertEqual(error as! MultiaddrError, MultiaddrError.parseIPv4AddressFail)
        }
    }
    
    func testBinaryPacked_ForOnionAddress_EncodesCorrectly() {
        let expected = "bc039a18087306369043091f0050"
        let m = try! Multiaddr("/onion/timaq4ygg2iegci7:80")
        let actual = try! m.binaryPacked().hexString()
        XCTAssertEqual(actual, expected)
    }
    
    func testBinaryPacked_ForIpfsAddress_EncodesCorrectly() {
        let expected = "A503221220D52EBB89D85B02A284948203A62FF28389C57C9F42BEEC4EC20DB76A68911C0B"
        let m = try! Multiaddr("/ipfs/QmcgpsyWgH8Y8ajJz1Cu72KnS5uo2Aa2LpzU7kinSupNKC")
        let actual = try! m.binaryPacked().hexString()
        XCTAssertEqual(actual, expected)
    }
    
    static var allTests = [
        ("testLinuxTestSuiteIncludesAllTests",
         testLinuxTestSuiteIncludesAllTests),
        ("testCreateMultiaddrFromString", testCreateMultiaddrFromString),
        ("testCreateMultiaddrFromString_LeadingSlashRequired", testCreateMultiaddrFromString_LeadingSlashRequired),
        ("testCreateMultiaddrFromString_WithoutAddressValue", testCreateMultiaddrFromString_WithoutAddressValue),
        ("testCreateMultiaddrFromString_AddressValueHasMultipleSlashes", testCreateMultiaddrFromString_AddressValueHasMultipleSlashes),
        ("testCreateMultiaddrFromString_AddressValueHasColons", testCreateMultiaddrFromString_AddressValueHasColons),
        ("testEncapsulated_BasedOnStringEquality", testEncapsulated_BasedOnStringEquality),
        ("testEncapsulated_BasedOnObjectEquality", testEncapsulated_BasedOnObjectEquality),
        ("testDecapsulate", testDecapsulate),
        ("testCreateMultiaddrFromString_FailsWithInvalidStrings", testCreateMultiaddrFromString_FailsWithInvalidStrings),
        ("testBinaryPackedReturnsCorrectValue_For16BitProtocolPort", testBinaryPackedReturnsCorrectValue_For16BitProtocolPort),
        ("testBinaryPackedReturnsCorrectValue_ForIPv4Address", testBinaryPackedReturnsCorrectValue_ForIPv4Address),
        ("testBinaryPackedThrowsError_ForInvalidIPv4Address", testBinaryPackedThrowsError_ForInvalidIPv4Address),
        ("testBinaryPackedThrowsError_ForInvalidIPv4Address", testBinaryPackedThrowsError_ForInvalidIPv4Address),

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

