//
//  UT_HMS.swift
//  
//
//  Created by Davide Biancardi on 09/11/22.
//

import XCTest
@testable import MoonKit

final class UT_HMS: XCTestCase {

    
    /// Test of hMS2Decimal
    /// For 10h 25m 11s  his decimal number should be 10.419722
    func testOfhMS2Decimal() throws {
        
        //Step1: Creating a HMS instance of 10h 25m 11s
        let hmsUnderTest: HMS = .init(hours: 10, minutes: 25, seconds: 11)
        let expectedOutput: Double = 10.419722
        
        //Step2: Call function under test and check that it returns a value close to expected output
        XCTAssertTrue(abs(hmsUnderTest.hMS2Decimal() - expectedOutput) < 0.01)
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
