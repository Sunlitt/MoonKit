import XCTest
@testable import MoonKit

final class UT_DMS: XCTestCase {
    
    
    /// Test of dMS2Decimal
    /// For 300° 20′ 00′′ his decimal number should be 300.3333
    func testOfdMS2Decimal(){
        
        //Step1: Creating a DMS instance of 300° 20′ 00′′
        let dmsUnderTest: DMS = .init(degrees: 300, minutes: 20, seconds: 00)
        let expectedOutput: Double = 300.3333
        
        //Step2: Call function under test and check that it returns a value close to expected output
        print(dmsUnderTest.dMS2Decimal())
        XCTAssertTrue(abs(dmsUnderTest.dMS2Decimal() - expectedOutput) < 0.01)
    }
    
    
    
}
