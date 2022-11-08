//
//  DMS.swift
//  
//
//  Created by Davide Biancardi on 05/11/22.
//

import Foundation

/// DMS format to express angles
public struct DMS{
    
    public var degrees: Double
    public var minutes: Double
    public var seconds: Double
    public var isANegativeZero: Bool = false
    
    /// It converts from DMS format to decimal
    /// - Returns: DMS of the instance expressed in decimal format
    public func dMS2Decimal() -> Double {
        
        //Step1:
        let sign: Double = degrees < 0 ? -1 : 1
        //Step2:
        let degrees = abs(degrees)
        //Step3:
        let dm: Double = Double(seconds / 60)
        //Step4:
        let totalMinutes: Double = dm + Double(minutes)
        //Step5:
        var decimal: Double = totalMinutes / 60
        //Step6:
        decimal += Double(degrees)
        //Step7:
        decimal *= sign
        
        return decimal
    }
}
