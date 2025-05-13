//
//  AddVehicle.swift
//  Nestify
//
//  Created by pham kha dinh on 13/5/25.
//

import SwiftUI
import Combine

struct AddVehicleView: View {
    @StateObject private var viewModel = AddVehicleViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Dropdown options
    let vehicleTypes: [Option] = [
        Option(label: "Chọn loại phương tiện", value: ""),
        Option(label: "Ô tô", value: "car"),
        Option(label: "Xe máy", value: "motorcycle"),
        Option(label: "Xe đạp", value: "bicycle"),
        Option(label: "Xe tải", value: "truck"),
        Option(label: "Thuyền", value: "boat"),
        Option(label: "Khác", value: "other")
    ]
    
    let fuelTypes: [Option] = [
        Option(label: "Chọn loại nhiên liệu", value: ""),
        Option(label: "Xăng", value: "gasoline"),
        Option(label: "Dầu diesel", value: "diesel"),
        Option(label: "Điện", value: "electric"),
        Option(label: "Hybrid", value: "hybrid"),
        Option(label: "Khí tự nhiên", value: "natural_gas"),
        Option(label: "Không sử dụng nhiên liệu", value: "none")
    ]
    
    let locations: [Option] = [
        Option(label: "Chọn vị trí lưu trữ", value: ""),
        Option(label: "Garage", value: "garage"),
        Option(label: "Bãi đỗ xe", value: "parking_lot"),
        Option(label: "Sân", value: "yard"),
        Option(label: "Đường phố", value: "street"),
        Option(label: "Bến tàu", value: "dock")
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
                        icon: "car.fill",
                        label: "Tên phương tiện",
                        placeholder: "Nhập tên phương tiện",
                        text: $viewModel.name,
                        keyboardType: .default,
                        isValid: !viewModel.name.isEmpty
                    )
                    
                    // Vehicle type dropdown
                    CustomDropdown(
                        icon: "car.2.fill",
                        label: "Loại phương tiện",
                        value: $viewModel.vehicleType,
                        options: vehicleTypes,
                        primaryColor: primaryColor
                    )
                    .zIndex(5)
                    
                    // Make field (manufacturer)
                    CustomTextField(
                        icon: "building.2.fill",
                        label: "Hãng sản xuất",
                        placeholder: "Nhập hãng sản xuất",
                        text: $viewModel.make,
                        keyboardType: .default
                    )
                    
                    // Model field
                    CustomTextField(
                        icon: "airplane",
                        label: "Model",
                        placeholder: "Nhập model",
                        text: $viewModel.model,
                        keyboardType: .default
                    )
                    
                    // Year field
                    CustomTextField(
                        icon: "calendar",
                        label: "Năm sản xuất",
                        placeholder: "Nhập năm sản xuất",
                        text: $viewModel.year,
                        keyboardType: .numberPad
                    )
                    
                    // License plate field
                    CustomTextField(
                        icon: "rectangle.fill",
                        label: "Biển số xe",
                        placeholder: "Nhập biển số xe",
                        text: $viewModel.licensePlate,
                        keyboardType: .default
                    )
                    
                    // Vehicle identification number
                    CustomTextField(
                        icon: "barcode",
                        label: "Số khung (VIN)",
                        placeholder: "Nhập số khung (VIN)",
                        text: $viewModel.vin,
                        keyboardType: .default
                    )
                    
                    // Color field
                    CustomTextField(
                        icon: "paintpalette.fill",
                        label: "Màu sắc",
                        placeholder: "Nhập màu sắc",
                        text: $viewModel.color,
                        keyboardType: .default
                    )
                    
                    // Fuel type dropdown
                    CustomDropdown(
                        icon: "fuelpump.fill",
                        label: "Loại nhiên liệu",
                        value: $viewModel.fuelType,
                        options: fuelTypes,
                        primaryColor: primaryColor
                    )
                    .zIndex(4)
                    
                    // Storage location dropdown
                    CustomDropdown(
                        icon: "mappin.and.ellipse",
                        label: "Vị trí lưu trữ",
                        value: $viewModel.storageLocation,
                        options: locations,
                        primaryColor: primaryColor
                    )
                    .zIndex(3)
                    
                    // Date pickers and additional info
                    VStack(spacing: 20) {
                        SectionHeader(title: "Thông tin thời gian", icon: "calendar")
                        
                        HStack(spacing: 16) {
                            // Purchase date
                            CustomDatePicker(label: "Ngày mua", date: Binding<Date?>(
                                get: { viewModel.purchaseDate },
                                set: { viewModel.purchaseDate = $0! }
                            ))
                            
                            // Last service date
                            CustomDatePicker(label: "Lần bảo dưỡng gần nhất", date: Binding<Date?>(
                                get: { viewModel.lastServiceDate },
                                set: { viewModel.lastServiceDate = $0! }
                            ))
                        }
                        
                        HStack(spacing: 16) {
                            // Insurance expiry date
                            CustomDatePicker(label: "Ngày hết hạn bảo hiểm", date: Binding<Date?>(
                                get: { viewModel.insuranceExpiryDate },
                                set: { viewModel.insuranceExpiryDate = $0! }
                            ))
                            
                            // Registration expiry date
                            CustomDatePicker(label: "Ngày hết hạn đăng kiểm", date: Binding<Date?>(
                                get: { viewModel.registrationExpiryDate },
                                set: { viewModel.registrationExpiryDate = $0! }
                            ))
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Additional details section
                    SectionHeader(title: "Thông tin chi tiết", icon: "doc.text.fill")
                    
                    // Price field
                    CustomTextField(
                        icon: "dollarsign.circle.fill",
                        label: "Giá mua",
                        placeholder: "Nhập giá mua",
                        text: $viewModel.purchasePrice,
                        keyboardType: .decimalPad
                    )
                    
                    // Current odometer field
                    CustomTextField(
                        icon: "speedometer",
                        label: "Số km hiện tại",
                        placeholder: "Nhập số km hiện tại",
                        text: $viewModel.currentOdometer,
                        keyboardType: .decimalPad
                    )
                    
                    // Service interval field
                    CustomTextField(
                        icon: "wrench.and.screwdriver.fill",
                        label: "Chu kỳ bảo dưỡng (km)",
                        placeholder: "Nhập số km giữa các lần bảo dưỡng",
                        text: $viewModel.serviceInterval,
                        keyboardType: .numberPad
                    )
                    
                    // Save button with gradient and animation
                    Button(action: {
                        withAnimation {
                            viewModel.saveVehicle()
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
                                    
                                    Text("Lưu phương tiện")
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
        .navigationTitle("Thêm phương tiện")
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
