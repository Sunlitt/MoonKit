//
//  Extensions.swift
//  
//
//  Created by Davide Biancardi on 05/11/22.
//

import Foundation

//It consents us too loop between two dates for n as interval time
extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}
