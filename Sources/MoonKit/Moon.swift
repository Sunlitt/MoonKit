//
//  Moon.swift
//  
//
//  Created by Davide Biancardi on 05/11/22.
//

import Foundation
import CoreLocation
import SwiftUI


public class Moon {
    
    /*--------------------------------------------------------------------
     Public get Variables
     *-------------------------------------------------------------------*/
    public private(set) var location: CLLocation
    public private(set) var timeZone: Double
    public private(set) var date: Date = Date()
    
    ///Date  of moonrise in local timezone, nill if moonrise not found
    public private(set) var moonRise: Date?
    ///Date  of moonset in local timezone, nill if moonset not found
    public private(set) var moonSet: Date?
    ///Azimuth of moonrise, nill if moonrise not found
    public private(set) var moonriseAzimuth: Double?
    ///Azimuth of moonset, nill if moonset not found
    public private(set) var moonsetAzimuth: Double?
    
    public private(set) var moonPercentage: Double = 0
    public private(set) var ageOfTheMoonInDays: Double = 0
    
    
    public static let common: Moon = {
        return Moon(location: CLLocation(latitude: 37.334886, longitude: -122.008988), timeZone: -7)
    } ()
    
    public var azimuth: Double {
        return self.moonHorizonCoordinates.azimuth.degrees
    }
    
    public var altitude: Double {
        return self.moonHorizonCoordinates.altitude.degrees
    }
    
    public var longitude: Angle {
        return .init(degrees: self.location.coordinate.longitude)
    }
    
    public var latitude: Angle {
        return .init(degrees: self.location.coordinate.latitude)
    }
    ///Needed to know in which phase the moon is
    public var ageOfTheMoonDegress: Double {
        return  12.1907 * ageOfTheMoonInDays
    }
    
    public var currentMoonPhase: MoonPhase {
        return MoonPhase.ageOfTheMoonDegrees2MoonPhase(ageOfTheMoonDegress)
    }
    
    ///Number of days since the date selected in which there will be a full moon
    public var nextFullMoon: Int {
        return  mod(Int(round(14.8 - ageOfTheMoonInDays)),29)
    }
    
    ///Number of days since the date selected in which there will be a new moon
    public var nextNewMoon: Int {
        return  Int(round(29.5 - ageOfTheMoonInDays))
    }
    
        
    /*--------------------------------------------------------------------
     Private Variables
     *-------------------------------------------------------------------*/
    private var calendar: Calendar = .init(identifier: .gregorian)
    private var timeZoneInSeconds: Int {
        Int(timeZone * 3600)
    }
    private var moonHorizonCoordinates: HorizonCoordinates = .init(altitude: .zero, azimuth: .zero)
    private var moonEquatorialCoordinates: EquatorialCoordinates = .init(declination: .zero)
    private var moonEclipticCoordinates: EclipticCoordinates = .init(eclipticLatitude: .zero, eclipticLongitude: .zero)
    
    //Moon constants
    private let moonEclipticLongitudeAtTheEpoch: Angle = .init(degrees: 218.316433)
    private let moonEclipticLongitudePerigee: Angle = .init(degrees: 83.353451)
    private let moonEclipticLongitudeAscendingNodeStandarEpoch: Angle = .init(degrees: 125.044522)
    private let inclinationMoon : Angle = .init(degrees: 5.1453964)
    
    //Sun constants
    private let sunEclipticLongitudeAtTheEpoch: Angle = .init(degrees: 280.466069)
    private let sunEclipticLongitudePerigee: Angle = .init(degrees: 282.938346)
    
    //Variables needed to compute moon percentage and moon age in days
    private var moonTrueEclipticLongitudeGlobal: Angle = .zero
    private var sunEclipticLongitudeGlobal: Angle = .zero
    
    
    /*--------------------------------------------------------------------
     Public methods
     *-------------------------------------------------------------------*/
    
    public init(location: CLLocation,timeZone: Double) {
        self.timeZone = timeZone
        self.location = location
        refresh()
    }
    
    public func setDate(_ newDate: Date) {
        date = newDate
        refresh()
    }
    
    public func setLocation(_ newLocation: CLLocation) {
        location = newLocation
        refresh()
    }
    
    public func setTimeZone(_ newTimeZone: Double) {
        timeZone = newTimeZone
        refresh()
    }
    
