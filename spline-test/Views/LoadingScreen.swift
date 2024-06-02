//
//  LoadingScreen.swift
//  spline-test
//
//  Created by Viru Repalle on 5/20/24.
//

//import SwiftUI
//
//struct LoadingScreen: View {
//    var body: some View {
//        Image("chicken no background")
//        ProgressView()
//            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
//
//#Preview {
//    LoadingScreen()
//}



import SwiftUI

struct LoadingScreen: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color.customBlue.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("chicken no background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .darkPurple))
                    .scaleEffect(2)
                
                Spacer()
            }
        }
        .onAppear {
            // Simulate loading completion after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation {
                    isLoading = false
                }
            }
        }
        .opacity(isLoading ? 1 : 0)
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}


