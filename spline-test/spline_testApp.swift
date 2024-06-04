//
//  spline_testApp.swift
//  spline-test
//
//  Created by Viru Repalle on 5/20/24.
//

import SwiftUI
import Firebase

@main
struct spline_testApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
