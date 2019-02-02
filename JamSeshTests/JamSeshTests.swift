//
//  JamSeshTests.swift
//  JamSeshTests
//
//  Created by Mac Macoy on 11/21/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import XCTest
@testable import JamSesh

class JamSeshTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
    }
    
    func capoTest() {
        let chord = Chord(name: "C#", capo: 1)
        assert(chord.name == "D")
    }

}
