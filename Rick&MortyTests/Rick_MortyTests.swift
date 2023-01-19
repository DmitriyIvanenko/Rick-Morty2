//
//  Rick_MortyTests.swift
//  Rick&MortyTests
//
//  Created by Dmytro Ivanenko on 19.01.2023.
//

import XCTest
@testable import Rick_Morty

final class Rick_MortyTests: XCTestCase {
    
    func keyNotFound(
        codingPath: [CodingKeys(stringValue: "results", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)],
                     debugDescription: "No value associated with key CodingKeys(stringValue: \"character\", intValue: nil) (\"character\").",
                     underlyingError: nil) {
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
