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
    var didFindCode: (String) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(didFindCode: didFindCode)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let scanner = ScannerViewController()
        scanner.didFindCode = didFindCode
        scanner.coordinator = context.coordinator
        viewController.addChild(scanner)
        viewController.view.addSubview(scanner.view)
        scanner.didMove(toParent: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var didFindCode: (String) -> Void
        
        init(didFindCode: @escaping (String) -> Void) {
            self.didFindCode = didFindCode
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                      let stringValue = readableObject.stringValue else { return }
                didFindCode(stringValue)
            }
        }
    }
    
    class ScannerViewController: UIViewController {
        var didFindCode: ((String) -> Void)?
        var captureSession: AVCaptureSession!
        var coordinator: Coordinator?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            captureSession = AVCaptureSession()
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(coordinator, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                return
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if captureSession.isRunning {
                captureSession.stopRunning()
            }
        }
    }
}


