import CoreGraphics

// Define IoU function to compute Intersection over Union
func computeIoU(boxA: CGRect, boxB: CGRect) -> CGFloat {
    let intersectionRect = boxA.intersection(boxB)
    
    if intersectionRect.isNull {
        return 0.0
    }
    
    let intersectionArea = intersectionRect.width * intersectionRect.height
    let areaA = boxA.width * boxA.height
    let areaB = boxB.width * boxB.height
    
    let unionArea = areaA + areaB - intersectionArea
    
    return intersectionArea / unionArea
}

// Non-Maximum Suppression (NMS) function
func nonMaximumSuppression(detections: [DetectionResult], iouThreshold: CGFloat) -> [DetectionResult] {
    // Step 1: Sort detections by confidence score in descending order
    var sortedDetections = detections.sorted { $0.confidence > $1.confidence }
    
    var result: [DetectionResult] = []
    
    while !sortedDetections.isEmpty {
        // Step 2: Pick the detection with the highest confidence
        let currentDetection = sortedDetections.removeFirst()
        result.append(currentDetection)
        
        // Step 3: Remove all detections that overlap with the selected detection beyond the IoU threshold
        sortedDetections.removeAll { detection in
            let iou = computeIoU(boxA: currentDetection.boundingBox, boxB: detection.boundingBox)
            return iou > iouThreshold
        }
    }
    
    return result
}
