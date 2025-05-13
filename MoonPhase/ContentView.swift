//
//  ContentView.swift
//  MoonPhase
//
//  Created by Krzysztof Zaporowski on 13/05/2025.
//

import SwiftUI
import SwiftAA
import CoreLocation

struct ContentView: View {
    
    @State var phase: Double = 30.0
    @ObservedObject var locationManager = LocationManager()
    
    @State var location: CLLocationCoordinate2D =
    CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    init() {
        locationManager.requestLocation()
    }
    
    var body: some View {
        TabView {
            Group {
                MoonView(location: $location)
                    .padding().tabItem {
                        Label("Moon", systemImage: "moon.haze")
                    }
                SunView(location: $location).tabItem {
                    Label("Sun", systemImage: "sun.max.fill")
                }
            }
        }.onChange(of: locationManager.location) { oldLocation, newLocation in
            location = newLocation!
            print("Location changed")
        }
        .preferredColorScheme(.dark)
        .environment(\.colorScheme, .dark)
        .onAppear {
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            if let firstWindow = scene?.windows.first {
                firstWindow.overrideUserInterfaceStyle = .dark
            }
        }
    }
}

#Preview {
    ContentView()
}
