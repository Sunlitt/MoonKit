//
//  MoonPhase.swift
//  
//
//  Created by Davide Biancardi on 06/11/22.
//

import Foundation


public enum MoonPhase: String{
    
    case newMoon = "New Moon"
    case waxingCrescent = "Waxing Crescent"
    case firstQuarter = "First Quarter"
    case waxingGibbous = "Waxing Gibbous"
    case fullMoon = "Full Moon"
    case waningGibbous = "Waning Gibbous"
    case lastQuarter = "Last Quarter"
    case waningCrescent = "Waning Crescent"
    case error = "Error during computing moon phase"
    

    public static func ageOfTheMoonDegrees2MoonPhase(_ ageOfTheMoonInDegrees: Double) -> MoonPhase{
        
        switch ageOfTheMoonInDegrees{
            
        case _ where ageOfTheMoonInDegrees < 1 && ageOfTheMoonInDegrees >= 0:
            return .newMoon
        
        case _ where ageOfTheMoonInDegrees >= 1 && ageOfTheMoonInDegrees <= 89:
            return .waxingCrescent
        
        case _ where ageOfTheMoonInDegrees > 89 && ageOfTheMoonInDegrees < 91:
            return .firstQuarter
        
        case _ where ageOfTheMoonInDegrees >= 91 && ageOfTheMoonInDegrees <= 170:
            return .waxingGibbous
        
        case _ where ageOfTheMoonInDegrees > 170 && ageOfTheMoonInDegrees < 190:
            return .fullMoon
        
        case _ where ageOfTheMoonInDegrees >= 190 && ageOfTheMoonInDegrees <= 269:
            return .waningGibbous
            
        case _ where ageOfTheMoonInDegrees > 269 && ageOfTheMoonInDegrees < 271:
            return .lastQuarter
        
        case _ where ageOfTheMoonInDegrees >= 271 && ageOfTheMoonInDegrees <= 350:
            return .waningCrescent
        
        case _ where ageOfTheMoonInDegrees > 350 && ageOfTheMoonInDegrees < 360:
            return .newMoon
        
        default:
            return .error
        }
    }
}

