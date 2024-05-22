//
//  DailyForecastManager.swift
//  spline-test
//
//  Created by Viru Repalle on 5/22/24.
//

import Foundation
import CoreLocation

class DailyForecastManager {
    // HTTP request to get the current weather depending on the coordinates we got from LocationManager
    func getForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBodyForecast {
        // Replace YOUR_API_KEY in the link below with your own
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=e13be5b9fccfa1dfa7a2efded3efd186&units=imperial") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        let decodedData = try JSONDecoder().decode(ResponseBodyForecast.self, from: data)
        
        return decodedData
    }
}

// Model of the response body we get from calling the OpenWeather API
import Foundation

// Define the main response body for the forecast
struct ResponseBodyForecast: Decodable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: [WeatherData]
    var city: CityResponse

    // Structure for individual weather data entries
    struct WeatherData: Decodable {
        var dt: Int
        var main: MainResponse
        var weather: [WeatherResponse]
        var clouds: CloudsResponse
        var wind: WindResponse
        var visibility: Int
        var pop: Double
        var rain: RainResponse?
        var sys: SysResponse
        var dt_txt: String
    }

    // Structure for main weather metrics
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Int
        var sea_level: Int
        var grnd_level: Int
        var humidity: Int
        var temp_kf: Double
    }

    // Structure for weather description
    struct WeatherResponse: Decodable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }

    // Structure for cloud coverage
    struct CloudsResponse: Decodable {
        var all: Int
    }

    // Structure for wind data
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Int
        var gust: Double
    }

    // Structure for rain data (optional)
    struct RainResponse: Decodable {
        var h3: Double?

        // Custom keys for Rain to match "3h" key in JSON
        private enum CodingKeys: String, CodingKey {
            case h3 = "3h"
        }
    }

    // Structure for additional system data
    struct SysResponse: Decodable {
        var pod: String
    }

    // Structure for city information
    struct CityResponse: Decodable {
        var id: Int
        var name: String
        var coord: CoordinatesResponse
        var country: String
        var population: Int
        var timezone: Int
        var sunrise: Int
        var sunset: Int
    }

    // Structure for city coordinates
    struct CoordinatesResponse: Decodable {
        var lat: Double
        var lon: Double
    }
}

//extension ResponseBody.MainResponse {
//    var feelsLike: Double { return feels_like }
//    var tempMin: Double { return temp_min }
//    var tempMax: Double { return temp_max }
//}
