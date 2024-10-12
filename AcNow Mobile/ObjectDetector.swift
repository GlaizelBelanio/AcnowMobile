import Vision
import CoreML

class ObjectDetector {
    private var model: VNCoreMLModel
    
    init() throws {
        guard let model = try? VNCoreMLModel(for: best(configuration: MLModelConfiguration()).model) else {
            throw NSError(domain: "ObjectDetector", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create VNCoreMLModel"])
        }
        self.model = model
    }
    
    func detect(image: CGImage, completion: @escaping (Result<[VNRecognizedObjectObservation], Error>) -> Void) {
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion(.failure(NSError(domain: "ObjectDetector", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])))
                return
            }
            
            completion(.success(results))
        }
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
}
