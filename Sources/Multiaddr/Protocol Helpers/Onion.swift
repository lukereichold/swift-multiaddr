import Foundation

struct Onion {
    static func data(for string: String) throws -> Data {
        let components = string.split(separator: ":").map(String.init)
        guard components.count == 2 else { throw MultiaddrError.invalidFormat }

        guard let host = components.first?.uppercased(),
            host.count == 16,
            let port =  components.last
        else {
            throw MultiaddrError.invalidOnionHostAddress
        }
        
        guard let portValue = UInt16(port) else { throw MultiaddrError.invalidPortValue }

        guard var onionData = base32DecodeToData(host) else { throw MultiaddrError.invalidOnionHostAddress }
        
        var bigEndianPort = portValue.bigEndian
        let portData = Data(bytes: &bigEndianPort, count: MemoryLayout<UInt16>.size)
  
        onionData.append(portData)
        return onionData
    }
    
    static func string(for data: Data) throws -> String {
        guard data.count == 12 else { throw MultiaddrError.invalidOnionHostAddress }
        let addressBytes = data.prefix(10)
        let portBytes = data.suffix(2)
        
        let addressEncodedString = base32Encode(addressBytes).lowercased()
        let portString = String(portBytes.uint16.bigEndian)
        return "\(addressEncodedString):\(portString)"
    }
}
