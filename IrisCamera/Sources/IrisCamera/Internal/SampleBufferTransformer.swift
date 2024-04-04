import AVKit
import CoreImage
import Foundation

struct SampleBufferTransformer {
    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }

        let sourceImage = CIImage(cvImageBuffer: pixelBuffer)
        
        guard let filter = CIFilter(name: "CIColorInvert", parameters: [kCIInputImageKey: sourceImage]) else {
            print("failed to get filter")
            fatalError()
        }
        
        let filteredImage = filter.outputImage!

        let context = CIContext(options: [CIContextOption.outputColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!])
        context.render(filteredImage, to: pixelBuffer)
        
        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            fatalError()
        }

        return result
    }
}
