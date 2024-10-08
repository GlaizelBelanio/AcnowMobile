import SwiftUI
import PhotosUI
import CoreML
import Vision



struct CaptureView: View {
    @State private var selectedImage: UIImage?
       @State private var isImagePickerPresented: Bool = false
       @State private var isCameraPresented: Bool = false
       @State private var classificationResult: [DetectionResult] = []
       @State private var showClassifyView: Bool = false

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
                        .padding(10)
                        .frame(width: 310, height: 400)
                        .cornerRadius(10)

                    // "X" button to remove the image
                    Button(action: {
                        // Clear the selected image
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

                    // Classify button
                    Button(action: {
                        classifyImage(image: selectedImage)
                    }) {
                        Text("Classify")
                            .frame(width: 100, height: 40)
                            .background(Color("buttons"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                        .padding(.top, 290)

                    // The NavigationLink is controlled by `showClassifyView`
                    NavigationLink(destination: ClassifyView(image: selectedImage, detectionResults: classificationResult), isActive: $showClassifyView) {
                        EmptyView()
                    }
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

            NavigationLink(destination: ClassifyView(image: selectedImage, detectionResults: classificationResult), isActive: $showClassifyView) {
                EmptyView()
            
            }
        }
        .padding(.top, 10)
        .background(Color.white.ignoresSafeArea())
    }

    func classifyImage(image: UIImage) {
        guard let model = try? best(configuration: MLModelConfiguration()) else {
            return
        }

        let targetSize = CGSize(width: 640, height: 640)
        guard let resizedImage = image.resize(to: targetSize),
              let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            return
        }

        do {
            let input = bestInput(image: pixelBuffer)
            let prediction = try model.prediction(input: input)
            let output = prediction.var_909
            let outputArray = output.toArray() as [[Float32]]

            let confidenceThreshold: Float32 = 0.1
            var detectionResults: [DetectionResult] = []

            for detection in outputArray {
                let confidence = detection[4]
                if confidence >= confidenceThreshold {
                    let x = detection[0]
                    let y = detection[1]
                    let width = detection[2]
                    let height = detection[3]
                    let classLabel = Int(detection[5])  // Adjusted for class label

                    let result = DetectionResult(
                        confidence: confidence,
                        boundingBox: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height)),
                        classLabel: classLabel
                    )
                    detectionResults.append(result)
                    print(result)
                }
            }

            // Apply Non-Maximum Suppression (NMS)
            let iouThreshold: CGFloat = 0.5
            self.classificationResult = nonMaximumSuppression(detections: detectionResults, iouThreshold: iouThreshold)
            self.showClassifyView = true

        } catch {
            print("Error in classifying image: \(error)")
        }
    }


}

struct ClassifyView: View {
    let image: UIImage?
    let detectionResults: [DetectionResult]

    var body: some View {
        VStack {
            // Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 306, height: 304)
                .padding(.top, -120)

            // Display the image with bounding boxes
            ZStack {
                if let image = image {
                    Image(uiImage: drawBoundingBoxes(on: image))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 420)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                } else {
                    Rectangle()
                        .fill(Color("bg"))
                        .frame(width: 320, height: 420)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                    
                    Text("No image available")
                        .foregroundColor(.white)
                        .padding()
                        .font(.system(size: 18))
                }
            }
            .padding(.top, -100)

            // Display detection results
            ScrollView {
                ForEach(detectionResults, id: \.id) { result in
                    Text("Class: \(result.classLabel), Confidence: \(String(format: "%.2f", result.confidence))")
                        .foregroundColor(.black)
                        .padding(5)
                }
            }
            .frame(height: 100)
        }
        .padding(.top, 10)
        .background(Color.white.ignoresSafeArea())
    }
    
    
    func drawBoundingBoxes(on image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            context.cgContext.setLineWidth(2)
            context.cgContext.setStrokeColor(UIColor.red.cgColor)
            
            for result in detectionResults {
                let box = result.boundingBox
                context.cgContext.addRect(box)
                context.cgContext.drawPath(using: .stroke)
                
                let label = "Class: \(result.classLabel)"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.white
                ]
                let size = label.size(withAttributes: attributes)
                let rect = CGRect(x: box.minX, y: box.minY - size.height, width: size.width, height: size.height)
                
                context.cgContext.setFillColor(UIColor.red.cgColor)
                context.fill(rect)
                
                label.draw(in: rect, withAttributes: attributes)
            }
        }
    }
}

struct DetectionResult: Identifiable {
    let id = UUID()
    let confidence: Float
    let boundingBox: CGRect
    let classLabel: Int
}



#Preview {
    ContentView()
}
