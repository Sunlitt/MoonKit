//
//  UT_Moon.swift
//  
//
//  Created by Davide Biancardi on 19/11/22.
//

import XCTest
import Foundation
import CoreLocation
import SwiftUI
@testable import MoonKit

final class UT_Moon: XCTestCase {
    
    /*--------------------------------------------------------------------
     Thresholds. UTs will pass if |output - expectedOutput| < threshold
     *-------------------------------------------------------------------*/
    static let moonPercentageThreshold: Double = 0.7
    static let moonAzimuthThreshold: Double = 0.8
    static let moonAltitudeThreshold: Double = 1.2
    static let nextNewMoonAndFullMoonThreshold: Int = 2 
    static let moonSetRiseThresholdInSeconds: Double = 420  //7 minutes in seconds
    
    
    /*--------------------------------------------------------------------
     Naples timezone and location
     *-------------------------------------------------------------------*/
    static let naplesLocation: CLLocation = .init(latitude: 40.84014, longitude: 14.25226)
    static let timeZoneNaples = 1
    static let timeZoneNaplesDaylightSaving = 2
    
    /*--------------------------------------------------------------------
     Tokyo timezone and location
     *-------------------------------------------------------------------*/
    static let tokyoLocation: CLLocation = .init(latitude: 35.68946, longitude: 139.69172)
    static let timeZoneTokyo = 9
    
    /*--------------------------------------------------------------------
     Louisa USA timezone and location
     *-------------------------------------------------------------------*/
    static let louisaLocation: CLLocation = .init(latitude: 38, longitude: -78)
    static let timeZoneLouisa = -5
    static let timeZoneLouisaDaylightSaving = -4
    
    /*--------------------------------------------------------------------
     Tromso circumpolar  timezone and location
     *-------------------------------------------------------------------*/
    static let tromsoLocation: CLLocation = .init(latitude: 69.6489, longitude: 18.95508)
    static let timeZoneTromso = 1
    static let timeZoneTromsoDaylightSaving = 2
    
