//
//  UT_Utils.swift
//  
//
//  Created by Davide Biancardi on 09/11/22.
//

import XCTest
@testable import MoonKit


final class UT_Utils: XCTestCase {

    /// Test of mod
    func testOfmod() throws {
        
     //Test1: -100 % 4 shall be equal to 4
        //Step1: call function under test and check that it returns 4
        var a = -100
        var n = 8
        XCTAssertTrue(4 == mod(a, n))
     //Test2: -400 % 360 shall be equal to 320
        //Step1: call function under test and check that it returns 320
        a = -400
        n = 360
        XCTAssertTrue(320 == mod(a, n))
    //Test3: 270 % 180 shall be equal to 90
        //Step1: call function under test and check that it returns 90
        a = 270
        n = 180
        XCTAssertTrue(90 == mod(a, n))

    }
    
    /// Test of extendMod
    func testOfExtendedMod() throws {
                
    //Test4: -270.8 % 180 shall be equal to 89.2
        var a: Double = -270.8
        var n = 180
            
        XCTAssertTrue(abs(89.2 - extendedMod(a,n)) < 0.1)
            
    //Test2: -0.8 % 1  shall be equal to 0.2
        a = -0.8
        n = 1
        
        XCTAssertTrue(abs(0.2 - extendedMod(a,n)) < 0.1)
    
    //Test3: 390.5 % 360  shall be equal to 30.5
        a = 390.5
        n = 360
            
        XCTAssertTrue(30.5 == extendedMod(a,n))
        
    //Test4: 0.3 % 1  shall be equal to 0.3
        a = 0.3
        n = 1
                
        XCTAssertTrue(0.3 == extendedMod(a,n))
            
    //Test1: -100 % 4 shall be equal to 4
        //Step1: call function under test and check that it returns 4
        a = -100
        n = 8
        XCTAssertTrue(4 == extendedMod(a, n))
    //Test2: -400 % 360 shall be equal to 320
        //Step1: call function under test and check that it returns 320
        a = -400
        n = 360
        XCTAssertTrue(320 == extendedMod(a, n))
    //Test3: 270 % 180 shall be equal to 90
        //Step1: call function under test and check that it returns 90
        a = 270
        n = 180
        XCTAssertTrue(90 == extendedMod(a, n))
         
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


    
    /// Test of lCT2UT
    func testOflCT2UT() throws{
        
      //Test1: Convert 18h00m00s LCT to UT for an observer in the Eastern Standard Time zone (-5) shall be equal to the same date at 23h. This function needs to be tested only when usaSameTimeZone equals TRUE.
        
        //Step1: Creating 1/01/2015 18h with current time zone(i.e the one set on your device)
        let dateUnderTest = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 18, minute: 0, seconds: 0)
        let timeZoneInSecondsUnderTest = -5 * 3600
        
        //Step2: Set variable "expectedOutput" to the date 1/01/2015 23h
        let expectedOutput: Date = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 23, minute: 0, seconds: 0)
        
        //Step3: Call function under test and check that it returns a value which differs from expected output up to 2 seconds
        XCTAssertTrue(abs(expectedOutput.timeIntervalSince1970 - lCT2UT(dateUnderTest, timeZoneInSeconds: timeZoneInSecondsUnderTest,useSameTimeZone: true).timeIntervalSince1970) <= 2)
    }
      
    
    /// Test of uT2GST
    func testOfuT2GST() throws{
        
      //Test1: Convert 23h30m00s current timezone to GST for February 7, 2010. UseSameTimeZone equals TRUE.
        
        //Step1: Creating 7/02/2010 23h30m  with current time zone(i.e the one set on your device)
        var dateUnderTest = createDateCurrentTimeZone(day: 7, month: 2, year: 2010, hour: 23, minute: 30, seconds: 0)
        
        //Step2: Set variable "expectedOutput" to the expect output
        let expectedOutput: HMS = HMS.init(decimal: 8.698091)
        
        //Step3: Call function under test and check that it returns a value which differs from expected output up to 2 seconds
        XCTAssert(abs(uT2GST(dateUnderTest, useSameTimeZone: true).hMS2Decimal() - expectedOutput.hMS2Decimal()) < 0.01)
        
        //Test2: Convert 23h30m00s UT to GST for February 7, 2010. UseSameTimeZone equals False.
        
        //Step1: Creating 7/02/2010 23h30m UTC
        dateUnderTest = createDateUTC(day: 7, month: 2, year: 2010, hour: 23, minute: 30, seconds: 0)
        
        //Step3: Call function under test and check that it returns a value which differs from expected output up to 0.01
        XCTAssert(abs(uT2GST(dateUnderTest, useSameTimeZone: false).hMS2Decimal() - expectedOutput.hMS2Decimal()) < 0.01)
    }
    
    /// Test of gST2LST
    func testOfgST2LST() throws{
        
      //Test1: Converting GST to LST requires knowing an observer’s longitude. Assume that the GST is 2h03m41s  for an observer at 40° W longitude.
        
        //Step1: Creating 7/02/2010 2h03m41s with current time zone(i.e the one set on your device)
        let gstHMS: HMS = .init(hours: 2, minutes: 03, seconds: 41)
        let longitudeUnderTest: Angle = .init(degrees: -40)
        
        //Step2: Set variable "expectedOutput" to the expected output
        let expectedOutput = 23.3994722
        
        //Step3: Call function under test and check that it returns a value which differs from expected output up to 0.01
        let output = gST2LST(gstHMS, longitude: longitudeUnderTest).hMS2Decimal()
        XCTAssert(abs(expectedOutput - output) < 0.01)
        
    }
    

    
}
