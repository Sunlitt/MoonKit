//
//  EquatorialCoordinates.swift
//  
//
//  Created by Davide Biancardi on 05/11/22.
//

import Foundation
import SwiftUI


public struct EquatorialCoordinates{
    
    public var rightAscension: Angle  //alfa
    public var declination: Angle     //delta
    public var hourAngle: Angle?
    public var lstDecimal: Double?
    
    init(declination: Angle,rightAscension: Angle){
        self.declination = declination
        self.rightAscension = rightAscension
    }
    
    init(rightAscension: Angle, declination: Angle,lstDecimal: Double) {
        self.rightAscension = rightAscension
        self.declination = declination
        self.lstDecimal = lstDecimal
        var hourAngleDecimal = lstDecimal - rightAscension.degrees
        if hourAngleDecimal < 0 {
            hourAngleDecimal += 24
        }
        self.hourAngle = .init(degrees: hourAngleDecimal * 15)
    }
    
    init(declination: Angle,hourAngle: Angle,lstDecimal: Double){
            
        self.declination = declination
        self.hourAngle = hourAngle
        self.lstDecimal = lstDecimal
        self.rightAscension = .init(degrees: lstDecimal - hourAngle.degrees) 
        
    }
    
    
    
    /// Converts Equatorial coordinates to Horizon coordinates.
    ///
    /// Since horizon coordinates depend on the position, we need also longitude and latitude parameters to create an EquatorialCoordinates instance.
    ///
    /// - Parameters:
    ///   - lstDecimal: Local Sidereal Time in decimal format.
    ///   - latitude: Latitude of the observer
    ///   - longitude: Longitude of the observer
    ///
    /// - Returns: Horizon coordinates for the given latitude and longitude..
    public mutating func equatorial2Horizon(lstDecimal: Double,latitude: Angle,longitude: Angle) -> HorizonCoordinates{
        
        self.lstDecimal = lstDecimal
        
        var hourAngleDecimal = lstDecimal - rightAscension.degrees
        if hourAngleDecimal < 0 {
            hourAngleDecimal += 24
        }
        self.hourAngle = .init(degrees: hourAngleDecimal * 15)
        
       
        //Step4:
        let tZeroEquatorialToHorizon = sin(declination.radians) * sin(latitude.radians) + cos(declination.radians) * cos(latitude.radians) * cos(hourAngle!.radians)

        //Step5:
        let altitude: Angle = .init(radians: asin(tZeroEquatorialToHorizon))

        //Step6:
        let tOneEquatorialToHorizon = sin(declination.radians) - sin(latitude.radians) * sin(altitude.radians)

        //Step7
        let tTwoEquatorialToHorizon = tOneEquatorialToHorizon / (cos(latitude.radians) * cos(altitude.radians))

        //Step8
        var azimuth: Angle = .init(radians: acos(tTwoEquatorialToHorizon))
        if sin(hourAngle!.radians) >= 0{
            azimuth.degrees = 360 - azimuth.degrees
        }
        
        return .init(altitude: altitude, azimuth: azimuth)
    }
    
    
    
}
