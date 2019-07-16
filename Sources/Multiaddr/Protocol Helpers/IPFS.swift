import Foundation

struct IPFS {
    static func data(for address: String) -> Data {
        let addressBytes = Base58.bytesFromBase58(address)
        let sizeBytes = UInt64(addressBytes.count).varIntData()
        let combined = [Array(sizeBytes), addressBytes].flatMap {$0}
        return Data(bytes: combined, count: combined.count)
    }
}
