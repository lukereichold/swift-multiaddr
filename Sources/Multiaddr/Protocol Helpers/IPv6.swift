import Foundation
import Network

struct IPv6 {
    static func data(for string: String) throws -> Data {
        guard let addr = IPv6Address(string) else { throw MultiaddrError.parseIPv6AddressFail }
        return addr.rawValue
    }
}
