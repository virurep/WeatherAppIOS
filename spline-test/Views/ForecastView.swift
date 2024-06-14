import SwiftUI

struct ForecastView: View {
    @State var forecast: ResponseBodyForecast
    @Binding var showForecast: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Header with city name and date
                VStack(alignment: .leading) {
                    ForecastHeaderView(city: forecast.city.name, showForecast: $showForecast)
                        .padding(.top, 60)
                        .ignoresSafeArea(edges: .top)
                }
                
                // Title for upcoming forecast
                Text("Upcoming Forecast")
                    .font(.custom("OktahRound-BdIt", size: 24))
                    .padding(.horizontal, 16)
                    .foregroundColor(Color.darkPurple)
                
                ForEach(groupedForecastByDay(), id: \.date) { dailyData in
                    ForecastRowView(dailyData: dailyData)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8) // Increased vertical padding for more spacing between rows
                }
            }
        }
        .background(Color.customBlue.edgesIgnoringSafeArea(.all)) // Changed background color to customBlue
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0) // Ensuring content is within the safe area
        }
    }
    
    private func groupedForecastByDay() -> [DailyForecast] {
        var dailyForecasts: [String: DailyForecast] = [:]
        
        for entry in forecast.list {
            let date = String(entry.dt_txt.prefix(10)) // Extract date part
            let temp = entry.main.temp
            let pop = entry.pop * 100 // Convert to percentage
            let description = entry.weather.first?.description.capitalized ?? "Unknown"
            print(description)
            
            if dailyForecasts[date] != nil {
                dailyForecasts[date]!.maxTemp = max(dailyForecasts[date]!.maxTemp, temp)
                dailyForecasts[date]!.minTemp = min(dailyForecasts[date]!.minTemp, temp)
                dailyForecasts[date]!.pop = max(dailyForecasts[date]!.pop, pop)
            } else {
                dailyForecasts[date] = DailyForecast(date: date, maxTemp: temp, minTemp: temp, pop: pop, description: description)
            }
        }
        
        return dailyForecasts.values.sorted { $0.date < $1.date }
    }
}


struct ForecastHeaderView: View {
    var city: String
    @Binding var showForecast: Bool
    @State private var showMenu = false
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    Button(action: {
                        showForecast = false
                    }) {
                        Label("Home", systemImage: "house")
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

struct ForecastRowView: View {
    var dailyData: DailyForecast
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center) {
                Text(formattedDay(dailyData.date))
                    .font(.custom("OktahRound-BdIt", size: 16))
                    .foregroundColor(Color.darkPurple)
                Text(formattedMonthDay(dailyData.date))
                    .font(.custom("OktahRound-BdIt", size: 16))
                    .foregroundColor(Color.darkPurple)
            }
            
            Spacer()
            
            VStack {
                Text(dailyData.description) // Centered weather description
                    .font(.custom("OktahRound-BdIt", size: 16))
                    .foregroundColor(Color.darkPurple)
            }
            
            Spacer()
            
            Text("\(Int(dailyData.maxTemp))°")
                .font(.custom("OktahRound-BdIt", size: 32))
                .foregroundColor(Color.darkPurple)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    private func formattedDay(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = formatter.date(from: date) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: dateObj)
        }
        return date
    }
    
    private func formattedMonthDay(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = formatter.date(from: date) {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: dateObj)
        }
        return date
    }
}

struct DailyForecast {
    let date: String
    var maxTemp: Double
    var minTemp: Double
    var pop: Double
    var description: String
}
