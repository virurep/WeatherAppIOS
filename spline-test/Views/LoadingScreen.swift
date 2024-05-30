//
//  LoadingScreen.swift
//  spline-test
//
//  Created by Viru Repalle on 5/20/24.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        Image("chicken no background")
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingScreen()
}
