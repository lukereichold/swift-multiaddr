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

To use [Swift Package Manager](https://swift.org/package-manager/), add `Multiaddr` to your `Package.swift` file:

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

```swift
Coming Soon -- see Multiaddr.playground
```

## Contribute

Contributions welcome. Please check out [the issues](https://github.com/lukereichold/swift-multiaddr/issues).

## License

[MIT](LICENSE) © 2019 Luke Reichold
