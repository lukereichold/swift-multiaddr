import Foundation

typealias Bytes = [UInt8]

struct Address: Equatable {
    let protocolCode: Protocol
    let address: String?
}

struct Multiaddr {
    
    private(set) var addresses: [Address] = []
    
    init(_ string: String) throws {
       addresses = try createAddresses(from: string)
    }
    
    init?(_ bytes: Bytes) {
        // TODO: ..
    }
    
    func bytes() -> Data {
        // don't worry about the binary packed version yet!
        return Data()
    }
    
    // Aka "Append" to end
    func encapsulate(_ protocol: Protocol) {
        
    }
}

extension Multiaddr: CustomStringConvertible {
    var description: String {
        return ""
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

extension Multiaddr: Equatable {
    static func == (lhs: Multiaddr, rhs: Multiaddr) -> Bool {
        return true // TODO
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
