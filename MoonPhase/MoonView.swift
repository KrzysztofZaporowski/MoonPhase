//
//  MoonView.swift
//  MoonPhase
//
//  Created by Krzysztof Zaporowski on 13/05/2025.
//

import SwiftUI
import CoreLocation
import SwiftAA

struct MoonView: View {
    @State var moonPhase: Double = 75
    @State var hemisphere = Hemisphere.Northern
    @State var date = Date()
    @State var previousNewMoon = Date()
    @State var nextNewMoon = Date()
    @State var fullMoon = Date()
    @State var illumination = 0.0
    
    @Binding var location:CLLocationCoordinate2D
    
    init(location: Binding<CLLocationCoordinate2D>) {
        _location = location
    }
    func calculatePhase() {
        let jd=JulianDay(date) //Konwersja na JulianDay
        let moon = Moon(julianDay: jd) //Utworzenie klasy księżyca
        fullMoon=moon.time(of: MoonPhase.fullMoon).date //Następna pełnia
        previousNewMoon=moon.time(of: MoonPhase.newMoon,forward: false).date//Poprzedni nów
        nextNewMoon=moon.time(of: MoonPhase.newMoon,forward: true).date //Następny nów
        illumination = moon.illuminatedFraction()*100 //procent oświetlonej części księżyca
        var phasePercent=illumination/2 //procent fazy księżyca - wiek
        if (nextNewMoon<fullMoon)
        {
            phasePercent=100-phasePercent //jeżeli maleje odejmij od 100%
        }
        moonPhase = phasePercent
    }
    
    var body: some View {
        VStack {
            HStack {
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Select date")
                }
                Spacer()
                Button("Today") {
                    date = Date()
                }
            }
            Spacer()
            MoonControl(phase: $moonPhase, hemisphere: $hemisphere)
            Spacer()
            HStack {
                Text("Illumination%")
                Spacer()
                Text(illumination.format(decimalPlaces: 2))
            }
            HStack {
                Text("Next new moon")
                Spacer()
                Text(nextNewMoon.short)
            }.onAppear() {
                calculatePhase()
            }
            HStack {
                Text("Next fool moon")
                Spacer()
                Text(fullMoon.short)
            }.onChange(of: date) {oldDate, newDate in
                calculatePhase()
            }
        }.onChange(of: location) {oldLocation, newLocation in
            if location.latitude < 0 {
                hemisphere = .Southern
            } else {
                hemisphere = .Northern
            }
        }
    }
}
