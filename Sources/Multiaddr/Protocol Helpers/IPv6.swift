import Foundation
import Network

struct IPv6 {
    static func data(for string: String) throws -> Data {
        guard let addr = IPv6Address(string) else { throw MultiaddrError.parseIPv6AddressFail }
        return addr.rawValue
    }
    
    static func string(for data: Data) throws -> String {
        guard data.count == MemoryLayout<in6_addr>.size else {
            throw MultiaddrError.parseIPv4AddressFail
        }
        var address = data.withUnsafeBytes { (bytesPointer: UnsafePointer<UInt8>) -> in6_addr in
            bytesPointer.withMemoryRebound(to: in6_addr.self, capacity: 1) { $0.pointee }
        }
        
        var output = Data(count: Int(INET6_ADDRSTRLEN))
        guard let presentationBytes = output.withUnsafeMutableBytes({
            inet_ntop(AF_INET6, &address, $0, socklen_t(INET6_ADDRSTRLEN))
        }) else {
            return "Invalid IPv6 address"
        }
        return String(cString: presentationBytes)
    }
}
