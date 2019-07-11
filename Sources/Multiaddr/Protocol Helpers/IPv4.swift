import Foundation
import Network

struct IPv4 {
    static func data(for string: String) throws -> Data {
        guard let addr = IPv4Address(string) else { throw MultiaddrError.parseIPv4AddressFail }
        return addr.rawValue
    }
}
