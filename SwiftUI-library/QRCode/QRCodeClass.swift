//
//  QRCodeClass.swift
//  SwiftUI-library
//
//  Created by Ehsan Azish on 1.02.2024.
//

import SwiftUI
import AVFoundation

/// `QRScannerController` is a UIViewController that manages the QR code scanning process using the device's camera.
class QRScannerController: UIViewController {
    // MARK: - Properties
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    // Delegate for handling capture session metadata output
    var delegate: AVCaptureMetadataOutputObjectsDelegate?

    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Attempt to get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }

        let videoInput: AVCaptureDeviceInput

        do {
            // Create an instance of AVCaptureDeviceInput with the given device
            videoInput = try AVCaptureDeviceInput(device: captureDevice)

        } catch {
            print(error)
            return
        }

        // Add the created input to the capture session
        captureSession.addInput(videoInput)

        // Initialize and set up the metadata output for the capture session
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr, .code128]

        // Set up the preview layer for the capture session
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start the capture session asynchronously
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}

/// `QRScanner` is a SwiftUI view that integrates with `QRScannerController` to present the camera view and handle QR code scanning.
struct QRScanner: UIViewControllerRepresentable {

    // MARK: - Properties
    @Binding var result: String

    // MARK: - UIViewControllerRepresentable Methods
    func makeUIViewController(context: Context) -> QRScannerController {
        let controller = QRScannerController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($result)
    }
}

/// `Coordinator` serves as the delegate for `AVCaptureMetadataOutputObjectsDelegate`, handling the result of the QR code scanning.
class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties
    @Binding var scanResult: String

    // Initialization with a binding to the scan result
    init(_ scanResult: Binding<String>) {
        self._scanResult = scanResult
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate Method
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        // Check if the metadataObjects array is not empty and process the QR code
        if metadataObjects.isEmpty {
            scanResult = "No QR code detected"
            return
        }

        // Get the first metadata object and process it if it's a QR or Code128 code
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == .qr || metadataObj.type == .code128,
               let result = metadataObj.stringValue {
                scanResult = result
                print(scanResult)
            }
        }
    }
}

