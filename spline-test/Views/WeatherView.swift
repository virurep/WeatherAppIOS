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
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				ZStack {
					// Fetching from cloud
					let url = URL(string: "https://build.spline.design/LcgX-F1ByWjAJ1iYKWFO/scene.splineswift")!
					
					// Spline View
					if let splineView = try? SplineView(sceneFileURL: url) {
						splineView.ignoresSafeArea(.all)
					} else {
						Text("Failed to load Spline view")
							.ignoresSafeArea(.all)
					}
					
					VStack {
						HeaderView(city: weather.name)
							.padding(.top, 60)
							.ignoresSafeArea(edges: .top)

						Spacer(minLength: 220)

						WeatherIconView(temp: Int(weather.main.temp), description: weather.weather[0].main)
							.frame(maxWidth: .infinity)
							.padding(.bottom, 15)
						
						WeatherDetailsView()
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
		.ignoresSafeArea(.all) // Changed from .bottom to .all to extend to the bottom of the screen
	}
}

struct HeaderView: View {
	var city: String
	
	var body: some View {
		VStack {
			Text(city)
				.font(.custom("OktahRound-BdIt", size: 40))
				.foregroundColor(Color.darkPurple)
			
			Text("Monday, May 20")
				.font(.custom("OktahRound-BdIt", size: 16))
				.foregroundColor(Color.darkPurple)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

struct WeatherIconView: View {
	var temp: Int
	var description: String
	
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
			
			Text("High 71° | Low 60°")
				.font(.custom("OktahRound-BdIt", size: 16))
				.foregroundColor(Color.darkPurple)
		}
	}
}

struct WeatherDetailsView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Text("Weather Now")
				.font(.custom("OktahRound-BdIt", size: 20))
				.foregroundColor(Color.darkPurple)
				.padding(.bottom, 10)
				.padding(.top, 10)
				.padding(.leading, 40)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			HStack(spacing: 20) {
				HStack {
					Image(systemName: "thermometer")
						.foregroundColor(Color.darkPurple)
					VStack(alignment: .leading) {
						Text("Feels Like")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("65°")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple)
					}
				}
				HStack {
					Image(systemName: "cloud.rain")
						.foregroundColor(Color.darkPurple)
					VStack(alignment: .leading) {
						Text("Precipitation")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("95%")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple)
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
			
			HStack(spacing: 20) {
				HStack {
					Image(systemName: "sun.max")
						.foregroundColor(Color.darkPurple)
					VStack(alignment: .leading) {
						Text("UV Index")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("5")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple)
					}
				}
				HStack {
					Image(systemName: "wind")
						.foregroundColor(Color.darkPurple)
					VStack(alignment: .leading) {
						Text("Wind")
							.font(.custom("OktahRound-BdIt", size: 16))
							.foregroundColor(Color.darkPurple)
						Text("6 mph")
							.font(.custom("OktahRound-BdIt", size: 24))
							.foregroundColor(Color.darkPurple)
					}
				}
			}
			.frame(maxWidth: .infinity)
		}
		.background(RoundedRectangle(cornerRadius: 20).fill(Color.lightBlue))
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}
}
