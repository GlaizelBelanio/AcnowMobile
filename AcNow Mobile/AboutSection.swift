import SwiftUI
import PhotosUI


// Updated About View with rounded rectangles and custom dots
struct AboutView: View {
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            // Logo
            Image("logo") // Use the name of your logo image
                .resizable()
                .scaledToFit()
                .frame(width: 306, height: 304)
                .padding(.top, -420)
                .zIndex(2)

            TabView(selection: $currentPage) {
                // First Slide: About Content
                Rectangle()
                    .fill(Color("bg")) // Background color from assets
                    .frame(width: 319, height: 500) // Updated dimensions for consistency
                    .cornerRadius(10) // Rounded corners with 10 point radius
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4) // Shadow
                    .overlay(
                        VStack(spacing: 0) {
                            Text("About")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, -50) // Consistent space above title
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4) // Shadow effect
                                .opacity(1)

                            Text(aboutText1)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10) // Padding around the text for consistency
                                .frame(maxWidth: 262) // Constrain the width
                                .lineSpacing(5)
                        }
                        .padding(.top, 10) // Reset padding to keep the title visible
                    )
                    .padding(.top, 40) // Adjust this value to move the rectangle up or down
                    .tag(0)

                // Second Slide: Team Content
                Rectangle()
                    .fill(Color("bg")) // Background color from assets
                    .frame(width: 319, height: 500) // Consistent dimensions
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    .overlay(
                        VStack(spacing: 20) { // Adjust spacing for team members
                            // The Team Title
                            Text("The Team")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center) // Center the title
                                .padding(.top, -60) // Consistent space above title
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                            // Team members' images and info in a vertical stack
                            VStack(spacing: 20) {
                                // First member
                                HStack {
                                    Image("Gelai") // Use the name of the Renz image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 84) // Size of the image

                                    VStack{
                                        Text("Name")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(height: 20) // Top Text
                                        
                                        Text("Role")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                            .frame(height: 20) // Bottom Text
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center) // Center the member info

                                // Second member
                                HStack {
                                    Image("Renz") // Use the name of Jane's image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 84)

                                    VStack{Text("Name")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                        
                                        Text("Role")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center) // Center the member info

                                // Third member
                                HStack {
                                    Image("Claude") // Use the name of John's image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 84)

                                    VStack{
                                        Text("Name")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                        
                                        Text("Role")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center) // Center the member info
                            }
                            .padding(.top, -10) // Adjust padding for the whole VStack
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                        }
                    )
                    .padding(.top, 50) // Same top padding as the first slide for consistency
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default dots

            // Custom Dots
            HStack {
                ForEach(0..<2, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 550) // Adjust this value to position the dots above the bottom of the rectangle
        }
        .padding(.top, -90)
    }

    private var aboutText1: String {
        """
        AcNow Mobile is designed to help users identify and understand their acne better. By using advanced AI technology, the app provides accurate and reliable classification of various types of acne, including whiteheads, blackheads, papules, pustules, nodules, and cysts. This makes it easier for users to manage their skin health by making more informed decisions and employing suitable self-treatments. AcNow Mobile aims to improve access to effective acne care, empowering users to take control of their skin health with confidence.
        """
    }
}
