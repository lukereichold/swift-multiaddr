import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MultiaddrTests.allTests),
        testCase(ProtocolTests.allTests),
    ]
}
#endif
