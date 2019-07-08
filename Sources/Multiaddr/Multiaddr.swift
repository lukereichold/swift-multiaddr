import Foundation

typealias Bytes = [UInt8]

struct Multiaddr: Equatable {
    
    var addresses: [Address] = []
    
    init(_ string: String) throws {
       addresses = try createAddresses(from: string)
    }
    
    init?(_ bytes: Bytes) {
        // TODO: ..
    }
    
    init(_ addresses: [Address]) {
        self.addresses = addresses
    }
    
    func bytes() -> Data {
        return Data() // TODO: Binary-packed form
    }
    
    func encapsulate(_ other: Multiaddr) -> Multiaddr {
        return Multiaddr(addresses + other.addresses)
    }
    
    func encapsulate(_ other: String) throws -> Multiaddr {
        return encapsulate(try Multiaddr(other))
    }
    
//    func decapsulate(_ other: Multiaddr) {
//
//    }
}

extension Multiaddr: CustomStringConvertible {
    var description: String {
        return addresses.map { $0.description }.joined()
    }
}

extension Multiaddr {
    func createAddresses(from string: String) throws -> [Address] {
        guard string.first == "/" else { throw MultiaddrError.invalidFormat }
        var components = string.split(separator: "/").map(String.init)
        var addresses = [Address]()
        while !components.isEmpty {
            let current = components.removeFirst()
            
            guard current.isProtocol() else { continue }
            
            var addressElements = [String]()
            while let next = components.first, !next.isProtocol() {
                components.removeFirst()
                addressElements.append(next)
            }
            let newAddress = Address(protocolCode: Protocol(rawValue: current)!, address: addressElements.combined())
            addresses.append(newAddress)
        }
        return addresses
    }
}

extension Array where Element == String {
    func combined() -> String? {
        guard !isEmpty else { return nil }
        return joined(separator: "/")
    }
}

extension String {
    func isProtocol() -> Bool {
        return Protocol.allCases.map{$0.rawValue}.contains(self)
    }
}
