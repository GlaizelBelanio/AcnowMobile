import CoreML


// Helper function to convert MLMultiArray to a readable array
extension MLMultiArray {
    func toArray() -> [[Float32]] {
        let pointer = UnsafeMutablePointer<Float32>(OpaquePointer(self.dataPointer))
        let buffer = UnsafeBufferPointer(start: pointer, count: self.count)
        let array = Array(buffer)
        
        return stride(from: 0, to: array.count, by: 10).map {
            Array(array[$0..<min($0 + 10, array.count)])
        }
    }
}
