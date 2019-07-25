import Foundation

extension Data {
    var uint16: UInt16 {
        return withUnsafeBytes {
            $0.load(as: UInt16.self)
        }
    }
}
