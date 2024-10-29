import SwiftUI

struct ClassifyView: View {
    let selectedImage: UIImage
    @State private var classificationResults: [YOLOv5sOutput] = []
    @State private var processedImage: UIImage?
    var selectedModel: String?  // Pass the selected model
    @State private var isSavedAlertPresented: Bool = false // To show an alert after saving

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Classification Result")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color("buttons"))
                
                if let processedImage = processedImage {
                    VStack {
                        Image(uiImage: processedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                            .padding(.horizontal, 20)
                        
                        // Legend with side margins
                        HStack(spacing: 15) {
                            legendItem(color: Color(uiColor: .systemIndigo), label: "Comedone")
                            legendItem(color: Color(uiColor: .systemCyan), label: "Papule")
                            legendItem(color: Color(uiColor: .systemYellow), label: "Pustule")
                            legendItem(color: Color(uiColor: .systemTeal), label: "Nodule")
                            legendItem(color: Color(uiColor: .systemPurple), label: "Cyst")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Download button
                        Button(action: {
                            saveImageToPhotoLibrary(image: processedImage)
                        }) {
                            Text("Download")
                                .frame(width: 207, height: 50)
                                .background(Color("buttons"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.system(size: 22, weight: .bold))
                                .padding(.top, 10)
                        }
                        .padding(.top, 10)
                        .alert(isPresented: $isSavedAlertPresented) {
                            Alert(title: Text("Image Saved"),
                                  message: Text("The processed image has been saved to your photo library."),
                                  dismissButton: .default(Text("OK")))
                        }
                    }
                } else {
                    ProgressView()
                        .frame(height: geometry.size.height * 0.6)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
        .navigationTitle("")
        .onAppear {
            classifyImage()
        }
    }
    
    private func legendItem(color: Color, label: String) -> some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(label)
                .foregroundColor(.black)
                .font(.caption)
        }
    }
    
    private func classifyImage() {
        let yolo: YOLOv5s?
        
        // Initialize the model based on the selectedModel
        if selectedModel == "Standalone Model" {
            yolo = YOLOv5s(useStandaloneModel: true)
            print("standalone selected")
        } else if selectedModel == "Proposed Model" {
            yolo = YOLOv5s(useStandaloneModel: false)
            print("proposed selected")
        } else {
            print("No valid model selected")
            return
        }
        
        guard let yoloModel = yolo else {
            print("Failed to initialize YOLOv5s model")
            return
        }
        
        let results = yoloModel.detect(image: selectedImage)
        self.classificationResults = results
        
        let processedImage = drawBoundingBoxes(on: selectedImage, with: results)
        self.processedImage = processedImage
    }
    
    private func drawBoundingBoxes(on image: UIImage, with results: [YOLOv5sOutput]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let processedImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let ctx = context.cgContext
            ctx.setLineWidth(6)  // Thicker line for better visibility
            
            let scaleX = image.size.width / 640
            let scaleY = image.size.height / 640
            
            let baseBoxSize: CGFloat = 30  // Base size for the bounding box
            let baseFontSize: CGFloat = 20  // Base font size for the labels
            
            for result in results {
                let color: UIColor
                let textColor: UIColor
                
                switch result.classLabel {
                    case "comedone":
                        color = .systemIndigo
                        textColor = .black
                    case "papule":
                        color = .systemCyan
                        textColor = .black
                    case "pustule":
                        color = .systemYellow
                        textColor = .black
                    case "nodule":
                        color = .systemTeal
                        textColor = .black
                    case "cyst":
                        color = .systemPurple
                        textColor = .black
                    default:
                        color = .systemGray
                        textColor = .black
                }
                
                ctx.setStrokeColor(color.cgColor)
                
                let boxWidth = baseBoxSize * min(scaleX, scaleY)
                let boxHeight = baseBoxSize * min(scaleX, scaleY)
                
                let centerX = result.boundingBox.midX * scaleX
                let centerY = result.boundingBox.midY * scaleY
                
                let rect = CGRect(x: centerX - boxWidth / 2, y: centerY - boxHeight / 2, width: boxWidth, height: boxHeight)
                
                ctx.addRect(rect)
                ctx.strokePath()
                
                let dynamicFontSize = baseFontSize * min(scaleX, scaleY)
                let label = "\(result.classLabel) (\(String(format: "%.2f", result.confidence)))"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: dynamicFontSize),
                    .foregroundColor: textColor
                ]
                
                let size = label.size(withAttributes: attributes)
                let textRect = CGRect(x: rect.minX, y: max(rect.minY - size.height - 4, 0), width: size.width + 8, height: size.height + 4)
                
                ctx.setFillColor(color.cgColor)
                ctx.fill(textRect)
                
                label.draw(in: textRect, withAttributes: attributes)
            }
        }
        
        return processedImage
    }
    
    private func saveImageToPhotoLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        isSavedAlertPresented = true  // Show an alert after saving
    }
}
