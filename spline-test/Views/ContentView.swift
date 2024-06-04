import SwiftUI
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var dailyForecastManager = DailyForecastManager()
    @State var weather: ResponseBody?
    @State var forecast: ResponseBodyForecast?
    @State private var isRefreshing = false
    @State private var showForecast = false
    @State private var user: User?
    @State private var isLoading = true  // State to manage loading status

    var body: some View {
        VStack {
            if isLoading {
                LoadingScreen()
                    .onAppear {
                        handleInitialLoading()
                    }
            } else {
                if let firebaseUser = viewModel.userSession {
                    // If user is authenticated, create User object and display ProfileView
                    let user = User(id: firebaseUser.uid, fullname: firebaseUser.displayName ?? "", email: firebaseUser.email ?? "", image: nil)
                    ProfileView(user: user)
                        .onAppear {
                            // Trigger location request when ProfileView appears
                            if locationManager.location == nil {
                                locationManager.requestLocation()
                            }
                        }
                } else {
                    // Otherwise, display LoginView
                    LoginView()
                }
                
                // Display appropriate content based on location and data availability
                if let location = locationManager.location {
                    if isRefreshing {
                        LoadingScreen()
                    } else if showForecast, let forecast = forecast {
                        // Display SearchView if forecast is available
                        SearchView()
                    } else if let weather = weather {
                        // Display WeatherView if weather is available
                        WeatherView(weather: weather, refreshAction: {
                            refreshWeather(for: location)
                        }, showForecast: $showForecast)
                    } else {
                        // Display LoadingScreen while fetching weather and forecast data
                        LoadingScreen()
                            .task {
                                await fetchWeather(for: location)
                                await fetchForecast(for: location)
                            }
                    }
                } else if locationManager.isLoading {
                    // Display LoadingScreen if locationManager is still loading
                    LoadingScreen()
                }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .all)
        .background(Color(red: 116/255, green: 174/255, blue: 222/255))
    }

    private func handleInitialLoading() {
        // Simulate initial loading, and set isLoading to false after authentication check
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if viewModel.userSession != nil {
                if locationManager.location == nil {
                    locationManager.requestLocation()
                }
            }
            isLoading = false
        }
    }

    private func refreshWeather(for location: CLLocationCoordinate2D) {
        // Refresh weather data
        isRefreshing = true
        Task {
            await fetchWeather(for: location)
            isRefreshing = false
        }
    }

    private func fetchWeather(for location: CLLocationCoordinate2D) async {
        // Fetch current weather data
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
        }
    }

    private func fetchForecast(for location: CLLocationCoordinate2D) async {
        // Fetch forecast data
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
            .environmentObject(AuthViewModel()) // Assuming you need to provide AuthViewModel
    }
}






