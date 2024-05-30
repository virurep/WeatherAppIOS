import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                TextField("Enter city name", text: $viewModel.city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }

            Button(action: {
                Task {
                    await viewModel.searchWeather()
                }
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            if let weather = viewModel.weather {
                SearchWeatherView(weather: weather)
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct SearchWeatherView: View {
    let weather: SearchResponseBody

    var body: some View {
        VStack {
            Text("City: \(weather.name)")
            Text("Temperature: \(weather.main.temp)°F")
            Text("Feels Like: \(weather.main.feelsLike)°F")
            Text("Min Temperature: \(weather.main.tempMin)°F")
            Text("Max Temperature: \(weather.main.tempMax)°F")
            Text("Pressure: \(weather.main.pressure) hPa")
            Text("Humidity: \(weather.main.humidity)%")
            Text("Wind Speed: \(weather.wind.speed) mph")
        }
        .padding()
    }
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: SearchResponseBody?
    @Published var error: Error?

    private let searchManager = SearchManager()

    func searchWeather() async {
        do {
            guard !city.isEmpty else { return } // Ensure city name is not empty
            let weatherData = try await searchManager.getCurrentWeather(for: city)
            self.weather = weatherData
            self.error = nil
        } catch {
            self.weather = nil
            self.error = error
        }
    }
}
