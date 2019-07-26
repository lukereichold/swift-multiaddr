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
    
    func testCreateMultiaddrFromBytes_IPv4() {
        let bytes = [0x04, 0xc0, 0x00, 0x02, 0x2a] as [UInt8] // 04c000022a
        let data = Data(bytes: bytes, count: bytes.count)
        let m = try! Multiaddr(data)
       
        XCTAssertEqual("/ip4/192.0.2.42", m.description)
    }
    
    func testCreateMultiaddrFromBytes_TcpAddress() {
        let bytes = [0x06, 0x10, 0xe1] as [UInt8]
        let data = Data(bytes: bytes, count: bytes.count)
        
        let m_fromString = try! Multiaddr("/tcp/4321")
        let m_fromData = try! Multiaddr(data)
        
        XCTAssertEqual(m_fromData.description, m_fromString.description)
        XCTAssertEqual(try! m_fromData.binaryPacked(), try! m_fromString.binaryPacked())
     }
    
    func testDnsSerialization() {
        let addr = try! Multiaddr("/dns6/foo.com")
        let serialized = try! addr.binaryPacked()
        
        let deserialized = try! Multiaddr(serialized)
        XCTAssertEqual(addr, deserialized)
    }
    
    func testCreateMultiaddrFromBytes_Onion() {
        
        let bytes = [0xBC, 0x03, 0x9a, 0x18, 0x08, 0x73, 0x06, 0x36, 0x90, 0x43, 0x09, 0x1f, 0x00, 0x50] as [UInt8]
        let data = Data(bytes: bytes, count: bytes.count)
        
        let m_fromString = try! Multiaddr("/onion/timaq4ygg2iegci7:80")
        let m_fromData = try! Multiaddr(data)
        
        XCTAssertEqual(m_fromData.description, m_fromString.description)
        XCTAssertEqual(try! m_fromData.binaryPacked(), try! m_fromString.binaryPacked())
    }
    
    func testCreateMultiaddrFromBytes_IpfsAddress() {
        let bytes = [0xa5, 0x03, 0x22, 0x12, 0x20, 0xd5, 0x2e, 0xbb, 0x89, 0xd8, 0x5b, 0x02, 0xa2, 0x84, 0x94, 0x82, 0x03, 0xa6, 0x2f, 0xf2, 0x83, 0x89, 0xc5, 0x7c, 0x9f, 0x42, 0xbe, 0xec, 0x4e, 0xc2, 0x0d, 0xb7, 0x6a, 0x68, 0x91, 0x1c, 0x0b] as [UInt8]
        let data = Data(bytes: bytes, count: bytes.count)
        
        let m_fromString = try! Multiaddr("/ipfs/QmcgpsyWgH8Y8ajJz1Cu72KnS5uo2Aa2LpzU7kinSupNKC")
        let m_fromData = try! Multiaddr(data)
        
        XCTAssertEqual(m_fromData.description, m_fromString.description)
        XCTAssertEqual(try! m_fromData.binaryPacked(), try! m_fromString.binaryPacked())
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
        let m = try! Multiaddr("/dns4/foo.com/tcp/80/http/bar/baz.jpg")
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
        
        let m3 = try! Multiaddr("/dns4/foo.com/tcp/80/http/bar/baz.jpg")
        let decapsulated = m3.decapsulate(m1)
        XCTAssertEqual(decapsulated, try Multiaddr("/dns4/foo.com"))
    }
    
    func testCreateMultiaddrFromString_FailsWithInvalidStrings() {
        let addresses = ["notAProtocol",
                   "/ip4/tcp/alsoNotAProtocol",
                   "////ip4/tcp/21432141///",
                   "////ip4///////tcp////"]
        
        for addr in addresses {
            XCTAssertThrowsError(try Multiaddr(addr)) { error in
                print("\(addr) was invalid")
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
        let expected = "a503221220d52ebb89d85b02a284948203a62ff28389c57c9f42beec4ec20db76a68911c0b"
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
        ("testBinaryPacked_ForOnionAddress_EncodesCorrectly", testBinaryPacked_ForOnionAddress_EncodesCorrectly),
        ("testBinaryPacked_ForIpfsAddress_EncodesCorrectly", testBinaryPacked_ForIpfsAddress_EncodesCorrectly),
        ("testCreateMultiaddrFromBytes_IPv4", testCreateMultiaddrFromBytes_IPv4),
        ("testCreateMultiaddrFromBytes_TcpAddress", testCreateMultiaddrFromBytes_TcpAddress),
        ("testCreateMultiaddrFromBytes_Onion", testCreateMultiaddrFromBytes_Onion),
        ("testCreateMultiaddrFromBytes_IpfsAddress", testCreateMultiaddrFromBytes_IpfsAddress),
        ("testDnsSerialization", testDnsSerialization),

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

