import Foundation

enum MultiaddrError: Error {
    case invalidFormat
    case parseAddressFail
    case parseIPv4AddressFail
    case parseIPv6AddressFail
    case invalidPortValue
    case invalidOnionHostAddress
}