    /*--------------------------------------------------------------------
     Bainbridge Island
     *-------------------------------------------------------------------*/
    static let bainbridgeLocation: CLLocation = .init(latitude: 47.588889, longitude: -122.527778)
    static let timeZoneBainbridge = -8
    
    
    /// Test of  moon azimuth, moonrise, moonset, moon percentage, next new moon, moon phase and next full moon.
    /// Value for expected results have been taken from MoonCalc.org
    func testOfMoon() throws {
        
        /*--------------------------------------------------------------------
         Naples
         *-------------------------------------------------------------------*/
        
        //Test1: 19/11/22 20:00. Timezone +1. (No daylight saving)
        
        //Step1: Creating moon instance in Naples and with timezone +1
        var moonUnderTest = Moon.init(location: UT_Moon.naplesLocation, timeZone: Double(UT_Moon.timeZoneNaples))
        
        //Step2: Setting 19/11/22 20:00 as date. (No daylight saving)
        var dateUnderTest = createDateCurrentTimeZone(day: 19, month: 11, year: 2022, hour: 20, minute: 00, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        var expectedAzimuth = 349.29
        var expectedAltitude = -47.96
        var expectedMoonRise = createDateCurrentTimeZone(day: 19, month: 11, year: 2022, hour: 1, minute: 37, seconds: 0)
        var expectedMoonset = createDateCurrentTimeZone(day: 19, month: 11, year: 2022, hour: 14, minute: 28, seconds: 27)
        var expectedMoonPhase: MoonPhase = .waningCrescent
        var expectedMoonPercentage = 20.1
        var expectedNextFullMoon: Int = 18
        var expectedNextNewMoonInDays: Int = 4
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(abs(expectedMoonRise.timeIntervalSince1970 - moonUnderTest.moonRise!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedMoonset.timeIntervalSince1970 - moonUnderTest.moonSet!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
        //Test2: 2/11/22 09:31. Timezone +1. (No daylight saving). Moonset shall be NIL in this test
        
        //Step1: Creating moon instance in Naples and with timezone +1
        moonUnderTest = Moon.init(location: UT_Moon.naplesLocation, timeZone: Double(UT_Moon.timeZoneNaples))
        
        //Step2: Setting 2/11/22 09:31 as date. (No daylight saving)
        dateUnderTest = createDateCurrentTimeZone(day: 2, month: 11, year: 2022, hour: 9, minute: 31, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 64.16
        expectedAltitude = -52.91
        expectedMoonRise = createDateCurrentTimeZone(day: 2, month: 11, year: 2022, hour: 14, minute: 22, seconds: 44)
        //expectedMoonset shall be NIL
        expectedMoonPhase = .waxingGibbous
        expectedMoonPercentage = 62.3
        expectedNextFullMoon = 7
        expectedNextNewMoonInDays = 22
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(abs(expectedMoonRise.timeIntervalSince1970 - moonUnderTest.moonRise!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(nil == moonUnderTest.moonSet)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
        /*--------------------------------------------------------------------
         Tokyo
         *-------------------------------------------------------------------*/
        
        //Test: 1/08/22 16:50. Timezone +9.
        
        //Step1: Creating moon instance in Tokyo and with timezone +9
        moonUnderTest = Moon.init(location: UT_Moon.tokyoLocation, timeZone: Double(UT_Moon.timeZoneTokyo))
        
        //Step2: Setting 1/08/22 16:50 as date.
        dateUnderTest = createDateCurrentTimeZone(day: 1, month: 8, year: 2022, hour: 16, minute: 50, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 237.94
        expectedAltitude = 47.15
        expectedMoonRise = createDateCurrentTimeZone(day: 1, month: 8, year: 2022, hour: 7, minute: 44, seconds: 09)
        expectedMoonset = createDateCurrentTimeZone(day: 1, month: 8, year: 2022, hour: 20, minute: 57, seconds: 16)
        expectedMoonPhase = .waxingCrescent
        expectedMoonPercentage = 12.0
        expectedNextFullMoon = 11
        expectedNextNewMoonInDays = 26
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(abs(expectedMoonRise.timeIntervalSince1970 - moonUnderTest.moonRise!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedMoonset.timeIntervalSince1970 - moonUnderTest.moonSet!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
        /*--------------------------------------------------------------------
         Louisa USA
         *-------------------------------------------------------------------*/
        
        //Test:  1/01/15 22:00. Timezone -5.
        
        //Step1: Creating moon instance in Louisa and with timezone -5 (No daylight saving)
        moonUnderTest = Moon.init(location: UT_Moon.louisaLocation, timeZone: Double(UT_Moon.timeZoneLouisa))
        
        //Step2: Setting 1/01/15 22:00 as date. (No daylight saving)
        dateUnderTest = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 22, minute: 00, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 191.53
        expectedAltitude = 68.73
        expectedMoonRise = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 14, minute: 32, seconds: 40)
        expectedMoonset = createDateCurrentTimeZone(day: 1, month: 1, year: 2015, hour: 3, minute: 56, seconds: 37)
        expectedMoonPhase = .waxingGibbous
        expectedMoonPercentage = 90.4
        expectedNextFullMoon = 3
        expectedNextNewMoonInDays = 18
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(abs(expectedMoonRise.timeIntervalSince1970 - moonUnderTest.moonRise!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedMoonset.timeIntervalSince1970 - moonUnderTest.moonSet!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
        
        /*--------------------------------------------------------------------
         Tromso circumpolar
         *-------------------------------------------------------------------*/
        
        //Test: 19/01/22 17:31. Timezone +1. Both moonrise and moonset nil. Moon never set
        
        //Step1: Creating moon instance in Tromso and with timezone +1 (No daylight saving)
        moonUnderTest = Moon.init(location: UT_Moon.tromsoLocation, timeZone: Double(UT_Moon.timeZoneTromso))
        
        //Step2: Setting 19/01/22 17:31 as date. (No daylight saving)
        dateUnderTest = createDateCurrentTimeZone(day: 19, month: 1, year: 2022, hour: 17, minute: 31, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 58.18
        expectedAltitude = 9.02
        //expectedMoonRise shall be nil
        //expectedMoonset shall be nil
        expectedMoonPhase = .waningGibbous
        expectedMoonPercentage = 97.1
        expectedNextFullMoon = 27
        expectedNextNewMoonInDays = 13
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(nil == moonUnderTest.moonRise)
        XCTAssertTrue(nil == moonUnderTest.moonSet)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
        
        //Test: 11/07/22 12:28. Timezone +2. Both moonrise and moonset nil. Moon never rises
        
        //Step1: Creating moon instance in Tromso and with timezone +2 (daylight saving)
        moonUnderTest = Moon.init(location: UT_Moon.tromsoLocation, timeZone: Double(UT_Moon.timeZoneTromsoDaylightSaving))
        
        //Step2: Setting 19/01/22 17:31 as date. ( daylight saving)
        dateUnderTest = createDateCurrentTimeZone(day: 11, month: 7, year: 2022, hour: 12, minute: 28, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 38.55
        expectedAltitude = -42.43
        //expectedMoonRise shall be nil
        //expectedMoonset shall be nil
        expectedMoonPhase = .waxingGibbous
        expectedMoonPercentage = 91.8
        expectedNextFullMoon = 3
        expectedNextNewMoonInDays = 17
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(nil == moonUnderTest.moonRise)
        XCTAssertTrue(nil == moonUnderTest.moonSet)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
        //Test: 20/07/22 17:50.Timezone +2. Moon in last quarter
        
        //Step1: Creating moon instance in Tromso and with timezone +2 (daylight saving)
        moonUnderTest = Moon.init(location: UT_Moon.tromsoLocation, timeZone: Double(UT_Moon.timeZoneTromsoDaylightSaving))
        
        //Step2: Setting 20/07/22 17:50 as date. (daylight saving)
        dateUnderTest = createDateCurrentTimeZone(day: 20, month: 07, year: 2022, hour: 17, minute: 50, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 347.50
        expectedAltitude = -11.61
        expectedMoonRise = createDateCurrentTimeZone(day: 20, month: 07, year: 2022, hour: 22, minute: 50, seconds: 38)
        expectedMoonset = createDateCurrentTimeZone(day: 20, month: 07, year: 2022, hour: 14, minute: 06, seconds: 40)
        expectedMoonPhase = .lastQuarter
        expectedMoonPercentage = 49.5
        expectedNextFullMoon = 23
        expectedNextNewMoonInDays = 8
        
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(abs(expectedMoonRise.timeIntervalSince1970 - moonUnderTest.moonRise!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedMoonset.timeIntervalSince1970 - moonUnderTest.moonSet!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
  
        /*--------------------------------------------------------------------
         Bainbridge Island
         *-------------------------------------------------------------------*/
        
        //Test: 21/01/23 12:27. Timezone -8.
        
        //Step1: Creating moon instance in Bainbridge Island and with timezone -8)
        moonUnderTest = Moon.init(location: UT_Moon.bainbridgeLocation, timeZone: Double(UT_Moon.timeZoneBainbridge))
        
        //Step2: Setting 21/01/23 12:27 as date.
        dateUnderTest = createDateCurrentTimeZone(day: 21, month: 01, year: 2023, hour: 12, minute: 27, seconds: 00)
        moonUnderTest.setDate(dateUnderTest)
        
        //Step3: Saving expected outputs
        expectedAzimuth = 180.45
        expectedAltitude = 16.79
        expectedMoonRise = createDateCurrentTimeZone(day: 21, month: 01, year: 2023, hour: 8, minute: 19, seconds: 40)
        expectedMoonset = createDateCurrentTimeZone(day: 21, month: 01, year: 2023, hour: 16, minute: 37, seconds: 34)
        expectedMoonPhase = .newMoon
        expectedMoonPercentage = 0.2
        expectedNextFullMoon = 14
        expectedNextNewMoonInDays = 0
        
        //Step4: Check if the output are close to the expected ones
        XCTAssertTrue(expectedMoonPhase == moonUnderTest.currentMoonPhase)
        XCTAssertTrue(abs(expectedMoonPercentage - moonUnderTest.moonPercentage) <  UT_Moon.moonPercentageThreshold)
        XCTAssertTrue(abs(expectedAzimuth - moonUnderTest.azimuth) <  UT_Moon.moonAzimuthThreshold)
        XCTAssertTrue(abs(expectedAltitude - moonUnderTest.altitude) <  UT_Moon.moonAltitudeThreshold)
        XCTAssertTrue(abs(expectedMoonRise.timeIntervalSince1970 - moonUnderTest.moonRise!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedMoonset.timeIntervalSince1970 - moonUnderTest.moonSet!.timeIntervalSince1970) <  UT_Moon.moonSetRiseThresholdInSeconds)
        XCTAssertTrue(abs(expectedNextFullMoon - moonUnderTest.nextFullMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        XCTAssertTrue(abs(expectedNextNewMoonInDays - moonUnderTest.nextNewMoon) < UT_Moon.nextNewMoonAndFullMoonThreshold)
        
    }
    
    func testPerformance() throws {
        // Performance of setDate function that will refresh all the moon variables
        
        //Step1: Creating moon instance in Naples with timezone +1
        let moonUnderTest = Moon.init(location: UT_Moon.naplesLocation, timeZone: Double(UT_Moon.timeZoneNaples))
        
        //Step2: Setting 19/11/22 20:00 as date.
        let dateUnderTest = createDateCurrentTimeZone(day: 19, month: 11, year: 2022, hour: 20, minute: 00, seconds: 00)
        
        self.measure {
            moonUnderTest.setDate(dateUnderTest)
        }
    }
}
