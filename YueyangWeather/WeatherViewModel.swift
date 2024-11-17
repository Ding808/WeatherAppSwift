//
//  WeatherService.swift
//  YueyangWeather
//
//  Created by Yueyang Ding on 2024-11-16.
//
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherInfo: WeatherInfo?

    private let apiKey = "94808344c93c4917ac4204501241611"

    func fetchWeather(latitude: Double, longitude: Double) {
        guard latitude != 0.0, longitude != 0.0 else {
            print("Invalid coordinates. Weather fetch aborted.")
            return
        }

        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(latitude),\(longitude)"
        print("API URL: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data returned.")
                return
            }

            print("Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            do {
                let decodedData = try JSONDecoder().decode(WeatherInfo.self, from: data)
                DispatchQueue.main.async {
                    self.weatherInfo = decodedData
                }
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}


struct WeatherInfo: Codable {
    let location: Location
    let current: Current

    struct Location: Codable {
        let name: String
        let country: String
    }

    struct Current: Codable {
        let temp_c: Double
        let feelslike_c: Double
        let wind_kph: Double
        let wind_dir: String
        let humidity: Int
        let uv: Double
        let vis_km: Double
        let condition: Condition

        struct Condition: Codable {
            let text: String
        }
    }
}
