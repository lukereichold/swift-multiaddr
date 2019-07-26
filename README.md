# swift-multiaddr

[![](https://img.shields.io/badge/project-multiformats-blue.svg?style=flat-square)](https://github.com/multiformats/multiformats)
[![](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/lukereichold/swift-multiaddr/blob/master/LICENSE) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![SPM compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)


> [multiaddr](https://github.com/multiformats/multiaddr): Composable and future-proof network addresses, available as a modern, zero-dependency Swift library.

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Contribute](#contribute)
- [License](#license)

## Install

### Swift Package Manager

To use [Swift Package Manager](https://swift.org/package-manager/), add `Multiaddr` to your `Package.swift` file. Alternatively, [add it from Xcode directly](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/lukereichold/swift-multiaddr.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["Multiaddr"]),
    ]
)
```

Then run `swift build`.


### Carthage

To use [Carthage](https://github.com/Carthage/Carthage), add `Multiaddr` to your `Cartfile`:

```ruby
github "lukereichold/swift-multiaddr" ~> 1.0.0
```

Then run `carthage update` and use the framework in `Carthage/Build/<platform>`.


## Usage

#### Human-readable encoding
```swift
let addr = try Multiaddr("/dns6/foo.com/tcp/443/https")
dump(addr)

▿ /dns6/foo.com/tcp/443/https
  ▿ addresses : 3 elements
    ▿ 0 : /dns6/foo.com
      - addrProtocol : Multiaddr.Protocol.dns6
      ▿ address : Optional<String>
        - some : "foo.com"
    ▿ 1 : /tcp/443
      - addrProtocol : Multiaddr.Protocol.tcp
      ▿ address : Optional<String>
        - some : "443"
    ▿ 2 : /https
      - addrProtocol : Multiaddr.Protocol.https
      - address : nil
```

#### Binary encoding with packing
```swift
let serializedData = try addr.binaryPacked()
/// (`Data`) 14 bytes
```

#### Binary decoding
```swift
let addrFromData = try Multiaddr(serializedData)
/// `[Multiaddr.Address]`  3 values
```

#### Equatable Support
```swift
assert(addr == addrFromData) /// true
```

#### Protocol / address enumeration
```swift
print(addr.protocols())
/// `["dns6", "tcp", "https"]`
```

#### Encapsulate
```swift
let encapsulated = try Multiaddr("/dns4/foo.com").encapsulate("tcp/80/http/bar/baz.jpg")
print(encapsulated) /// `/dns4/foo.com/tcp/80/http/bar/baz.jpg`
```

#### Decapsulate
```swift
let tcpComponent = try Multiaddr("tcp/80")
let decapsulated = encapsulated.decapsulate(tcpComponent)
print(decapsulated) /// `/dns4/foo.com`
```

#### `pop()`
```swift
let popped = addr.pop()
Optional<Address>
  ▿ some : /https
    - addrProtocol : Multiaddr.Protocol.https
    - address : nil

```

## Contribute

Contributions welcome. Please check out [the issues](https://github.com/lukereichold/swift-multiaddr/issues).

## License

[MIT](LICENSE) © 2019 Luke Reichold
