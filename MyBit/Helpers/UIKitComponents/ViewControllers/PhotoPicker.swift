//
//  PhotoPicker.swift
//  MyBit
//
//  Created by SUCHAN CHANG on 6/16/24.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    let completion: (_ selectedImageData: Data) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(results)
            
            let itemProvider = results.first?.itemProvider
            if let itemProvider = itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self else { return }
                    guard error == nil else { return }
                    guard let image = image as? UIImage else { return }
                    guard let imageData = image.pngData() else { return }
                    if imageData.count <= (1 * 1024 * 1024) {
                        parent.completion(imageData)
                        parent.isPresented = false
                    } else {
                       print("용량이 1MB보다 큽니다")
                        // TODO: - 1MB 용량 제한 경고창 띄우기
                    }
                }
            }
        }
    }
    
}
