import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var selectedImage: UIImage?
    @Binding var imageData: Data? // Đổi tên từ imagedata sang imageData để nhất quán
    @State private var isShowingActionSheet = false
    @State private var isShowingPhotoLibraryPicker = false
    @State private var isShowingCameraPicker = false
    
    // Loại bỏ viewModel từ ImagePickerView để tránh xung đột
    // @StateObject private var viewModel = AddItemViewModel()
    
    // Theme colors
    private let backgroundColor = Color(hex: "#121212")
    private let cardBackgroundColor = Color(hex: "#1E1E1E")
    private let inputBackgroundColor = Color(hex: "#2A2A2A")
    private let primaryColor = Color(hex: "#4A9FF5")
    private let secondaryColor = Color(hex: "#2ECC71")
    private let accentColor = Color(hex: "#F1C40F")
    private let dangerColor = Color(hex: "#E74C3C")
    private let textPrimaryColor = Color.white
    private let textSecondaryColor = Color(hex: "#B3B3B3")
    private let textPlaceholderColor = Color(hex: "#777777")
    private let dividerColor = Color(hex: "#333333")
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardBackgroundColor)
                    .frame(height: 200)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                if let image = selectedImage {
                    // Display selected image with proper scaling
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(primaryColor.opacity(0.3), lineWidth: 2)
                        )
                } else if let data = imageData, let uiImage = UIImage(data: data) {
                    // Display image from Data if available
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(primaryColor.opacity(0.3), lineWidth: 2)
                        )
                } else {
                    // No image placeholder
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 36))
                            .foregroundColor(primaryColor.opacity(0.8))
                        
                        Text("Thêm ảnh vật dụng")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(textSecondaryColor)
                    }
                }
                
                // Upload button overlay in bottom right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingActionSheet = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill((selectedImage == nil && imageData == nil) ? secondaryColor : primaryColor)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: ((selectedImage == nil && imageData == nil) ? secondaryColor : primaryColor).opacity(0.3), radius: 5, x: 0, y: 2)
                                
                                Image(systemName: (selectedImage == nil && imageData == nil) ? "plus" : "pencil")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(16)
                    }
                }
                
                // "Remove" button if image exists
                if selectedImage != nil || imageData != nil {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedImage = nil
                                    imageData = nil
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#E74C3C"))
                                        .frame(width: 32, height: 32)
                                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                                    
                                    Image(systemName: "xmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(16)
                        }
                        Spacer()
                    }
                }
            }
            
            Text((selectedImage == nil && imageData == nil) ?
                "Thêm ảnh để dễ dàng nhận diện vật dụng của bạn" :
                "Chạm vào ảnh để xem chi tiết")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(textSecondaryColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .confirmationDialog("Chọn nguồn ảnh", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
            Button("Chọn từ thư viện") {
                isShowingPhotoLibraryPicker = true
            }
            
            Button("Chụp ảnh mới") {
                isShowingCameraPicker = true
            }
            
            if selectedImage != nil || imageData != nil {
                Button("Xóa ảnh hiện tại", role: .destructive) {
                    withAnimation {
                        selectedImage = nil
                        imageData = nil
                    }
                }
            }
            
            Button("Hủy", role: .cancel) { }
        }
        .sheet(isPresented: $isShowingPhotoLibraryPicker) {
            ImagePicker(selectedImage: $selectedImage, imageData: $imageData)
        }
        .sheet(isPresented: $isShowingCameraPicker) {
            CameraImagePicker(selectedImage: $selectedImage, imageData: $imageData)
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var imageData: Data?
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
                        // Cập nhật cả imageData
                        self?.parent.imageData = image.jpegData(compressionQuality: 0.5)
                    }
                }
            }
        }
    }
}

// Camera Image Picker
struct CameraImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var imageData: Data?
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
                // Cập nhật cả imageData
                parent.imageData = image.jpegData(compressionQuality: 0.5)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

