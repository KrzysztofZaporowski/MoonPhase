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
    @State var sunrise: String = "--"
    @State var sunset: String = "--"
    @State var transit: String = "--"
    @State var dayLength: String = "--"
    @State var date: Date = Date()

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
            sunrise = rise.date.timeOnly
        }
        if let set = times.setTime {
            sunset = set.date.timeOnly
        }
        if let transitVal = times.transitTime {
            transit = transitVal.date.timeOnly
        }
        if let rise = times.riseTime?.date, let set = times.riseTime?.date {
            let delta = set.timeIntervalSince(rise)
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .abbreviated
            formatter.allowedUnits = [.hour, .minute, .second]
            dayLength = formatter.string(from: delta) ?? "00:00.00"
        } else {
            dayLength = "N/A"
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            DatePicker("Select date", selection: $date, displayedComponents: .date)
            HStack {
                Text("Sunrise")
                Spacer()
                Text(sunrise)
            }
            HStack {
                Text("Transit")
                Spacer()
                Text(transit)
            }
            HStack {
                Text("Sunset")
                Spacer()
                Text(sunset)
            }
            HStack {
                Text("Day length")
                Spacer()
                Text(dayLength)
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
