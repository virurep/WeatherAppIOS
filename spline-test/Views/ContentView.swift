import SwiftUI

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    @State private var isRefreshing = false
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if isRefreshing {
                    LoadingScreen()
                } else if let weather_ = weather {
                    WeatherView(weather: weather!, refreshAction: {
                        isRefreshing = true
                        Task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                            isRefreshing = false
                        }
                    })
                } else {
                    LoadingScreen()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
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
        .ignoresSafeArea(edges: .bottom)
        .background(Color(red: 116/255, green: 174/255, blue: 222/255))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
