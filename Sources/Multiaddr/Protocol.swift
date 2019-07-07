import Foundation

enum Protocol: String, CaseIterable {
    case ip4
    case tcp
    case udp
    case dccp
    case ip6
    case dns4
    case dns6
    case sctp
    case udt
    case utp
    case unix
    case p2p
    case ipfs
    case http
    case https
    case onion
    case quic
    case ws
    case wss
    case Libp2pWebsocketStar
    case Libp2pWebrtcStar
    case Libp2pWebrtcDirect
    case P2pCircuit
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
        case .dns4:
            return 54
        case .dns6:
            return 55
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
        case .quic:
            return 460
        case .ws:
            return 477
        case .wss:
            return 478
        case .Libp2pWebsocketStar:
            return 479
        case .Libp2pWebrtcStar:
            return 275
        case .Libp2pWebrtcDirect:
            return 276
        case .P2pCircuit:
            return 290
        }
    }
}

