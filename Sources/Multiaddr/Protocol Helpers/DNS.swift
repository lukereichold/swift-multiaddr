import Foundation

struct DNS {
    static func data(for address: String) -> Data {
        let addressBytes = Data(address.utf8)
        let sizeBytes = UInt64(addressBytes.count).varIntData()
        let combined = [Array(sizeBytes), addressBytes].compactMap {$0}
        return Data(bytes: combined, count: combined.count)
    }
    
    static func string(for data: Data) throws -> String? {
        let buffer = Array(data)
        let decodedVarint = Varint.readUVarInt(from: buffer)
        let expectedSize = decodedVarint.value
        
        let addressBytes = Array(buffer[decodedVarint.bytesRead...])
        guard addressBytes.count == expectedSize else { throw MultiaddrError.parseAddressFail }
        
        return String(data: Data(addressBytes), encoding: .utf8)
    }
}
