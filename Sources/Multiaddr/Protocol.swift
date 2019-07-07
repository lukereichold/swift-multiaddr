import Foundation

public enum Protocol: String, CaseIterable {
    case ip4 //= 4
    case tcp //= 6
    case udp //= 273
    case dccp// = 33
    case ip6 //= 41
    case dns4// = 54
    case dns6// = 55
    case sctp// = 132
    case udt //= 301
    case utp //= 302
    case unix// = 400
    case p2p //= 420
    case ipfs// = 421
    case http// = 480
    case https //= 443
    case onion //= 444
    case quic //= 460
    case ws// = 477
    case wss //= 478
    case Libp2pWebsocketStar //= 479
    case Libp2pWebrtcStar //= 275
    case Libp2pWebrtcDirect //= 276
    case P2pCircuit //= 290
    
//    var name: String {
//        return String(describing: self)
//    }
}

