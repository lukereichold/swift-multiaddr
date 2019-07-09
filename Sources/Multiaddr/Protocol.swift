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

extension Protocol {
    func size() -> Int {
        switch self {
        case .ip4:
            return 32
        case .tcp:
            return 16
        default:
            return 0 // TODO
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

