import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Logo
                Image("logo") // Use the name of your logo image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 306, height: 304)
                    .padding(.top, 20)

                // Start Button
                NavigationLink(destination: CaptureView()) {
                    Text("Start")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: 254, height: 64)
                        .background(Color("buttons")) // Use the buttons color from assets
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.top, 30)

                // About Button
                NavigationLink(destination: AboutView()) {
                    Text("About")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: 254, height: 64)
                        .background(Color("buttons")) // Use the buttons color from assets
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct CaptureView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isCameraPresented: Bool = false
    @State private var selectedModel: String? = nil // To store the selected model
    @State private var isClassifying = false

    let models = ["Standalone Model", "Proposed Model"] // The classification model options

    var body: some View {
        VStack {
            // Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 306, height: 304)
                .padding(.top, -160)

            // Image Placeholder
            ZStack {
                Rectangle()
                    .fill(Color("bg"))
                    .frame(width: 320, height: 420)
                    .cornerRadius(10)
                    .shadow(radius: 4)

                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                        .shadow(radius: 10)
                        .padding(10)
                        .frame(width: 310, height: 400)
                       

                    // "X" button to remove the image
                    Button(action: {
                        self.selectedImage = nil
                    }) {
                        Text("✖️")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding(.top, -205)
                    .padding(.leading, 275)

                    // Classify button with a dropdown menu
                    Menu {
                        ForEach(models, id: \.self) { model in
                            Button(action: {
                                self.selectedModel = model
                               
                                isClassifying = true
                            }) {
                                Text(model)
                            }
                        }
                    } label: {
                        Text("Classify")
                            .frame(width: 100, height: 40)
                            .background(Color("buttons"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 290)
                    
                    // NavigationLink for ClassifyView
                    NavigationLink(
                        destination: ClassifyView(selectedImage: selectedImage,selectedModel: selectedModel),
                            isActive: $isClassifying,
                            label: { EmptyView() }
                                )

                } else {
                    Text("No image selected")
                        .foregroundColor(.white)
                        .padding(10)
                        .font(.system(size: 22))
                }
            }
            .padding(.top, -100)

            // Capture Button
            Button(action: {
                isCameraPresented = true
            }) {
                Text("Capture Image")
                    .frame(width: 207, height: 50)
                    .background(Color("buttons"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.top, 20)
            .sheet(isPresented: $isCameraPresented) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            }

            // Choose Image Button
            Button(action: {
                isImagePickerPresented = true
            }) {
                Text("Choose Image")
                    .frame(width: 207, height: 50)
                    .background(Color("buttons"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.top, 10)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
            }
        }
        .padding(.top, 10)
        .background(Color.white.ignoresSafeArea())
    }

   
}




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
                                .padding(.top, -30) // Consistent space above title
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4) // Shadow effect
                                .opacity(1)

                            Text(aboutText1)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
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

                            
                            VStack(spacing: 20) {
                                
                                HStack {
                                    Image("Gelai") //
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 84) // Size of the image
                                        

                                    VStack{
                                        Text("Glaizel Nicole Belanio")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(height: 20) // Top Text
                                        
                                        Text("Frontend Developer")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                            .frame(height: 20) // Bottom Text
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center) // Center the member info

                                
                                HStack {
                                    Image("Renz")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 84)
                                        

                                    VStack{Text("       Renz Rey Sario       ")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                        
                                        Text("Project Manager")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center) // Center the member info

                                HStack {
                                    Image("Claude") 
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 84)

                                    VStack{
                                        Text("Claude Janin Ygrubay")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(height: 20)
                                        
                                        Text("Lead Developer")
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
        .padding(.top, -50)
    }

    private var aboutText1: String {
        """
        AcNow   Mobile  is   designed  to   help 
        users   identify   and  understand  their 
        acne better,offering guidance through 
        advanced AI-powered classification of 
        various    acne   types,   including white
        -heads,           blackheads,        papules, 
        pustules,    nodules,    and    cysts.   By 
        leveraging the enhanced accuracy and 
        balanced         detection         of         the 
        YOLOv5+CBAM     model,     the       app 
        minimizes      false     positives       while 
        providing    reliable   insights  to  assist 
        users  in  managing   their  skin  health. 
        However,  it  is  important  to  note that 
        AcNow    Mobile     is    solely     a    tool 
        for     guidance    and   cannot   replace 
        professional consultations with a 
        dermatologist.
        """
    }
}

// Image Picker for capturing images
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    ContentView()
}

