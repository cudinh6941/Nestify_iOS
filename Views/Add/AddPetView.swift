//
//  AddPetView.swift
//  Nestify
//
//  Created by pham kha dinh on 6/5/25.
//

import SwiftUI
import Combine

struct AddPetView: View {
    @StateObject private var viewModel = AddPetViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Dropdown options
    let species: [Option] = [
        Option(label: "Chọn loài", value: ""),
        Option(label: "Chó", value: "dog"),
        Option(label: "Mèo", value: "cat"),
        Option(label: "Chim", value: "bird"),
        Option(label: "Cá", value: "fish"),
        Option(label: "Bò sát", value: "reptile"),
        Option(label: "Khác", value: "other")
    ]
    
    let genders: [Option] = [
        Option(label: "Chọn giới tính", value: ""),
        Option(label: "Đực", value: "male"),
        Option(label: "Cái", value: "female"),
        Option(label: "Không xác định", value: "unknown")
    ]
    
    let locations: [Option] = [
        Option(label: "Chọn vị trí", value: ""),
        Option(label: "Phòng khách", value: "living_room"),
        Option(label: "Phòng ngủ", value: "bedroom"),
        Option(label: "Sân", value: "yard"),
        Option(label: "Lồng nuôi", value: "cage"),
        Option(label: "Chuồng ngoài trời", value: "outdoor_pen")
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
                        icon: "pawprint.fill",
                        label: "Tên thú cưng",
                        placeholder: "Nhập tên thú cưng",
                        text: $viewModel.name,
                        keyboardType: .default,
                        isValid: !viewModel.name.isEmpty
                    )
                    
                    // Species dropdown
                    CustomDropdown(
                        icon: "hare.fill",
                        label: "Loài",
                        value: $viewModel.species,
                        options: species,
                        primaryColor: primaryColor
                    )
                    .zIndex(5)
                    
                    // Breed field
                    CustomTextField(
                        icon: "peacesign",
                        label: "Giống",
                        placeholder: "Nhập giống thú cưng",
                        text: $viewModel.breed,
                        keyboardType: .default
                    )
                    
                    // Gender dropdown
                    CustomDropdown(
                        icon: "person.fill",
                        label: "Giới tính",
                        value: $viewModel.gender,
                        options: genders,
                        primaryColor: primaryColor
                    )
                    .zIndex(4)
                    
                    // Location dropdown
                    CustomDropdown(
                        icon: "mappin.and.ellipse",
                        label: "Vị trí",
                        value: $viewModel.location,
                        options: locations,
                        primaryColor: primaryColor
                    )
                    .zIndex(3)
                    
                    // Date pickers
                    VStack(spacing: 20) {
                        SectionHeader(title: "Thông tin thời gian", icon: "calendar")
                        
                        HStack(spacing: 16) {
                            // Birth date
                            CustomDatePicker(label: "Ngày sinh", date: Binding<Date?>(
                                get: { viewModel.birthDate },
                                set: { viewModel.birthDate = $0! }
                            ))
                            
                            // Last vet visit
                            CustomDatePicker(label: "Lần khám gần nhất", date: Binding<Date?>(
                                get: { viewModel.lastVetVisit },
                                set: { viewModel.lastVetVisit = $0! }
                            ))
                        }
                        
                        HStack(spacing: 16) {
                            // Last vaccination date
                            CustomDatePicker(label: "Lần tiêm chủng gần nhất", date: Binding<Date?>(
                                get: { viewModel.lastVaccinationDate },
                                set: { viewModel.lastVaccinationDate = $0! }
                            ))
                            
                            // Next vaccination date
                            CustomDatePicker(label: "Lần tiêm chủng tiếp theo", date: Binding<Date?>(
                                get: { viewModel.nextVaccinationDate },
                                set: { viewModel.nextVaccinationDate = $0! }
                            ))
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Additional details section
                    SectionHeader(title: "Thông tin chi tiết", icon: "doc.text.fill")
                    
                    // Weight
                    CustomTextField(
                        icon: "scalemass.fill",
                        label: "Cân nặng (kg)",
                        placeholder: "Nhập cân nặng",
                        text: $viewModel.weight,
                        keyboardType: .decimalPad
                    )
                    
                    // Food preferences
                    CustomTextField(
                        icon: "fork.knife",
                        label: "Thức ăn ưa thích",
                        placeholder: "Nhập loại thức ăn",
                        text: $viewModel.foodPreferences,
                        keyboardType: .default
                    )
                    
                    // Medical conditions
                    CustomTextField(
                        icon: "cross.case.fill",
                        label: "Tình trạng sức khỏe",
                        placeholder: "Nhập tình trạng sức khỏe (nếu có)",
                        text: $viewModel.medicalConditions,
                        keyboardType: .default
                    )
                    
                    // Medications
                    CustomTextField(
                        icon: "pills.fill",
                        label: "Thuốc đang dùng",
                        placeholder: "Nhập thuốc đang dùng (nếu có)",
                        text: $viewModel.medications,
                        keyboardType: .default
                    )
                    
                    // Save button with gradient and animation
                    Button(action: {
                        withAnimation {
                            viewModel.savePet()
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
                                    
                                    Text("Lưu thú cưng")
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
        .navigationTitle("Thêm thú cưng")
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
//        .alert(isPresented: .init(
//            get: { viewModel.errorMessage != nil },
//            set: { if !$0 { viewModel.errorMessage = nil } }
//        )) {
//            Alert(
//                title: Text("Lỗi"),
//                message: Text(viewModel.errorMessage ?? "Đã xảy ra lỗi không xác định"),
//                dismissButton: .default(Text("OK"))
//            )
//        }
        .onChange(of: viewModel.isSuccess) { success in
            if success {
                dismiss()
            }
        }
    }
}

