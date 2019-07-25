import Foundation

struct Address: Equatable {
    let addrProtocol: Protocol
    var address: String?
    
    init(addrProtocol: Protocol, addressData: Data) {
        self.addrProtocol = addrProtocol
        self.address = try? unpackAddress(addressData)
    }
    
    init(addrProtocol: Protocol, address: String? = nil) {
        self.addrProtocol = addrProtocol
        self.address = address
    }
    
    func binaryPacked() throws -> Data {
        let bytes = [addrProtocol.packedCode(), try binaryPackedAddress()].compactMap{$0}.flatMap{$0}
        return Data(bytes: bytes, count: bytes.count)
    }
}

extension Address {
    
    private func unpackAddress(_ addressData: Data) throws -> String? {
        switch addrProtocol {
        case .ip4:
            return try IPv4.string(for: addressData)
        case .ip6:
            return try IPv6.string(for: addressData)
        default:
            return ""
        }
    }
    
    private func binaryPackedAddress() throws -> Data? {
        guard let address = address else { return nil }
        switch addrProtocol {
        case .tcp, .udp, .dccp, .sctp:
            guard let port = UInt16(address) else { throw MultiaddrError.invalidPortValue }
            var bigEndianPort = port.bigEndian
            return Data(bytes: &bigEndianPort, count: MemoryLayout<UInt16>.size)
        case .ip4:
            return try IPv4.data(for: address)
        case .ip6:
            return try IPv6.data(for: address)
        case .onion:
            return try Onion.data(for: address)
        case .ipfs:
            return IPFS.data(for: address)
        case .dns4, .dns6, .dnsaddr:
            return Data(address.utf8)
        case .http, .https, .utp, .udt:
            return nil
        default:
            throw MultiaddrError.parseAddressFail
        }
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        return "/" + [addrProtocol.rawValue, address].compactMap{$0}.joined(separator: "/")
    }
}
