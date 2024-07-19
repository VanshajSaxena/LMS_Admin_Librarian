//
//  QR Scanner.swift
//  LMSAdminLibrarian
//
//  Created by ttcomputer on 16/07/24.
//


import SwiftUI
import AVFoundation
import Foundation

struct QRScannerView: UIViewControllerRepresentable {
    var completion: (String) async -> Void

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRScannerView
        var captureSession: AVCaptureSession?

        init(parent: QRScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
                    if let metadataObject = metadataObjects.first {
                        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                        guard let stringValue = readableObject.stringValue else { return }
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        Task {
                            do {
                                try await parent.completion(stringValue)
                            } catch {
                                print("Error processing QR code: \(error.localizedDescription)")
                            }
                        }
                        captureSession?.stopRunning()
                    }
                }
            }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        // Configure the camera to landscape mode
        if let connection = previewLayer.connection, connection.isVideoOrientationSupported {
            connection.videoOrientation = .landscapeRight
        }

        context.coordinator.captureSession = captureSession
        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
