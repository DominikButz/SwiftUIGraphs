import XCTest
@testable import SwiftUIGraphs

final class SwiftUIGraphsTests: XCTestCase {
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(SwiftUIGraphs().text, "Hello, World!")
//    }
    
    
    func testRoundUp() throws {
        let doubleNumber: Double = 14030
        let rounded = doubleNumber.rounded(digits: 3, roundingRule: .up) // meaning nearest 100
        XCTAssertEqual(rounded, 15000)
    }
    
    func testRoundDown() throws {
        let doubleNumber: Double = 152
        let rounded = doubleNumber.rounded(digits: 1, roundingRule: .down) // meaning nearest 100
        XCTAssertEqual(rounded, 150)
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
