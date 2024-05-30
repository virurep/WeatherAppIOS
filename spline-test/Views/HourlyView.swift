import SwiftUI
import CoreLocation

struct HourlyView: View {
    @StateObject private var viewModel = HourlyViewModel()

    var body: some View {
        VStack {
            if let forecast = viewModel.forecast {
                List(forecast.list.prefix(12), id: \.dt) { weatherData in
                    HStack {
                        Text(weatherData.dt_txt)
                            .font(.subheadline)
                            .padding(.trailing, 10)

                        VStack(alignment: .leading) {
                            Text("Temp: \(weatherData.main.temp)°F")
                            Text("Rain: \(weatherData.pop * 100, specifier: "%.0f")%")
                            Text("Description: \(weatherData.weather.first?.description ?? "N/A")")
                        }
                    }
                    .padding(.vertical, 5)
                }
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Loading...")
                    .padding()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchHourlyForecast(latitude: 37.7749, longitude: -122.4194) // Example coordinates for San Francisco
            }
        }
    }
}

@MainActor
class HourlyViewModel: ObservableObject {
    @Published var forecast: ResponseBodyHourly?
    @Published var error: Error?

    private let forecastManager = HourlyForecastManager()

    func fetchHourlyForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        do {
            let forecastData = try await forecastManager.getForecastWeather(latitude: latitude, longitude: longitude)
            self.forecast = forecastData
            self.error = nil
        } catch {
            self.forecast = nil
            self.error = error
        }
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView()
    }
}
