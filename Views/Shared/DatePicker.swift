//
//  DatePicker.swift
//  Nestify
//
//  Created by pham kha dinh on 6/5/25.
//

import SwiftUI

struct CustomDatePicker: View {
    let label: String
    @Binding var date: Date
    var iconColor: Color = .red
    var iconBgColor: Color = Color.red.opacity(0.2)
    var isRequired: Bool = false
    
    @State private var showingDatePicker = false
    @State private var tempDate: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.darkGray))
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
            }
            
            Button(action: {
                tempDate = date
                showingDatePicker = true
            }) {
                HStack {
                    Text(dateFormatter.string(from: date))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(iconBgColor)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "calendar")
                            .foregroundColor(Color.white)
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(Colors.iconBgColor)
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(
                selectedDate: $date,
                tempDate: $tempDate,
                isPresented: $showingDatePicker,
                accentColor: iconColor
            )
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var tempDate: Date
    @Binding var isPresented: Bool
    var accentColor: Color
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Chọn ngày",
                    selection: $tempDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .accentColor(accentColor)
                .labelsHidden()
                
                Spacer()
            }
            .navigationBarTitle("Chọn ngày", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Hủy") {
                    isPresented = false
                },
                trailing: Button("Xác nhận") {
                    selectedDate = tempDate
                    isPresented = false
                }
                .foregroundColor(accentColor)
            )
        }
    }
}
extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
