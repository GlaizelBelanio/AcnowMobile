import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 306, height: 304)
                    .padding(.top, 20)

                // Start Button
                NavigationLink(destination: CaptureView()) {
                    Text("Start")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: 254, height: 64)
                        .background(Color("buttons"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)

                // About Button
                NavigationLink(destination: AboutView()) {
                    Text("About")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: 254, height: 64)
                        .background(Color("buttons"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
        }
    }
}
