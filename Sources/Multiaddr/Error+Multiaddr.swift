import Foundation

enum MultiaddrError: Error {
    case invalidFormat
    case parseAddressFail
    case invalidPortValue
}
