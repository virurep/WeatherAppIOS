//import SwiftUI
//
//struct SearchView: View {
//    @StateObject private var viewModel = SearchViewModel()
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            HStack {
//                Spacer()
//                TextField("Enter city name", text: $viewModel.city)
//                    .font(.custom("OktahRound-BdIt", size: 18))
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .foregroundColor(Color.darkPurple)
//                Spacer()
//            }
//            .padding(.horizontal, 16)
//
//            Button(action: {
//                Task {
//                    await viewModel.searchWeather()
//                }
//            }) {
//                Text("Search")
//                    .font(.custom("OktahRound-BdIt", size: 18))
//                    .padding()
//                    .background(Color.darkPurple)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//
//            if let weather = viewModel.weather {
//                SearchWeatherView(weather: weather)
//            } else if let error = viewModel.error {
//                Text("Error: \(error.localizedDescription)")
//                    .font(.custom("OktahRound-BdIt", size: 16))
//                    .foregroundColor(.red)
//                    .padding()
//            }
//
//            Spacer()
//        }
//        .padding()
//        .background(Color.customBlue.edgesIgnoringSafeArea(.all))
//    }
//}
//
//struct SearchWeatherView: View {
//    let weather: SearchResponseBody
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("City: \(weather.name)")
//                .font(.custom("OktahRound-BdIt", size: 20))
//                .foregroundColor(Color.darkPurple)
//            Text("Temperature: \(weather.main.temp)°F")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//            Text("Feels Like: \(weather.main.feelsLike)°F")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//            Text("Min Temperature: \(weather.main.tempMin)°F")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//            Text("Max Temperature: \(weather.main.tempMax)°F")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//            Text("Pressure: \(weather.main.pressure) hPa")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//            Text("Humidity: \(weather.main.humidity)%")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//            Text("Wind Speed: \(weather.wind.speed) mph")
//                .font(.custom("OktahRound-BdIt", size: 18))
//                .foregroundColor(Color.darkPurple)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(20)
//        .padding(.horizontal, 16)
//        .padding(.vertical, 10)
//    }
//}
//
//@MainActor
//class SearchViewModel: ObservableObject {
//    @Published var city: String = ""
//    @Published var weather: SearchResponseBody?
//    @Published var error: Error?
//
//    private let searchManager = SearchManager()
//
//    func searchWeather() async {
//        do {
//            guard !city.isEmpty else { return } // Ensure city name is not empty
//            let weatherData = try await searchManager.getCurrentWeather(for: city)
//            self.weather = weatherData
//            self.error = nil
//        } catch {
//            self.weather = nil
//            self.error = error
//        }
//    }
//}




import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var isSearching = true

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.customBlue.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    if isSearching {
                        TextField("Enter city name", text: $viewModel.city, onCommit: {
                            search()
                        })
                        .font(.custom("OktahRound-BdIt", size: 18))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(Color.darkPurple)
                        .padding(.bottom, 8)
                        .transition(.opacity) // Fade-in animation
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                if isSearching {
                    Button(action: {
                        search()
                    }) {
                        Text("Search")
                            .font(.custom("OktahRound-BdIt", size: 18))
                            .padding()
                            .background(Color.darkPurple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .transition(.opacity) // Fade-in animation
                } else {
                    if let weather = viewModel.weather {
                        SearchWeatherView(weather: weather)
                            .transition(.move(edge: .bottom)) // Slide-in animation from bottom
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .font(.custom("OktahRound-BdIt", size: 16))
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                
                Spacer()
            }
            
            if !isSearching {
                Button(action: {
                    withAnimation(.easeInOut) {
                        isSearching = true
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .scaleEffect(isSearching ? 1.0 : 1.2) // Scale effect animation
                        .animation(.spring(), value: isSearching)
                }
                .padding(.top, 40)
                .padding(.trailing, 20)
            }
        }
        .navigationBarHidden(true)
        .animation(.default, value: isSearching) // Applying the default animation
    }

    private func search() {
        Task {
            await viewModel.searchWeather()
            withAnimation {
                isSearching = false
            }
            hideKeyboard()
        }
    }

    private func hideKeyboard() {
        #if os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

struct SearchWeatherView: View {
    let weather: SearchResponseBody

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HeaderView(city: weather.name, showForecast: .constant(false))
                        .padding(.top, 60)
                        .ignoresSafeArea(edges: .top)
                    
                    Spacer(minLength: 180)
                    
                    WeatherIconView(temp: Int(weather.main.temp), description: weather.weather[0].main, tempHigh: Int(weather.main.tempMax), tempLow: Int(weather.main.tempMin))
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 15)
                    
                    WeatherDetailsView(feelsLike: Int(weather.main.feelsLike), humidity: Int(weather.main.humidity), wind: Int(weather.wind.speed), pressure: Int(weather.main.pressure))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.lightBlue).edgesIgnoringSafeArea(.all))
                }
                .frame(minHeight: geometry.size.height)
            }
            .background(Color.customBlue.edgesIgnoringSafeArea(.all))
        }
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



