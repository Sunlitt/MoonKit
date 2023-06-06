# MoonKit

<div align="center">

<img height="110" alt="moonkit" src="https://user-images.githubusercontent.com/81416309/218829402-cc23843f-e630-40eb-b7b6-0748572500b2.png">
 
![GitHub](https://img.shields.io/github/license/davideilmito/MoonKit) [![GitHub stars](https://img.shields.io/github/stars/davideilmito/MoonKit)](https://github.com/davideilmito/MoonKit/stargazers) [![GitHub issues](https://img.shields.io/github/issues/davideilmito/MoonKit)](https://github.com/davideilmito/MoonKit/issues)  [![Requires Core Location](https://img.shields.io/badge/requires-CoreLocation-orange?style=flat&logo=Swift)](https://developer.apple.com/documentation/corelocation) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSunlitt%2FSunKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Sunlitt/SunKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhappn-app%2FURLRequestOperation%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/davideilmito/MoonKit)


</div>

**MoonKit** is a Swift package which uses math and trigonometry to compute several information about the Moon. 

## Usage
MoonKit only needs a location and the relative time zone to compute every Moon information.  
Everything is computed locally, no internet connection is needed.

### Creating a Moon 

```swift

// Creating a CLLocation object with the coordinates you are interested in
let naplesLocation: CLLocation = .init(latitude: 40.84014, longitude: 14.25226)

// Timezone for the location of interest. It's highly recommended to initialize it via identifier
let timeZoneNaples: Timezone = .init(identifier: "Europe/Rome") ?? .current

// Creating the Moon instance which will store all the information you need about Moon events and her position
var myMoon: Moon = .init(location: naplesLocation, timeZone: timeZoneNaples)

```

### Retrieve information

```swift
// Creating a Date instance
let myDate: Date = Date() // Your current date

// Setting inside myMoon object the date of interest
myMoon.setDate(myDate)

      // All the following informations are related to the given location for the date that has just been set

// Azimuth of the Moon 
myMoon.azimuth  

// Altitude of the Moon
myMoon.altitude

// Moonrise Date
myMoon.moonRise

// Moonset Date
myMoon.moonSet

// Current Moon Phase
myMoon.currentMoonPhase

// Moon Astrological sign
myMoon.moonSign

// To know all the information you can retrieve go to the **Features** section.


```
 ### Working with Timezones and Dates
 
 
To properly show the Moon Date Events use the following DateFormatter.

```swift

 //Creting a DateFormatter
 let dateFormatter =  DateFormatter()
 
 //Properly setting his attributes
 dateFormatter.locale    =  .current
 dateFormatter.timeZone  =  timeZoneNaples  // It shall be the same as the one used to initilize myMoon
 dateFormatter.timeStyle = .full
 dateFormatter.dateStyle = .full
  
 //Printing Moon Date Events with the correct Timezone
  
 print("Moonrise: \(dateFormatter.string(from: myMoon.moonRise))")
    
```
  
## Features
  * Moon Azimuth
  * Moon Altitude
  * MoonRise Time
  * MoonSet Time
  * Moon Percentage
  * Moon Phase
  * Moon Astrological Sign
  * MoonRise Azimuth
  * MoonSet Azimuth
  * Next Full Moon 
  * Next New Moon


## References

* Celestial Calculations: A Gentle Introduction to Computational Astronomy: [Link](https://www.amazon.it/Celestial-Calculations-Introduction-Computational-Astronomy/dp/0262536633/ref=sr_1_1?__mk_it_IT=ÅMÅŽÕÑ&crid=1U99GMGDZ2CUF&keywords=celestial+calculations&qid=1674408445&sprefix=celestial+calculation%2Caps%2C109&sr=8-1).

## SunKit ☀️

Take a look to the other Package, this time about the Sun: [SunKit](https://github.com/Sunlitt/SunKit).



