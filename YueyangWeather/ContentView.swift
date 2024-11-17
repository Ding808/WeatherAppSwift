//
//  ContentView.swift
//  YueyangWeather
//
//  Created by Yueyang Ding on 2024-11-16.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherVM = WeatherViewModel()

    var body: some View {
        VStack {
            if locationManager.isLocationAvailable {
                if let weather = weatherVM.weatherInfo {
                    Text("Weather in \(weather.location.name), \(weather.location.country)")
                        .font(.headline)
                        .padding()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Temperature: \(weather.current.temp_c)°C")
                        Text("Feels Like: \(weather.current.feelslike_c)°C")
                        Text("Wind: \(weather.current.wind_kph) kph (\(weather.current.wind_dir))")
                        Text("Humidity: \(weather.current.humidity)%")
                        Text("UV Index: \(weather.current.uv)")
                        Text("Visibility: \(weather.current.vis_km) km")
                        Text("Condition: \(weather.current.condition.text)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Fetching weather data...")
                        .padding()
                }
            } else {
                Text("Location access is required to fetch weather data.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .onAppear {
            if locationManager.latitude != 0.0 && locationManager.longitude != 0.0 {
                weatherVM.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
            } else {
                print("Waiting for location updates...")
            }
        }
        .onChange(of: locationManager.latitude) { _ in
            if locationManager.latitude != 0.0 && locationManager.longitude != 0.0 {
                weatherVM.fetchWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
            }
        }
    }
}
