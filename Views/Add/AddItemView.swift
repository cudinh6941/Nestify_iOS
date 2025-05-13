//
//  AddItemView.swift
//  Nestify
//
//  Created by pham kha dinh on 5/5/25.
//

// MARK: - Add Item View
import SwiftUI
import Combine

struct AddItemView: View {
    @StateObject private var viewModel = AddItemViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Theme colors

    
    // Dropdown options
    let categories: [Option] = [
        Option(label: "Chọn danh mục", value: ""),
        Option(label: "Đồ điện tử", value: "electronic"),
        Option(label: "Đồ nội thất", value: "furniture"),
        Option(label: "Thiết bị nhà bếp", value: "kitchen"),
        Option(label: "Quần áo", value: "clothes"),
        Option(label: "Khác", value: "others")
    ]
    
    let locations: [Option] = [
        Option(label: "Chọn vị trí", value: ""),
        Option(label: "Phòng khách", value: "living_room"),
        Option(label: "Phòng ngủ", value: "bedroom"),
        Option(label: "Nhà bếp", value: "kitchen"),
        Option(label: "Phòng tắm", value: "bathroom"),
        Option(label: "Kho", value: "storage"),
        Option(label: "Sân", value: "yard")
    ]
    
    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(
                gradient: Gradient(colors: [backgroundColor, backgroundColor.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    ImagePickerView(
                        selectedImage: $viewModel.selectedImage,
                        imageData: $viewModel.imageData
                    )
                    
                    // Divider
                    RoundedRectangle(cornerRadius: 2)
                        .fill(dividerColor)
                        .frame(height: 4)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 8)
                    
                    // Basic info section
                    SectionHeader(title: "Thông tin cơ bản", icon: "info.circle.fill")
                    
                    // Name field with validation indicator
                    CustomTextField(
                        icon: "tag.fill",
                        label: "Tên vật dụng",
                        placeholder: "Nhập tên vật dụng",
                        text: $viewModel.name,
                        keyboardType: .default,
                        isValid: !viewModel.name.isEmpty
                    )
                    
                    // Category dropdown with modern design
                    CustomDropdown(
                        icon: "folder.fill",
                        label: "Danh mục",
                        value: $viewModel.category,
                        options: categories,
                        primaryColor: primaryColor
                    )
                    
                    .zIndex(4)
                    
                    // Location dropdown
                    CustomDropdown(
                        icon: "mappin.and.ellipse",
                        label: "Vị trí",
                        value: $viewModel.location,
                        options: locations,
                        primaryColor: primaryColor)
                    
                    .zIndex(3)
                    
                    // Date pickers in a card
                    VStack(spacing: 20) {
                        SectionHeader(title: "Thông tin thời gian", icon: "calendar")
                        
                        HStack(spacing: 16) {
                            // Purchase date
                            CustomDatePicker(label: "Ngày mua", date: Binding<Date?>(
                                get: { viewModel.purchaseDate },
                                set: { viewModel.purchaseDate = $0! }
                            ))
                     
                            CustomDatePicker(label: "Ngày mua", date: Binding<Date?>(
                                get: {  viewModel.warrantyExpiryDate },
                                set: { viewModel.warrantyExpiryDate = $0! }
                            ))
                   
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Additional details section
                    SectionHeader(title: "Thông tin chi tiết", icon: "doc.text.fill")
                    
                    CustomTextField(
                        icon: "tag.circle.fill",
                        label: "Thương hiệu",
                        placeholder: "Nhập thương hiệu",
                        text: $viewModel.brand,
                        keyboardType: .default
                    )
                    
                    CustomTextField(
                        icon: "number",
                        label: "Model",
                        placeholder: "Nhập model",
                        text: $viewModel.model,
                        keyboardType: .default
                    )
                    
                    CustomTextField(
                        icon: "barcode",
                        label: "Số serial",
                        placeholder: "Nhập số serial (nếu có)",
                        text: $viewModel.serialNumber,
                        keyboardType: .default
                    )
                    
                    // Flexible grid layout for price and quantity
                    HStack(spacing: 16) {
                        CustomTextField(
                            icon: "dollarsign.circle.fill",
                            label: "Giá",
                            placeholder: "Nhập giá",
                            text: $viewModel.price,
                            keyboardType: .numberPad
                        )
                        
                        CustomTextField(
                            icon: "number.circle.fill",
                            label: "Số lượng",
                            placeholder: "Nhập số lượng",
                            text: $viewModel.quantity,
                            keyboardType: .numberPad,
                            isValid: !viewModel.quantity.isEmpty
                        )
                    }
                    
                    // Save button with gradient and animation
                    Button(action: {
                        withAnimation {
                            viewModel.saveItem()
                        }
                    }) {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                            } else {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Lưu vật dụng")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            viewModel.isFormValid ?
                                LinearGradient(
                                    gradient: Gradient(colors: [secondaryColor, secondaryColor.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: viewModel.isFormValid ? secondaryColor.opacity(0.4) : Color.clear,
                            radius: 8, x: 0, y: 4
                        )
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Thêm vật dụng")
          .toolbar {
              ToolbarItem(placement: .navigationBarLeading) {
                  Button(action: {
                      dismiss()
                  }) {
                      Image(systemName: "chevron.left")
                          .font(.system(size: 16, weight: .semibold))
                          .foregroundColor(primaryColor)
                  }
              }
          }
        .alert(isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Lỗi"),
                message: Text(viewModel.errorMessage ?? "Đã xảy ra lỗi không xác định"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.isSuccess) { success in
            if success {
                dismiss()
            }
        }
    }
    

}

// MARK: - Supporting Components

// Section header component
struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "#4A9FF5"))
            
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}




