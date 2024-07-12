//
//  FilePicker.swift
//  LMS_Admin_Librarian
//
//  Created by Vanshaj on 08/07/24.
//

import SwiftUI
import UIKit

struct FilePicker: UIViewControllerRepresentable {
    var documentTypes: [String]
    var onPick: (URL) -> Void
    @Binding var showAlert: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick, showAlert: $showAlert)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void
        @Binding var showAlert: Bool
        
        init(onPick: @escaping (URL) -> Void, showAlert: Binding<Bool>) {
            self.onPick = onPick
            self._showAlert = showAlert
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Validate the file extension
            if url.pathExtension.lowercased() == "xlsx" {
                onPick(url)
                showAlert = true
            } else {
                presentInvalidFileTypeAlert(controller: controller)
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation if needed
        }
        
        private func presentInvalidFileTypeAlert(controller: UIDocumentPickerViewController) {
            let alert = UIAlertController(title: "Invalid File Type",
                                          message: "Please select a .xlsx file.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
