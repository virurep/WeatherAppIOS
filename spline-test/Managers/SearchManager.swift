import Foundation

class SearchManager {
    // HTTP request to get the current weather based on the city name
    func getCurrentWeather(for city: String) async throws -> SearchResponseBody {
        // Replace YOUR_API_KEY in the link below with your own
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=e13be5b9fccfa1dfa7a2efded3efd186&units=imperial") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

        let decodedData = try JSONDecoder().decode(SearchResponseBody.self, from: data)

        return decodedData
    }
}

// Model of the response body we get from calling the OpenWeather API
struct SearchResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }

    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension SearchResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
