import SwiftUI
import SplineRuntime

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
                        Spacer()
                        // Rectangle to cover the Spline logo with custom color
                        Rectangle()
                            .fill(Color(red: 116/255, green: 174/255, blue: 222/255))
                            .frame(height: 150) // Adjust the height as needed
                            .frame(maxWidth: .infinity)
                            .ignoresSafeArea(edges: .bottom)
                    }
                    
                    VStack {
                        Spacer() // Spacer to push content down
                            .frame(height: geometry.size.height * 0.55)
                        
                        VStack {
                            Text(weather.name)
                                .font(.title)
                                .foregroundColor(.white)
                            Text("\(weather.weather[0].main)")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(Int(weather.main.temp))°")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom, 100) // Adjusted padding to move the text further down
                        
                        Spacer() // Spacer to push content up
                    }
                    .frame(minHeight: geometry.size.height) // Ensures the VStack takes up the full height of the GeometryReader
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .refreshable {
                refreshAction()
            }
        }
    }
}
