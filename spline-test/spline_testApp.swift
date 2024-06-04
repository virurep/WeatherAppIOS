//
//  spline_testApp.swift
//  spline-test
//
//  Created by Viru Repalle on 5/20/24.
//

import SwiftUI

@main
struct spline_testApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