    /*--------------------------------------------------------------------
     Private methods
     *-------------------------------------------------------------------*/
    
    
    /// Updates in order all the moon coordinates: horizon, ecliptic and equatorial.
    /// Then get rise and set times.
    /// then update the moon percentage and age of the moon in days
    private func refresh(){
        updateMoonCoordinates()
        updateMoonPercentage()
        getRiseAndSetDates()
    }
    
    private func getSunMeanAnomaly(from elapsedDaysSinceStandardEpoch: Double) -> Angle{
        
        //Compute mean anomaly sun
        var sunMeanAnomaly: Angle  = .init(degrees:(((360.0 * elapsedDaysSinceStandardEpoch) / 365.242191) + sunEclipticLongitudeAtTheEpoch.degrees - sunEclipticLongitudePerigee.degrees))
        
        sunMeanAnomaly = .init(degrees: Double(Int(sunMeanAnomaly.degrees) % 360) + sunMeanAnomaly.degrees.truncatingRemainder(dividingBy: 1))
        
        return sunMeanAnomaly
    }
    
    private func getSunEclipticLongitude(from sunMeanAnomaly: Angle) -> Angle{
        
        //eclipticLatitude
        let equationOfCenter = 360 / Double.pi * sin(sunMeanAnomaly.radians) * 0.016708
        
        let trueAnomaly = sunMeanAnomaly.degrees + equationOfCenter
        
        var eclipticLatitude: Angle =  .init(degrees: trueAnomaly + sunEclipticLongitudePerigee.degrees)
        
        if eclipticLatitude.degrees > 360 {
            eclipticLatitude.degrees -= 360
        }
        
        return eclipticLatitude
    }
    
    
    /// Updates Horizon coordinates, Ecliptic coordinates and Equatorial coordinates of the moon
    private func updateMoonCoordinates(){
        
        
        //Step1:
        //Convert LCT to UT, GST, and LST times and adjust the date if needed
        let utDate = lCT2UT(self.date, timeZoneInSeconds: self.timeZoneInSeconds)
        let gstDate = uT2GST(utDate)
        let lstDate = gST2LST(gstDate,longitude: longitude)
        
        let lstDecimal = HMS.init(from: lstDate).hMS2Decimal()
        let utHMS = HMS.init(from: utDate)
        
        //Step2:
        //Compute TT
        var ttHMS = utHMS
        ttHMS.seconds += 63.8
        let ttDecimal = ttHMS.hMS2Decimal()
        
        //Step3:
        //Julian number for standard epoch 2000
        let jdEpoch = 2451545.00
        
        //Step4:
        //Compute the Julian day number for the desired date using the Greenwich date and TT
        
        ttHMS = HMS.init(decimal: ttDecimal)
        
        let utDay = calendar.component(.day, from: utDate)
        let utMonth = calendar.component(.month, from: utDate)
        let utYear = calendar.component(.year, from: utDate)
        let nanoseconds = Int(ttHMS.seconds.truncatingRemainder(dividingBy: 1) * 100)
        
        
        let ttDate = createDateUTC(day: utDay , month: utMonth, year: utYear, hour: Int(ttHMS.hours), minute: Int(ttHMS.minutes), seconds: Int(ttHMS.seconds), nanosecond: nanoseconds)
        
        let jdTT = jdFromDate(date: ttDate)
        
        //Step5:
        //Compute the total number of elapsed days, including fractional days, since the standard epoch (i.e., JD − JDe)
        let elapsedDaysSinceStandardEpoch: Double = jdTT - jdEpoch //De
        
        //Step6: Use the algorithm from section 6.2 to calculate the Sun’s ecliptic longitude and mean anomaly for the given UT date and time.
        let sunMeanAnomaly = getSunMeanAnomaly(from: elapsedDaysSinceStandardEpoch)
        
        sunEclipticLongitudeGlobal = getSunEclipticLongitude(from: sunMeanAnomaly)
        
        
        //Step7: Apply equation to calculate the Moon’s (uncorrected) mean ecliptic longitude.
        var meanEclipticLongitude: Angle = .init(degrees: 13.176339686 * elapsedDaysSinceStandardEpoch + moonEclipticLongitudeAtTheEpoch.degrees)
        
        //Step8: If necessary,usetheMODfunctiontoputλintotherange[0◦,360◦]
        meanEclipticLongitude = .init(degrees: Double(mod(Int(meanEclipticLongitude.degrees),360)) + meanEclipticLongitude.degrees.truncatingRemainder(dividingBy: 1))
        
        //Step9: Apply equation  to compute the Moon’s (uncorrected) mean ecliptic longitude of the ascending node
        var meanEclipticLongitudeAscndingNode: Angle = .init(degrees: moonEclipticLongitudeAscendingNodeStandarEpoch.degrees -  0.0529539 * elapsedDaysSinceStandardEpoch)
        
        //Step10: If necessary, adjust to be in the range [0◦ , 360◦ ] (i.e., MOD 360°)
        meanEclipticLongitudeAscndingNode = .init(degrees: Double(mod(Int(meanEclipticLongitudeAscndingNode.degrees),360)) +
                                                  meanEclipticLongitudeAscndingNode.degrees.truncatingRemainder(dividingBy: 1))
        
        //Step11: Apply equation to compute the Moon’s(uncorrected) mean anomaly
        var moonMeanAnomaly: Angle = .init(degrees: meanEclipticLongitude.degrees - 0.1114041 * elapsedDaysSinceStandardEpoch - moonEclipticLongitudePerigee.degrees)
        
        //Step12: Adjust Mm if necessary to be in the range [0◦, 360◦]
        moonMeanAnomaly = .init(degrees: Double(mod(Int(moonMeanAnomaly.degrees),360)) + moonMeanAnomaly.degrees.truncatingRemainder(dividingBy: 1))
        
        //Step13: Use equation to compute the annual equation correction
        let annualEquationCorrection: Angle = .init(degrees: 0.1858 * sin(sunMeanAnomaly.radians))
        
        
        //Step14: Use equation  to compute the evection correction
        let evection: Angle = .init(degrees: 1.2739 * sin(2 * (meanEclipticLongitude.radians - sunEclipticLongitudeGlobal.radians) - moonMeanAnomaly.radians))
        
        
        //Step15: Use equation to compute the mean anomaly correction
        let meanAnomalyCorrection: Angle = .init(degrees: moonMeanAnomaly.degrees + evection.degrees - annualEquationCorrection.degrees - 0.37 * sin(sunMeanAnomaly.radians))
        
        
        //Step16: Use equation to compute the Moon’s true anomaly
        let moonTrueAnomaly: Angle = .init(degrees: 6.2886 * sin(meanAnomalyCorrection.radians) + 0.214 * sin(2 * meanAnomalyCorrection.radians))
        
        
        //Step17:Use equation 7.3.9 to apply all of the applicable corrections and the true anomaly to arrive at a corrected mean ecliptic longitude
        let correctedMeanEclipticLongitude: Angle = .init(degrees: meanEclipticLongitude.degrees + evection.degrees + moonTrueAnomaly.degrees - annualEquationCorrection.degrees)
        
        
        //Step18: Use equation to compute the variation correction
        let variationCorrection: Angle = .init(degrees: 0.6583 * sin(2*(correctedMeanEclipticLongitude.radians - sunEclipticLongitudeGlobal.radians)))
        
        //Step19: Apply equation 7.3.10 to calculate the Moon’s true ecliptic longitude.
        let moonTrueEclipticLongitude: Angle = .init(degrees: correctedMeanEclipticLongitude.degrees + variationCorrection.degrees)
        
        
        //Step20:Apply equation to compute a corrected ecliptic longitude of the ascending node
        let moonCorrectedEclipticLongitudeAscendingNode: Angle = .init(degrees:meanEclipticLongitudeAscndingNode.degrees - 0.16 * sin(sunMeanAnomaly.radians))
        
        
        //Step21:Compute y = sin(λt − ′) cos ι where ι is the inclination of the Moon’s orbit with respect to the ecliptic. This is the numerator of the fraction in equation.
        let y = sin((moonTrueEclipticLongitude.radians - moonCorrectedEclipticLongitudeAscendingNode.radians)) * cos(inclinationMoon.radians)
        
        //Step22:
        let x = cos((moonTrueEclipticLongitude.radians - moonCorrectedEclipticLongitudeAscendingNode.radians))
        
        //Step23:
        var t: Angle = .init(radians: atan(y / x))
        
        //Step24
        
        //Angle adjustment for t due to arcan function
        
        switch (y >= 0,x >= 0){
        case (true, true):
            break
        case (true,false):
            t.degrees += 180
        case(false,true):
            t.degrees += 360
        case(false,false):
            t.degrees += 180
        }
        
        //Step25:
        var lambdaM: Angle = .init(degrees: t.degrees + moonCorrectedEclipticLongitudeAscendingNode.degrees)
        
        //Step26:
        if lambdaM.degrees > 360 {
            lambdaM.degrees -= 360
        }
        //Step27: Ecliptic Coordinates
        
        let betaMArgument = sin((moonTrueEclipticLongitude.radians - moonCorrectedEclipticLongitudeAscendingNode.radians)) * sin(inclinationMoon.radians)
        let betaM: Angle = .init(radians: asin(betaMArgument))
        
        moonEclipticCoordinates = .init(eclipticLatitude: betaM, eclipticLongitude: lambdaM)
        
        //Step28: Ecliptic to Equatorial
        moonEquatorialCoordinates = moonEclipticCoordinates.ecliptic2Equatorial()
        
        //Step29: Equatorial to Horizon
        moonHorizonCoordinates = moonEquatorialCoordinates.equatorial2Horizon(lstDecimal: lstDecimal,latitude: latitude) ?? .init(altitude: .zero, azimuth: .zero)
    }
    
    
    private func getMoonHorizonCoordinatesFrom(date: Date) -> HorizonCoordinates{
        
        //Step1:
        //Convert LCT to UT, GST, and LST times and adjust the date if needed
        let utDate = lCT2UT(date, timeZoneInSeconds: self.timeZoneInSeconds)
        let gstDate = uT2GST(utDate)
        let lstDate = gST2LST(gstDate,longitude: longitude)
        
        let lstDecimal = HMS.init(from: lstDate).hMS2Decimal()
        let utHMS = HMS.init(from: utDate)
        
        //Step2:
        //Compute TT
        var ttHMS = utHMS
        ttHMS.seconds += 63.8
        let ttDecimal = ttHMS.hMS2Decimal()
        
        //Step3:
        //Julian number for standard epoch 2000
        let jdEpoch = 2451545.00
        
        //Step4:
        //Compute the Julian day number for the desired date using the Greenwich date and TT
        
        ttHMS = HMS.init(decimal: ttDecimal) 
        
        let utDay = calendar.component(.day, from: utDate)
        let utMonth = calendar.component(.month, from: utDate)
        let utYear = calendar.component(.year, from: utDate)
        let nanoseconds = Int(ttHMS.seconds.truncatingRemainder(dividingBy: 1) * 100)
        
        
        let ttDate = createDateUTC(day: utDay , month: utMonth, year: utYear, hour: Int(ttHMS.hours), minute: Int(ttHMS.minutes), seconds: Int(ttHMS.seconds), nanosecond: nanoseconds)
        
        let jdTT = jdFromDate(date: ttDate)
        
        //Step5:
        //Compute the total number of elapsed days, including fractional days, since the standard epoch (i.e., JD − JDe)
        let elapsedDaysSinceStandardEpoch: Double = jdTT - jdEpoch //De
        
        //Step6: Use the algorithm from section 6.2 to calculate the Sun’s ecliptic longitude and mean anomaly for the given UT date and time.
        let sunMeanAnomaly = getSunMeanAnomaly(from: elapsedDaysSinceStandardEpoch)
        
        let sunEclipticLongitude = getSunEclipticLongitude(from: sunMeanAnomaly)
        
        
        //Step7: Apply equation to calculate the Moon’s (uncorrected) mean ecliptic longitude.
        var meanEclipticLongitude: Angle = .init(degrees: 13.176339686 * elapsedDaysSinceStandardEpoch + moonEclipticLongitudeAtTheEpoch.degrees)
        
        //Step8: If necessary,usetheMODfunctiontoputλintotherange[0◦,360◦]
        meanEclipticLongitude = .init(degrees: Double(mod(Int(meanEclipticLongitude.degrees),360)) + meanEclipticLongitude.degrees.truncatingRemainder(dividingBy: 1))
        
        //Step9: Apply equation  to compute the Moon’s (uncorrected) mean ecliptic longitude of the ascending node
        var meanEclipticLongitudeAscndingNode: Angle = .init(degrees: moonEclipticLongitudeAscendingNodeStandarEpoch.degrees -  0.0529539 * elapsedDaysSinceStandardEpoch)
        
        //Step10: If necessary, adjust to be in the range [0◦ , 360◦ ] (i.e., MOD 360°)
        meanEclipticLongitudeAscndingNode = .init(degrees: Double(mod(Int(meanEclipticLongitudeAscndingNode.degrees),360)) +
                                                  meanEclipticLongitudeAscndingNode.degrees.truncatingRemainder(dividingBy: 1))
        
        //Step11: Apply equation to compute the Moon’s(uncorrected) mean anomaly
        var moonMeanAnomaly: Angle = .init(degrees: meanEclipticLongitude.degrees - 0.1114041 * elapsedDaysSinceStandardEpoch - moonEclipticLongitudePerigee.degrees)
        
        //Step12: Adjust Mm if necessary to be in the range [0◦, 360◦]
        moonMeanAnomaly = .init(degrees: Double(mod(Int(moonMeanAnomaly.degrees),360)) + moonMeanAnomaly.degrees.truncatingRemainder(dividingBy: 1))
        
        //Step13: Use equation to compute the annual equation correction
        let annualEquationCorrection: Angle = .init(degrees: 0.1858 * sin(sunMeanAnomaly.radians))
        
        
        //Step14: Use equation  to compute the evection correction
        let evection: Angle = .init(degrees: 1.2739 * sin(2 * (meanEclipticLongitude.radians - sunEclipticLongitude.radians) - moonMeanAnomaly.radians))
        
        
        //Step15: Use equation to compute the mean anomaly correction
        let meanAnomalyCorrection: Angle = .init(degrees: moonMeanAnomaly.degrees + evection.degrees - annualEquationCorrection.degrees - 0.37 * sin(sunMeanAnomaly.radians))
        
        
        //Step16: Use equation to compute the Moon’s true anomaly
        let moonTrueAnomaly: Angle = .init(degrees: 6.2886 * sin(meanAnomalyCorrection.radians) + 0.214 * sin(2 * meanAnomalyCorrection.radians))
        
        
        //Step17:Use equation 7.3.9 to apply all of the applicable corrections and the true anomaly to arrive at a corrected mean ecliptic longitude
        let correctedMeanEclipticLongitude: Angle = .init(degrees: meanEclipticLongitude.degrees + evection.degrees + moonTrueAnomaly.degrees - annualEquationCorrection.degrees)
        
        
        //Step18: Use equation to compute the variation correction/
        let variationCorrection: Angle = .init(degrees: 0.6583 * sin(2*(correctedMeanEclipticLongitude.radians - sunEclipticLongitude.radians)))
        
        //Step19: Apply equation 7.3.10 to calculate the Moon’s true ecliptic longitude.
        moonTrueEclipticLongitudeGlobal = .init(degrees: correctedMeanEclipticLongitude.degrees + variationCorrection.degrees)
        
    
        //Step20:Apply equation to compute a corrected ecliptic longitude of the ascending node
        let moonCorrectedEclipticLongitudeAscendingNode: Angle = .init(degrees:meanEclipticLongitudeAscndingNode.degrees - 0.16 * sin(sunMeanAnomaly.radians))
        
        
        //Step21:Compute y = sin(λt − ′) cos ι where ι is the inclination of the Moon’s orbit with respect to the ecliptic. This is the numerator of the fraction in equation.
        let y = sin((moonTrueEclipticLongitudeGlobal.radians - moonCorrectedEclipticLongitudeAscendingNode.radians)) * cos(inclinationMoon.radians)
        
        //Step22:
        let x = cos((moonTrueEclipticLongitudeGlobal.radians - moonCorrectedEclipticLongitudeAscendingNode.radians))
        
        //Step23:
        var t: Angle = .init(radians: atan(y / x))
        
        //Step24
        
        //Angle adjustment for t due to arcan function
        
        switch (y >= 0,x >= 0){
        case (true, true):
            break
        case (true,false):
            t.degrees += 180
        case(false,true):
            t.degrees += 360
        case(false,false):
            t.degrees += 180
        }
        
        //Step25:
        var lambdaM: Angle = .init(degrees: t.degrees + moonCorrectedEclipticLongitudeAscendingNode.degrees)
        
        //Step26:
        if lambdaM.degrees > 360 {
            lambdaM.degrees -= 360
        }
        //Step27: Ecliptic Coordinates
        
        let betaMArgument = sin((moonTrueEclipticLongitudeGlobal.radians - moonCorrectedEclipticLongitudeAscendingNode.radians)) * sin(inclinationMoon.radians)
        let betaM: Angle = .init(radians: asin(betaMArgument))
        
        
        let moonEclipticCoordinates: EclipticCoordinates = .init(eclipticLatitude: betaM, eclipticLongitude: lambdaM)
        
        //Step28: Ecliptic to Equatorial
        var moonEquatorialCoordinates: EquatorialCoordinates = moonEclipticCoordinates.ecliptic2Equatorial()
        
        //Step29: Equatorial to Horizon
        let moonHorizonCoordinates: HorizonCoordinates = moonEquatorialCoordinates.equatorial2Horizon(lstDecimal: lstDecimal,latitude: latitude) ?? .init(altitude: .zero, azimuth: .zero)
        
        return .init(altitude: moonHorizonCoordinates.altitude, azimuth: moonHorizonCoordinates.azimuth)
        
    }
    
