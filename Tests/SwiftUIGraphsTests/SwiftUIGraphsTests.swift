import XCTest
@testable import SwiftUIGraphs

final class SwiftUIGraphsTests: XCTestCase {
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(SwiftUIGraphs().text, "Hello, World!")
//    }
    
    func testDigitsForRounding() throws {
        
        let timerInterval:TimeInterval = 11940
        let digits = timerInterval.roundingFactorDigits()
        XCTAssertEqual(digits, 3)
    }
    
    func testNearestInt() throws {
        
        let value: Int = 1900
        let fullUnit = 1800
       let rounded =  value.nearest(multipleOf: fullUnit, up: false)
        XCTAssertEqual(rounded, 1800)
    }
    
    func testRoundUp() throws {
        let doubleNumber: Double = 1900
        let digits = doubleNumber.roundingFactorDigits()
        let rounded = doubleNumber.rounded(digits: digits, base: 60, roundingRule: .up) // meaning nearest 100
        XCTAssertEqual(rounded, 12000)
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
