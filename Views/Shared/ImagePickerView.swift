import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @State private var selectedImage: UIImage?
    @State private var isShowingActionSheet = false
    @State private var isShowingPhotoLibraryPicker = false
    @State private var isShowingCameraPicker = false
    
    var body: some View {
        VStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "photo")
                    .frame(width: 140, height: 140)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                    .background(Circle().fill(Color.gray.opacity(0.1)))
                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
            }
            
            Button {
                isShowingActionSheet = true
            } label: {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .confirmationDialog("Chọn nguồn ảnh", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
            Button("Chọn từ thư viện") {
                isShowingPhotoLibraryPicker = true
            }
            
            Button("Chụp ảnh mới") {
                isShowingCameraPicker = true
            }
            
            Button("Hủy", role: .cancel) { }
        }
        .sheet(isPresented: $isShowingPhotoLibraryPicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $isShowingCameraPicker) {
            CameraImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage, error == nil else { return }
                        self?.parent.selectedImage = image
                    }
                }
            }
        }
    }
}

// Camera Image Picker
struct CameraImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Permissions Info.plist requirements
/*
 Add these keys to your Info.plist file:
 
 For camera access:
 <key>NSCameraUsageDescription</key>
 <string>App needs camera access to take photos</string>
 
 For photo library access:
 <key>NSPhotoLibraryUsageDescription</key>
 <string>App needs photo library access to select photos</string>
 */
