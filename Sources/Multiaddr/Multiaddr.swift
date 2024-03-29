import Foundation

public struct Multiaddr: Equatable {
    
    public private(set) var addresses: [Address] = []
    
    public init(_ string: String) throws {
        addresses = try createAddresses(from: string)
        try validate()
    }
    
    public init(_ bytes: Data) throws {
        self.addresses = try createAddresses(fromData: bytes)
    }
    
    init(_ addresses: [Address]) {
        self.addresses = addresses
    }
    
    public func binaryPacked() throws -> Data {
        let bytes = try addresses.flatMap { try $0.binaryPacked() }
        return Data(bytes: bytes, count: bytes.count)
    }
    
    /// Returns a list of `Protocol` elements contained by this `Multiaddr`, ordered from left-to-right.
    public func protocols() -> [String] {
        return addresses.map { $0.addrProtocol.rawValue }
    }
    
    /// Wraps this `Multiaddr` with another and returns the combination.
    public func encapsulate(_ other: Multiaddr) -> Multiaddr {
        return Multiaddr(addresses + other.addresses)
    }
    
    public func encapsulate(_ other: String) throws -> Multiaddr {
        return encapsulate(try Multiaddr(other))
    }
    
    /// Returns a new `Multiaddr`, removing the specified `Multiaddr` and all subsequent addresses.
    public func decapsulate(_ other: Multiaddr) -> Multiaddr {
        let new = addresses.prefix(while: { $0 != other.addresses.first } )
        return Multiaddr(Array(new))
    }
    
    /// Removes and returns the last `Address` of this `Multiaddr`.
    public mutating func pop() -> Address? {
        return addresses.popLast()
    }
}

extension Multiaddr: CustomStringConvertible {
    public var description: String {
        return addresses.map { $0.description }.joined()
    }
}

extension Multiaddr {
    func createAddresses(from string: String) throws -> [Address] {
        var fullString = string
        guard !fullString.isEmpty, fullString.removeFirst() == "/" else { throw MultiaddrError.invalidFormat }
        var components = fullString.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
        var addresses = [Address]()
        while !components.isEmpty {
            let current = components.removeFirst()
            
            guard !current.isEmpty else { throw MultiaddrError.invalidFormat }
            guard current.isProtocol() else { continue }
            
            var addressElements = [String]()
            while let next = components.first, !next.isProtocol() {
                components.removeFirst()
                addressElements.append(next)
            }
            let newAddress = Address(addrProtocol: Protocol(rawValue: current)!, address: addressElements.combined())
            addresses.append(newAddress)
        }
        return addresses
    }
    
    func createAddresses(fromData data: Data) throws -> [Address] {
        var buffer = Array(data)
        var addresses = [Address]()
        
        while !buffer.isEmpty {
            let decodedVarint = Varint.readUVarInt(from: buffer)
            precondition(decodedVarint.bytesRead >= 0, "Varint size must not exceed 64 bytes.")
            
            buffer.removeFirst(decodedVarint.bytesRead)
                
            guard let proto = Protocol.forCode(Int(decodedVarint.value)) else { throw MultiaddrError.unknownProtocol }

            if case .zero = proto.size() {
                addresses.append(Address(addrProtocol: proto))
                continue
            }
            
            let addressSize = Address.byteSizeForAddress(proto, buffer: buffer)
            let addressBytes = Data(buffer.prefix(addressSize))
            let address = Address(addrProtocol: proto, addressData: addressBytes)
            addresses.append(address)
            
            buffer.removeFirst(addressSize)
        }
        
        return addresses
    }
    
    /// If we're able to serialize the `Multiaddr` created from a string without error, consider it valid.
    func validate() throws {
        _ = try binaryPacked()
    }
}

extension Array where Element == String {
    func combined() -> String? {
        guard !isEmpty else { return nil }
        return joined(separator: "/")
    }
}

