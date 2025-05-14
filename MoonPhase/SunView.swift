//
//  SunView.swift
//  MoonPhase
//
//  Created by Krzysztof Zaporowski on 13/05/2025.
//

import SwiftUI
import CoreLocation
import SwiftAA

struct SunView: View {
    @Binding var location: CLLocationCoordinate2D
    @State var sunrise: Date = Date()
    @State var sunset: Date = Date()
    @State var transit: Date = Date()
    @State var dayLength: Date = Date()
    @State var date: Date = Date()

    @State var control = 245.0
    @State var height:Double = 245.0
    @State var width:Double = 200.0
    
    init(location: Binding<CLLocationCoordinate2D>) {
        _location = location
    }

    func calculateSunTimes() {
        guard let coreLocation = CLLocation(location) else { return }
        let coordinates = GeographicCoordinates(coreLocation)
        let jd = JulianDay(date)
        let sun = Sun(julianDay: jd)
        let times = sun.riseTransitSetTimes(for: coordinates)
        
        if let rise = times.riseTime {
            self.sunrise = rise.date
        }
        if let set = times.setTime {
            self.sunset = set.date
        }
        if let transit = times.transitTime {
            self.transit = transit.date
        }
        let delta = sunset.timeIntervalSince(sunrise)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]

        let dayLength = formatter.string(from: delta) ?? "00:00:00"
    }

    var body: some View {
        VStack() {
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
            GeometryReader { geometry in
                Image("sun").resizable().scaledToFit().onAppear() {
                    let frame = geometry.frame(in: .local)
                    height = frame.height
                    width = frame.width
                    control = width * 0.62
                }
            }
            Spacer()
            HStack {
                Text("Sunrise")
                Spacer()
                Text(sunrise.timeOnly)
            }
            HStack {
                Text("Transit")
                Spacer()
                Text(transit.timeOnly)
            }
            HStack {
                Text("Sunset")
                Spacer()
                Text(sunset.timeOnly)
            }
            HStack {
                Text("Day length")
                Spacer()
                Text(dayLength.timeOnly)
            }
        }
        .padding()
        .onAppear {
            calculateSunTimes()
        }
        .onChange(of: date) { _, _ in
            calculateSunTimes()
        }
        .onChange(of: location) { _, _ in
            calculateSunTimes()
        }
    }
}
