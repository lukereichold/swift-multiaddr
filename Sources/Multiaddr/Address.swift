import Foundation

struct Address: Equatable {
    let addrProtocol: Protocol
    let address: String?
    
    func binaryPacked() -> Data {
        var data = Data()
        data.append(addrProtocol.packedCode())
        data.append(binaryPackedAddress())
        return data
    }
    
    // TODO! E.g. ports are encoded as raw numbers, whereas paths differ.
    private func binaryPackedAddress() -> Data {
        switch addrProtocol {
        default:
            return Data()
        }
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        return "/" + [addrProtocol.rawValue, address].compactMap{$0}.joined(separator: "/")
    }
}
