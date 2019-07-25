import Foundation
import Network

struct IPv4 {
    static func data(for string: String) throws -> Data {
        guard let addr = IPv4Address(string) else { throw MultiaddrError.parseIPv4AddressFail }
        return addr.rawValue
    }
    
    static func string(for data: Data) throws -> String {
        guard data.count == MemoryLayout<UInt32>.size else {
            throw MultiaddrError.parseIPv4AddressFail
        }
        var output = Data(count: Int(INET_ADDRSTRLEN))
        var address = in_addr(s_addr: data.uint32)
        
        guard let presentationBytes = output.withUnsafeMutableBytes({
            inet_ntop(AF_INET, &address, $0, socklen_t(INET_ADDRSTRLEN))
        }) else {
            return "Invalid IPv4 address"
        }
        return String(cString: presentationBytes)
    }
}

extension Data {
    var uint32: UInt32 {
        return withUnsafeBytes {
            $0.load(as: UInt32.self)
        }
    }
}
