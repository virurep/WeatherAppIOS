//
//  ForecastView.swift
//  spline-test
//
//  Created by Viru Repalle on 5/22/24.
//

import SwiftUI

struct ForecastView: View {
    var forecast: ResponseBodyForecast

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(groupedForecastByDay(), id: \.date) { dailyData in
                    VStack(alignment: .leading) {
                        Text("Date: \(dailyData.date)")
                            .font(.headline)
                        Text("Max Temperature: \(dailyData.maxTemp, specifier: "%.1f") °F")
                        Text("Min Temperature: \(dailyData.minTemp, specifier: "%.1f") °F")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func groupedForecastByDay() -> [DailyForecast] {
        var dailyForecasts: [String: DailyForecast] = [:]
        
        for entry in forecast.list {
            let date = String(entry.dt_txt.prefix(10)) // Extract date part
            let temp = entry.main.temp
            
            if dailyForecasts[date] != nil {
                dailyForecasts[date]!.maxTemp = max(dailyForecasts[date]!.maxTemp, temp)
                dailyForecasts[date]!.minTemp = min(dailyForecasts[date]!.minTemp, temp)
            } else {
                dailyForecasts[date] = DailyForecast(date: date, maxTemp: temp, minTemp: temp)
            }
        }
        
        return dailyForecasts.values.sorted { $0.date < $1.date }
    }
}

struct DailyForecast {
    let date: String
    var maxTemp: Double
    var minTemp: Double
}
