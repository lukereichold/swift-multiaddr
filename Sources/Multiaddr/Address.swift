import Foundation

struct Address: Equatable {
    let protocolCode: Protocol
    let address: String?
}

extension Address: CustomStringConvertible {
    var description: String {
        return "/" + [protocolCode.rawValue, address].compactMap{$0}.joined(separator: "/")
    }
}
