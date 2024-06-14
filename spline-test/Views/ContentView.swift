import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var dailyForecastManager = DailyForecastManager()
    @State var weather: ResponseBody?
    @State var forecast: ResponseBodyForecast?
    @State private var isRefreshing = false
    @State private var showForecast = false
    @State private var showSearch = false
    @State private var showProfile = false
    
    // Step 1: Authentication State
    @State private var isLoggedIn = false
    @State private var user: User?
    @State private var isLoadingUser = true // Flag to indicate whether user data is being loaded

    var body: some View {
        VStack {
            if let location = locationManager.location {
                if isRefreshing {
                    LoadingScreen()
                } else if showForecast, let forecast = forecast {
                    ForecastView(forecast: forecast, showForecast: $showForecast)
                } else if showSearch{
                    SearchView(showSearch: $showSearch)
                }  else if let weather = weather {
                    WeatherView(weather: weather, refreshAction: {
                        refreshWeather(for: location)
                    }, showForecast: $showForecast,showSearch: $showSearch, showProfile: $showProfile)
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
        .onAppear {
            if isLoggedIn {
                fetchUserData()
            }
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
            print()
        } catch {
            print("Error getting forecast: \(error)")
        }
    }
    
    private func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    self.user = user
                } catch {
                    print("Error decoding user data: \(error.localizedDescription)")
                }
            } else {
                print("User document does not exist")
            }
            isLoadingUser = false // Set isLoadingUser to false after fetching user data
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