    ///Computes Moonrise and Moonset dates and azimuths
    private func getRiseAndSetDates(){
        
        var moonRiseFound = false
        var moonSetFound = false
        var altitudeForEachHour = [Double]()
        let startOfTheDay = calendar.startOfDay(for: date)
        let secondsInOneDay = 86399
        let endOfTheDay = calendar.date(byAdding: .second, value: secondsInOneDay, to: calendar.startOfDay(for: date))!

        //Compute Altitude for each hour in a day
        
        for date in stride(from: startOfTheDay, to: endOfTheDay, by: 3600){
            
            altitudeForEachHour.append(getMoonHorizonCoordinatesFrom(date: date).altitude.degrees)
            
        }
        //Append also altitude at 23:59 of the date in instance
        altitudeForEachHour.append(getMoonHorizonCoordinatesFrom(date: endOfTheDay).altitude.degrees)

        //Searching the right bin
        for index in 1...24{
            
            if(moonRiseFound && moonSetFound){
                break
            }
        
            //MoonRise found
            if(0 >= altitudeForEachHour[index - 1] && 0 <= altitudeForEachHour[index]){
                
                let binRiseHourStart = startOfTheDay.addingTimeInterval(TimeInterval((index - 1) * 3600))
                let binRiseHourEnd = startOfTheDay.addingTimeInterval(TimeInterval(index * 3600))
                
                //Dividing the bin in intervals of 1 minute each
                for date in stride(from: binRiseHourStart, to: binRiseHourEnd, by: 60){
                
                    let horizonCoordinates = getMoonHorizonCoordinatesFrom(date: date)
                    let altitudeRise = horizonCoordinates.altitude.degrees
                    let azimuthRise = horizonCoordinates.azimuth.degrees
                    if(moonRiseFound){
                        break
                    }
                    if ( (-0.23 <= altitudeRise && altitudeRise <= 0.23) &&  !moonRiseFound){
                        self.moonriseAzimuth = azimuthRise
                        self.moonRise = date
                        moonRiseFound = true
                    }
                }
            //MoonSet found
            } else if(0 <= altitudeForEachHour[index - 1] && 0 >= altitudeForEachHour[index]) {
                
                //Dividing the bin in intervals of 1 minute each
                for date in stride(from: startOfTheDay.addingTimeInterval(TimeInterval((index - 1) * 3600)), to: startOfTheDay.addingTimeInterval(TimeInterval(index * 3600)), by: 60){
                    let horizonCoordinates = getMoonHorizonCoordinatesFrom(date: date)
                    let altitudeSet = horizonCoordinates.altitude.degrees
                    let azimuthSet = horizonCoordinates.azimuth.degrees
                    if(moonSetFound){
                        break
                    }
                    if ( (-0.23 <= altitudeSet && altitudeSet <= 0.23) &&  !moonSetFound){
                        
                        self.moonsetAzimuth = azimuthSet
                        self.moonSet = date
                        moonSetFound = true
                    }
                }
            }
        }
        //If i didn't find moonrise or moonset set them to nill
        if(!moonSetFound){
            
            self.moonSet = nil
            self.moonsetAzimuth = nil
        }
        if(!moonRiseFound){
            
            self.moonRise = nil
            self.moonriseAzimuth = nil
        }
        
    }
    
    /// Updates moon percentage and age of the moon in days
    private func updateMoonPercentage(){
        
        let _ = getMoonHorizonCoordinatesFrom(date: self.date) //Used to refresh global variables
        let numeratorAgeOfTheMoon: Double = moonTrueEclipticLongitudeGlobal.degrees - sunEclipticLongitudeGlobal.degrees
        let ageOfTheMoonInD: Double = Double(mod(Int(numeratorAgeOfTheMoon),360)) 
        + numeratorAgeOfTheMoon.truncatingRemainder(dividingBy: 1)
        ageOfTheMoonInDays = ageOfTheMoonInD / 12.1907
        let ageOfTheMoon: Angle = .init(degrees: 12.1907 * ageOfTheMoonInDays)
        let fMoon: Angle = .init(degrees: (1 - cos(ageOfTheMoon.radians)) / 2)
        moonPercentage = 100 * fMoon.degrees
    }
    
    
}
