//
//  AstrologicalSign.swift
//  
//
//  Created by Davide Biancardi on 26/03/23.
//

import Foundation

public enum AstrologicalSign: String{
    
    case aries       = "Aries"
    case taurus      = "Taurus"
    case gemini      = "Gemini"
    case cancer      = "Cancer"
    case leo         = "Leo"
    case virgo       = "Virgo"
    case libra       = "Libra"
    case scorpio     = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn   = "Capricorn"
    case aquarius    = "Aquarius"
    case pisces      = "Pisces"
    case error       = "Error"
    
    public static func eclipticLongitude2AstrologicalSign(_ elipticLongitude: Angle) -> AstrologicalSign
    {
        switch elipticLongitude.degrees{
            
        case _ where elipticLongitude.degrees < 30 && elipticLongitude.degrees >= 0:
            return .aries
            
        case _ where elipticLongitude.degrees >= 30 && elipticLongitude.degrees < 60:
            return .taurus
            
        case _ where elipticLongitude.degrees >= 60 && elipticLongitude.degrees < 90:
            return .gemini
            
        case _ where elipticLongitude.degrees >= 90 && elipticLongitude.degrees < 120:
            return .cancer
            
        case _ where elipticLongitude.degrees >= 120 && elipticLongitude.degrees < 150:
            return .leo
            
        case _ where elipticLongitude.degrees >= 150 && elipticLongitude.degrees < 180:
            return .virgo
            
        case _ where elipticLongitude.degrees >= 180 && elipticLongitude.degrees < 210:
            return .libra
            
        case _ where elipticLongitude.degrees >= 210 && elipticLongitude.degrees < 240:
            return .scorpio
            
        case _ where elipticLongitude.degrees >= 240 && elipticLongitude.degrees < 270:
            return .sagittarius
            
        case _ where elipticLongitude.degrees >= 270 && elipticLongitude.degrees < 300:
            return .capricorn
            
        case _ where elipticLongitude.degrees >= 300 && elipticLongitude.degrees < 330:
            return .aquarius
            
        case _ where elipticLongitude.degrees >= 330 && elipticLongitude.degrees < 360:
            return .pisces
            
        default:
            return .error
            
        }
        
    }
}
