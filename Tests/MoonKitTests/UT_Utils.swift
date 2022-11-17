//
//  UT_Utils.swift
//  
//
//  Created by Davide Biancardi on 09/11/22.
//

import XCTest
@testable import MoonKit

final class UT_Utils: XCTestCase {

   
    /// Test of dMS2Decimal
    /// Test 1 for decimal equals 10.2958 the DMS value should be equals to 10° 17' 44.88''
    /// Test 2 for decimal equals 0.508333  the DMS value should be equals to −0°30′30′′
    func testOfdecimal2DMS() throws {
        
      //Test1:
        //Step1: Set decimal value equals 10.2958
        var decimal = 10.2958
        //Step2: Call function under test
        var dms = decimal2DMS(decimal)
        //Step3: Check if the the values set is inside the correct range
        XCTAssertTrue((dms.degrees == 10) && (dms.minutes == 17) && (44.87...44.88).contains(dms.seconds))
      //Test2:
        //Step4: Set decimal value equals 10.2958
        decimal = 0.508333
        //Step5: Call function under test
        dms = decimal2DMS(decimal)
        //Step6: Check if the the values set is inside the correct range and if isANegativeZero equals true
        XCTAssertTrue((dms.degrees == 0) && (dms.minutes == 30) && (round(dms.seconds) == 30) && dms.isANegativeZero)
        
    }
    
    /// Test of dMS2Decimal
    /// For decimal equals 20.352 the DMS value should be equals to 20h 21m 7.2s
    func testOfdecimal2HMS() throws {
        
      //Test1:
        //Step1: Set decimal value equals 20.352
        let decimal = 20.352
        //Step2: Call function under test
        let hms = decimal2HMS(decimal)
        //Step3: Check if the the values set is inside the correct range
        XCTAssertTrue((hms.hours == 20) && (hms.minutes == 21) && (7.1...7.3).contains(hms.seconds))
    }
    
    /// Test of mod
    func testOfmod() throws {
        
     //Test1: -100 % 4 shall be equal to 4
        //Step1: call function under test and check that it returns 4
        var a = -100
        var n = 8
        XCTAssertTrue(4 == mod(a, n))
     //Test1: -400 % 360 shall be equal to 320
        //Step1: call function under test and check that it returns 320
        a = -400
        n = 360
        XCTAssertTrue(320 == mod(a, n))
    //Test1: 270 % 180 shall be equal to 90
        //Step1: call function under test and check that it returns 90
        a = 270
        n = 180
        XCTAssertTrue(90 == mod(a, n))
    }
    
    /// Test of jdFromDate
    func testOfjdFromDate() throws{
        
      //Test1:  For 5/6/2010 at noon UT, his JD number shall be 2455323.0
        //Step1: Creating UTC date
        let dateUnderTest = createDateUTC(day: 6, month: 5, year: 2010, hour: 12, minute: 0, seconds: 0)
        
        //Step2:Call function under test, check that it returns expected output
        XCTAssertTrue(2455323.0 == jdFromDate(date: dateUnderTest))
    }
    
    /// Test of dateFromJD
    func testOfdateFromJD() throws{
        
      //Test1: 2455323.0 Jd number shall be quals to date 5/6/2010 at noon UT
        //Step1: Creating jd number under test
        let jdNumberTest = 2455323.0
        
        //Step2:Call function under test, check that it returns expected output
        let expectedOutput = createDateUTC(day: 6, month: 5, year: 2010, hour: 12, minute: 0, seconds: 0)
        XCTAssertTrue(expectedOutput == dateFromJd(jd: jdNumberTest))
    }

    /// Test of decimal2Date
    func testOfdecimal2Date() throws{
        
      //Test1: 20.352h of 1 january 2015 shall returns date 01/01/2015 20:21:07
        //Step1: Creating decimalNumberUnderTest
        let decimalNumberUnderTest = 20.352
        
        //Step2:Call function under test, check that it returns expected output
        let expectedOutput = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 20, minute: 21, seconds: 7)
    
        XCTAssertTrue(expectedOutput == decimal2Date(decimalNumberUnderTest, day: 1, month: 1, year: 2015))
    }
    
    /// Test of lCT2UT
    func testOflCT2UT() throws{
        
      //Test1: 18h00m00s LCT to UT for an observer in the Eastern Standard Time zone (-5) shall be equals to 23h.
        
        //Step1: Creating 1/01/2015 18h with current time zone(i.e the one set on your device)
        let dateUnderTest = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 18, minute: 0, seconds: 0)
        let timeZoneInSecondsUnderTest = -5 * 3600
        
        //Step2: Set variable "expectedOutput" to the date 1/01/2015 23h
        let expectedOutput: Date = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 23, minute: 0, seconds: 0)
        
        //Step3: Call function under test and check that it returns expected output
        XCTAssertTrue(expectedOutput == lCT2UT(dateUnderTest, timeZoneInSeconds: timeZoneInSecondsUnderTest))
    }
    
    

}
