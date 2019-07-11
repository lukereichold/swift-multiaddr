import Foundation

struct Address: Equatable {
    let addrProtocol: Protocol
    let address: String?
    
    func binaryPacked() throws -> Data {
        let bytes = [addrProtocol.packedCode(), try binaryPackedAddress()].compactMap{$0}.flatMap{$0}
        return Data(bytes: bytes, count: bytes.count)
    }
    
    private func binaryPackedAddress() throws -> Data? {
        guard let address = address else { return nil }
        switch addrProtocol {
        case .tcp, .udp, .dccp, .sctp:
            guard let port = UInt16(address) else { throw MultiaddrError.invalidPortValue }
            var bigEndianPort = port.bigEndian
            return Data(bytes: &bigEndianPort, count: MemoryLayout<UInt16>.size)
        default:
            return nil
        }
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        return "/" + [addrProtocol.rawValue, address].compactMap{$0}.joined(separator: "/")
    }
}
