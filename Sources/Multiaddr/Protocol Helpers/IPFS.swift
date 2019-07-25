import Foundation

struct IPFS {
    static func data(for address: String) -> Data {
        let addressBytes = Base58.bytesFromBase58(address)
        let sizeBytes = UInt64(addressBytes.count).varIntData()
        let combined = [Array(sizeBytes), addressBytes].flatMap {$0}
        return Data(bytes: combined, count: combined.count)
    }
    
    static func string(for data: Data) throws -> String {
        let buffer = Array(data)
        let decodedVarint = Varint.readUVarInt(from: buffer)
        let expectedSize = decodedVarint.value
        
        let addressBytes = Array(buffer[decodedVarint.bytesRead...])
        guard addressBytes.count == expectedSize else { throw MultiaddrError.ipfsAddressLengthConflict }
        
        return Base58.base58FromBytes(addressBytes)
    }
}
