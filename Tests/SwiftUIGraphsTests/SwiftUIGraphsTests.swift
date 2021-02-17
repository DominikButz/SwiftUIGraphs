import XCTest
@testable import SwiftUIGraphs

final class SwiftUIGraphsTests: XCTestCase {
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(SwiftUIGraphs().text, "Hello, World!")
//    }
    

    
    func testNearestInt() throws {
        
        let value: Int = 12
        let fullUnit:UInt = 10
       let rounded =  value.nearest(multipleOf: fullUnit, up: true)
        XCTAssertEqual(rounded, 20)
    }
    

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
