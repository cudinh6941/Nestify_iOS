//
//  AddPlantView.swift
//  Nestify
//
//  Created by pham kha dinh on 13/5/25.
//

import SwiftUI
import Combine

struct AddPlantView: View {
    @StateObject private var viewModel = AddPlantViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Dropdown options
    let locations: [Option] = [
        Option(label: "Chọn vị trí", value: ""),
        Option(label: "Phòng khách", value: "living_room"),
        Option(label: "Phòng ngủ", value: "bedroom"),
        Option(label: "Nhà bếp", value: "kitchen"),
        Option(label: "Ban công", value: "balcony"),
        Option(label: "Sân vườn", value: "garden"),
        Option(label: "Phòng làm việc", value: "office")
    ]
    
    let sunlightRequirements: [Option] = [
        Option(label: "Chọn nhu cầu ánh sáng", value: ""),
        Option(label: "Nhiều nắng", value: "full_sun"),
        Option(label: "Nắng một phần", value: "partial_sun"),
        Option(label: "Bóng râm", value: "shade"),
        Option(label: "Ít ánh sáng", value: "low_light")
    ]
    
    let soilTypes: [Option] = [
        Option(label: "Chọn loại đất", value: ""),
        Option(label: "Đất thông thường", value: "regular"),
        Option(label: "Đất pha cát", value: "sandy"),
        Option(label: "Đất sét", value: "clay"),
        Option(label: "Đất trồng xương rồng", value: "cactus"),
        Option(label: "Đất giữ ẩm", value: "moisture_retaining")
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
                        icon: "leaf.fill",
                        label: "Tên cây",
                        placeholder: "Nhập tên cây",
                        text: $viewModel.name,
                        keyboardType: .default,
                        isValid: !viewModel.name.isEmpty
                    )
                    
                    // Species field
                    CustomTextField(
                        icon: "sparkles",
                        label: "Loài",
                        placeholder: "Nhập loài cây",
                        text: $viewModel.species,
                        keyboardType: .default,
                        isValid: !viewModel.species.isEmpty
                    )
                    
                    // Location dropdown
                    CustomDropdown(
                        icon: "mappin.and.ellipse",
                        label: "Vị trí",
                        value: $viewModel.location,
                        options: locations,
                        primaryColor: primaryColor
                    )
                    .zIndex(5)
                    
                    // Sunlight requirements dropdown
                    CustomDropdown(
                        icon: "sun.max.fill",
                        label: "Nhu cầu ánh sáng",
                        value: $viewModel.sunlightRequirements,
                        options: sunlightRequirements,
                        primaryColor: primaryColor
                    )
                    .zIndex(4)
                    
                    // Soil type dropdown
                    CustomDropdown(
                        icon: "square.3.layers.3d.down.right.fill",
                        label: "Loại đất",
                        value: $viewModel.soilType,
                        options: soilTypes,
                        primaryColor: primaryColor
                    )
                    .zIndex(3)
                    
                    // Watering section
                    SectionHeader(title: "Lịch chăm sóc", icon: "drop.fill")
                    
                    // Watering frequency
                    CustomTextField(
                        icon: "drop.fill",
                        label: "Tần suất tưới nước (ngày)",
                        placeholder: "Nhập số ngày giữa các lần tưới",
                        text: $viewModel.wateringFrequency,
                        keyboardType: .numberPad
                    )
                    
                    // Fertilizing frequency
                    CustomTextField(
                        icon: "leaf.arrow.circlepath",
                        label: "Tần suất bón phân (ngày)",
                        placeholder: "Nhập số ngày giữa các lần bón phân",
                        text: $viewModel.fertilizingFrequency,
                        keyboardType: .numberPad
                    )
                    
                    // Date pickers in a card
                    VStack(spacing: 20) {
                        SectionHeader(title: "Thông tin thời gian", icon: "calendar")
                        
                        HStack(spacing: 16) {
                            // Planting date
                            CustomDatePicker(label: "Ngày trồng", date: Binding<Date?>(
                                get: { viewModel.plantingDate },
                                set: { viewModel.plantingDate = $0! }
                            ))
                            
                            // Last watering date
                            CustomDatePicker(label: "Lần tưới gần nhất", date: Binding<Date?>(
                                get: { viewModel.lastWateringDate },
                                set: { viewModel.lastWateringDate = $0! }
                            ))
                        }
                        
                        HStack(spacing: 16) {
                            // Last fertilizing date
                            CustomDatePicker(label: "Lần bón phân gần nhất", date: Binding<Date?>(
                                get: { viewModel.lastFertilizingDate },
                                set: { viewModel.lastFertilizingDate = $0! }
                            ))
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Notes field
                    CustomTextField(
                        icon: "note.text",
                        label: "Ghi chú",
                        placeholder: "Thêm ghi chú về cây",
                        text: $viewModel.notes,
                        keyboardType: .default
                    )
                    
                    // Save button with gradient and animation
                    Button(action: {
                        withAnimation {
                            viewModel.savePlant()
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
                                    
                                    Text("Lưu cây")
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
        .navigationTitle("Thêm cây cối")
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
