import Foundation

enum Protocol: String, CaseIterable {
    case ip4
    case tcp
    case udp
    case dccp
    case ip6
    case ip6zone
    case dns4
    case dns6
    case dnsaddr
    case sctp
    case udt
    case utp
    case unix
    case p2p
    case ipfs
    case http
    case https
    case onion
    case onion3
    case garlic64
    case garlic32
    case quic
    case ws
    case wss
    case p2pWebsocketStar
    case p2pWebrtcStar
    case p2pWebrtcDirect
    case p2pCircuit
    case memory
}

enum BitSize {
    case fixed(bits: Int)
    case variable
    case zero
}

extension Protocol {
    /// The number of bits that an address of this protocol will consume.
    func size() -> BitSize {
        switch self {
        case .ip4:
            return .fixed(bits: 32)
        case .tcp, .udp, .dccp, .sctp:
            return .fixed(bits: 16)
        case .ip6:
            return .fixed(bits: 128)
        case .onion:
            return .fixed(bits: 96)
        case .onion3:
            return .fixed(bits: 296)
        case .ipfs, .dns4, .dns6, .unix, .p2p:
            return .variable
        default:
            return .zero
        }
    }
    
    func packedCode() -> Data {
        return UInt64(code()).varIntData()
    }
    
    func code() -> Int {
        switch self {
        case .ip4:
            return 4
        case .tcp:
            return 6
        case .udp:
            return 273
        case .dccp:
            return 33
        case .ip6:
            return 41
        case .ip6zone:
            return 42
        case .dns4:
            return 54
        case .dns6:
            return 55
        case .dnsaddr:
            return 56
        case .sctp:
            return 132
        case .udt:
            return 301
        case .utp:
            return 302
        case .unix:
            return 400
        case .p2p:
            return 420
        case .ipfs:
            return 421
        case .http:
            return 480
        case .https:
            return 443
        case .onion:
            return 444
        case .onion3:
            return 445
        case .garlic64:
            return 446
        case .garlic32:
            return 447
        case .quic:
            return 460
        case .ws:
            return 477
        case .wss:
            return 478
        case .p2pWebsocketStar:
            return 479
        case .p2pWebrtcStar:
            return 275
        case .p2pWebrtcDirect:
            return 276
        case .p2pCircuit:
            return 290
        case .memory:
            return 777
        }
    }
}

extension Protocol {
    static func forCode(_ code: Int) -> Protocol? {
        return Protocol.allCases.first(where: {$0.code() == code})
    }
}

// MARK: - Helpers

extension String {
    func isProtocol() -> Bool {
        return Protocol.allCases.map{$0.rawValue}.contains(self)
    }
}
