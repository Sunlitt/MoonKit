//
//  UT_MoonPhase.swift
//  
//
//  Created by Davide Biancardi on 17/11/22.
//

import XCTest
@testable import MoonKit

final class UT_MoonPhase: XCTestCase {
    
    /// Test of ageOfTheMoonDegrees2MoonPhase
    func testOfageOfTheMoonDegrees2MoonPhase() throws{
        
        var ageOfTheMoonInDegreesUnderTest: Double = .zero
        
        //Test1: New moon phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = .zero
        //Step2:
        XCTAssertTrue(.newMoon == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 1
        //Step4:
        XCTAssertTrue(.newMoon != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 359
        //Step6:
        XCTAssertTrue(.newMoon != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step7:
        ageOfTheMoonInDegreesUnderTest = 359.5
        //Step8:
        XCTAssertTrue(.newMoon == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        //Test2: Waxing Crescent phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 1
        //Step2:
        XCTAssertTrue(.waxingCrescent == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 89
        //Step4:
        XCTAssertTrue(.waxingCrescent == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 90
        //Step6:
        XCTAssertTrue(.waxingCrescent != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        
        //Test3: First Quarter phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 90
        //Step2:
        XCTAssertTrue(.firstQuarter == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 89
        //Step4:
        XCTAssertTrue(.firstQuarter != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 91
        //Step6:
        XCTAssertTrue(.firstQuarter != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        //Test4: Waxing Gibbous phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 91
        //Step2:
        XCTAssertTrue(.waxingGibbous == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 170
        //Step4:
        XCTAssertTrue(.waxingGibbous == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 180
        //Step6:
        XCTAssertTrue(.waxingGibbous != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        //Test5: Full Moon phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 190
        //Step2:
        XCTAssertTrue(.fullMoon != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 170
        //Step4:
        XCTAssertTrue(.fullMoon != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 180
        //Step6:
        XCTAssertTrue(.fullMoon == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        //Test6: Waning Gibbous phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 190
        //Step2:
        XCTAssertTrue(.waningGibbous == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 269
        //Step4:
        XCTAssertTrue(.waningGibbous == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 180
        //Step6:
        XCTAssertTrue(.waningGibbous != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        //Test7: Last Quarter phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 270
        //Step2:
        XCTAssertTrue(.lastQuarter == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 271
        //Step4:
        XCTAssertTrue(.lastQuarter != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 269
        //Step6:
        XCTAssertTrue(.lastQuarter != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
      
        //Test7: Waning Crescent phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = 359
        //Step2:
        XCTAssertTrue(.waningCrescent == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step3:
        ageOfTheMoonInDegreesUnderTest = 271
        //Step4:
        XCTAssertTrue(.waningCrescent == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        //Step5:
        ageOfTheMoonInDegreesUnderTest = 200
        //Step6:
        XCTAssertTrue(.waningCrescent != MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
        
        //Test8: Error phase
        
        //Step1:
        ageOfTheMoonInDegreesUnderTest = -5
        //Step2:
        XCTAssertTrue(.error == MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonInDegreesUnderTest))
            
    }
}
