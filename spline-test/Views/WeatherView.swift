import SwiftUI
import SplineRuntime

// Color extension for custom colors
extension Color {
	static let customBlue = Color(red: 0.455, green: 0.682, blue: 0.871)
	static let customBlackOpacity = Color.black.opacity(0.7)
	static let darkPurple = Color(red: 0.196, green: 0.118, blue: 0.376)
	static let lightBlue = Color(red: 0.631, green: 0.8, blue: 0.937)
	
	
}

struct WeatherView: View {
    var weather: ResponseBody
    var refreshAction: () -> Void
    @Binding var showForecast: Bool
    @Binding var showSearch: Bool
    @Binding var showProfile: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    let url = URL(string: "https://build.spline.design/LcgX-F1ByWjAJ1iYKWFO/scene.splineswift")!
                    
                    if let splineView = try? SplineView(sceneFileURL: url) {
                        splineView.ignoresSafeArea(.all)
                    } else {
                        Text("Failed to load Spline view")
                            .ignoresSafeArea(.all)
                    }
                    
                    VStack {
                        HeaderView(city: weather.name, showForecast: $showForecast, showSearch: $showSearch, showProfile: $showProfile)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .refreshable {
                refreshAction()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct HeaderView: View {
    var city: String
    @Binding var showForecast: Bool
    @Binding var showSearch: Bool
    @Binding var showProfile: Bool
    @State private var showMenu = false
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    Button(action: {
                        showForecast = true
                    }) {
                        Label("Daily Forecast", systemImage: "calendar")
                    }
                    Button(action: {
                        showSearch = true
                    }) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    Button(action: {
                        showProfile = true
                    }) {
                        Label("Profile", systemImage: "person")
                    }

                } label: {
                    Image("hamburgerMenu")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.darkPurple)
                        .padding()
                }
                
                Spacer()
                
                VStack {
                    Text(city)
                        .font(.custom("OktahRound-BdIt", size: 40))
                        .foregroundColor(Color.darkPurple)
                    
                    Text(currentDateString)
                        .font(.custom("OktahRound-BdIt", size: 16))
                        .foregroundColor(Color.darkPurple)
                }
                
                Spacer()
                
                Spacer().frame(width: 90)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: Date())
    }
}



struct WeatherIconView: View {
	var temp: Int
	var description: String
    var tempHigh: Int
    var tempLow: Int
	
	var body: some View {
		VStack(spacing: 0) {
			Text("\(temp)°")
				.font(.custom("OktahRound-BdIt", size: 128))
				.padding(.leading, 45)
				.foregroundColor(Color.darkPurple)
			
			Text(description.capitalized)
				.font(.custom("OktahRound-BdIt", size: 20))
				.padding(.top, -20)
				.foregroundColor(Color.darkPurple)
			
			Text("High \(tempHigh)° | Low \(tempLow)°")
				.font(.custom("OktahRound-BdIt", size: 16))
				.foregroundColor(Color.darkPurple)
		}
	}
}

struct WeatherDetailsView: View {
    var feelsLike: Int
    var humidity: Int
    var wind: Int
    var pressure: Int
    
	var body: some View {
		VStack(alignment: .leading) {
			Text("Weather Now")
				.font(.custom("OktahRound-BdIt", size: 20))
				.foregroundColor(Color.darkPurple)
				.padding(.bottom, 10)
				.padding(.top, 10)
				.padding(.leading, 40)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			HStack {
				HStack {
					Circle()
						.fill(Color.darkPurple)
						.frame(width: 40, height: 40)
						.overlay(
							Image("feelsLike")
								.resizable()
								.scaledToFit()
								.padding(7)
						)
					
					VStack(alignment: .leading) {
						Text("Feels Like")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("\(feelsLike)°")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple)
					}
				}
				.padding(.leading, 40)
				.frame(maxWidth: .infinity, alignment: .leading)
				
				Spacer()
				HStack {
					Circle()
						.fill(Color.darkPurple)
						.frame(width: 40, height: 40)
						.overlay(
							Image("precipitation")
								.resizable()
								.scaledToFit()
								.padding(5)
						)
					
					VStack(alignment: .leading) {
						Text("Humidity")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("\(humidity)%")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple)
					}
				}
				.padding(.trailing, 45)
				.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.frame(maxWidth: .infinity)
			
			HStack {
				HStack {
					
					Circle()
						.fill(Color.darkPurple)
						.frame(width: 40, height: 40)
						.overlay(
							Image("uvIndex")
								.resizable()
								.scaledToFit()
								.padding(7)
						)
					
					VStack(alignment: .leading) {
						Text("Air Pressure")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("\(pressure) ")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple) +
						Text("atm")
							.font(.custom("OktahRound-BdIt", size: 12))
							.foregroundColor(Color.darkPurple)
							
					}
				}
				.padding(.leading, 40)
				
				Spacer()
				HStack {
					Circle()
						.fill(Color.darkPurple)
						.frame(width: 40, height: 40)
						.overlay(
							Image("wind")
								.resizable()
								.scaledToFit()
								.padding(8)
						)
					
					VStack(alignment: .leading) {
						Text("Wind")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("\(wind) ")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple) +
						Text("mph")
							.font(.custom("OktahRound-BdIt", size: 12))
							.foregroundColor(Color.darkPurple)
					}
				}
				.padding(.trailing, 70)
			}
			.frame(maxWidth: .infinity)
		}
		.background(RoundedRectangle(cornerRadius: 20).fill(Color.lightBlue))
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}
}

