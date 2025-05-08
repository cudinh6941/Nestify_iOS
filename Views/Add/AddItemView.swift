
//
//  AddItemView.swift
//  Nestify
//
//  Created by pham kha dinh on 5/5/25.
//

// MARK: - Add Item View
import SwiftUI
struct AddItemView: View {
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory = ""
    @State private var selectedLocation = ""
    @State private var price: String = ""
    @State private var quantity: String = ""
     let categories: [Option] = [
        Option (label: "Chọn danh mục", value: "") ,
        Option(label: "Đồ điện tử", value: "electronic" ),
        Option(label: "Đồ nội thất", value: "furniture" ),
        Option( label: "Thiết bị nhà bếp", value: "kitchen"),
        Option(label: "Quần áo", value: "clothes"),
        Option( label: "Khác", value: "others" )
     ]
    let locations: [Option] = [
        Option (label: "Chọn danh mục", value: "") ,
        Option(label: "Phòng khách", value: "living_room" ),
        Option(label: "Phòng ngủ", value: "bedroom" ),
        Option( label: "Nhà bếp", value: "kitchen"),
        Option(label: "Phòng tắm", value: "bathroom"),
        Option( label: "Kho", value: "storage" ),
        Option(label: "sân", value: "yard")
    ]
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ImagePickerView()
                CustomTextField(label: "Nhập tên", placeholder: "enter name", text: $name, keyboardType: .default)
                CustomDropdown(label: "Danh mục", value: $selectedCategory, onValueChange: { newValue in
                    print(newValue)
                }, options: categories)
                .zIndex(4)
                CustomDropdown(label: "Vị trí", value: $selectedLocation, onValueChange: { newValue in
                    print(newValue)
                }, options: locations)
                .zIndex(3)
                HStack (spacing: 10) {
                    CustomDatePicker(label: "Ngày mua", date: $selectedDate)
                    CustomDatePicker(label: "Hết hạn bảo hành", date: $selectedDate)
                }
                CustomTextField(label: "Giá", placeholder: "Nhập giá", text: $price, keyboardType: .numberPad)
                CustomTextField(label: "Số lượng", placeholder: "Nhập số lượng", text: $quantity, keyboardType: .numberPad)

            }
            
        }
        .padding()
        .background(Color.black)
        .navigationTitle("Thêm vật dụng")
               .toolbar {
                   ToolbarItem(placement: .principal) {
                          Text("Thêm vật dụng")
                              .font(.headline)
                              .foregroundColor(.white)
                      }
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button(action: {
                           dismiss() // Trở về màn trước
                       }) {
                           HStack {
                               Image(systemName: "chevron.left")
                                   .foregroundColor(.white)
                               Text("Quay lại")
                                   .foregroundColor(.white)
                           }
                       }
                   }
               }
               .navigationBarTitleDisplayMode(.inline)
               .navigationBarBackButtonHidden()
    }
}





