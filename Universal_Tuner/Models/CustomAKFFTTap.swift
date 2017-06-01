
import Foundation
import AudioKit

/// FFT Calculation for any node
@objc open class CustomAKFFTTap: NSObject, EZAudioFFTDelegate {
    
    internal let bufferSize: UInt32 = 8192
    internal var fft: EZAudioFFT?
    
    /// Array of FFT data
    let fftDataSize = 4096
    open var fftData = [Double](zeros: 4096)
    
    /// Initialze the FFT calculation on a given node
    ///
    /// - parameter input: Node on whose output the FFT will be computed
    ///
    public init(_ input: AKNode) {
        super.init()
        fft = EZAudioFFT(maximumBufferSize: vDSP_Length(bufferSize), sampleRate: Float(AKSettings.sampleRate), delegate: self)
        input.avAudioNode.installTap(onBus: 0, bufferSize: bufferSize, format: AudioKit.format) { [weak self] (buffer, time) -> Void in
            guard let strongSelf = self else { return }
            buffer.frameLength = strongSelf.bufferSize
            let offset = Int(buffer.frameCapacity - buffer.frameLength)
            let tail = buffer.floatChannelData?[0]
            strongSelf.fft!.computeFFT(withBuffer: &tail![offset],
                                       withBufferSize: strongSelf.bufferSize)
        }
    }
    
    /// Callback function for FFT computation
    @objc open func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>, bufferSize: vDSP_Length) {
        DispatchQueue.main.async { () -> Void in
            for i in 0..<self.fftDataSize {
                self.fftData[i] = Double(fftData[i])
            }
        }
    }
}
