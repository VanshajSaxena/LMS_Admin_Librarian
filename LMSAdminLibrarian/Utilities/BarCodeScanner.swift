//
//  BarCodeScanner.swift
//  BookInfo
//
//  Created by Hitesh Rupani on 04/07/24.
//

import UIKit
import SwiftUI
import AVFoundation


struct BarCodeScanner : UIViewControllerRepresentable {
    
    @Binding var isbn: String
    @Binding var foundBooks: BooksAPI?
    
    @Environment(\.presentationMode) private var presentationMode
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.black
        
        context.coordinator.captureSession = AVCaptureSession()
        
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { fatalError() }
        let videoInput: AVCaptureDeviceInput
        videoInput = try! AVCaptureDeviceInput(device: videoCaptureDevice)
        
        
        if (context.coordinator.captureSession.canAddInput(videoInput)) {
            context.coordinator.captureSession.addInput(videoInput)
        } else {
            print("Could not add input to capture session")
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (context.coordinator.captureSession.canAddOutput(metadataOutput)) {
            context.coordinator.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            
            print("Outputproblem")
        }
        
        context.coordinator.previewLayer = AVCaptureVideoPreviewLayer(session: context.coordinator.captureSession)
        context.coordinator.previewLayer.frame = vc.view.layer.bounds
        context.coordinator.previewLayer.videoGravity = .resizeAspectFill
        vc.view.layer.addSublayer(context.coordinator.previewLayer)
        
        context.coordinator.captureSession.startRunning()
        
        
        return vc
    }
    
    
    
    
    class Coordinator : NSObject, AVCaptureMetadataOutputObjectsDelegate {
        let parent: BarCodeScanner
        
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        
        init(_ parent: BarCodeScanner) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) async {
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                await found(code: stringValue)
                captureSession.stopRunning()
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func found(code: String) async {
            print(code)
            parent.isbn = code
            let metaData: BooksAPI = BooksAPI(items: [])
            
            do {
                var metaData = try await GoogleBookService().getBookMetaData(isbn: code)
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.parent.foundBooks = metaData
                
                print(metaData.items.first?.volumeInfo ?? "didn't work")
            }
        }
    }
}


