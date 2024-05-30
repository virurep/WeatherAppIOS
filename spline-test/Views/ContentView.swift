import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var dailyForecastManager = DailyForecastManager()
    @State var weather: ResponseBody?
    @State var forecast: ResponseBodyForecast?
    @State private var isRefreshing = false
    @State private var showForecast = false
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if isRefreshing {
                    LoadingScreen()
                } else if showForecast {
                    HourlyView()
                } else if let weather = weather {
                    WeatherView(weather: weather, refreshAction: {
                        refreshWeather(for: location)
                    }, showForecast: $showForecast)
                } else {
                    LoadingScreen()
                        .task {
                            await fetchWeather(for: location)
                            await fetchForecast(for: location)
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingScreen()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .all)
        .background(Color(red: 116/255, green: 174/255, blue: 222/255))
    }
    
    private func refreshWeather(for location: CLLocationCoordinate2D) {
        isRefreshing = true
        Task {
            await fetchWeather(for: location)
            isRefreshing = false
        }
    }
    
    private func fetchWeather(for location: CLLocationCoordinate2D) async {
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
        }
    }
    
    private func fetchForecast(for location: CLLocationCoordinate2D) async {
        do {
            forecast = try await dailyForecastManager.getForecastWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting forecast: \(error)")
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

