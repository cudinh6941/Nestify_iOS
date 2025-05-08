import SwiftUI

struct Option: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: String
    
    static func == (lhs: Option, rhs: Option) -> Bool {
        return lhs.value == rhs.value
    }
}

struct CustomDropdown: View {
    let label: String
    @Binding var value: String
    let onValueChange: (String) -> Void
    let options: [Option]
    var placeholder: String = "Chọn một mục"
    var isInvalid: Bool = false
    var errorMessage: String = ""
    var isRequired: Bool = false
    
    @State private var isOpen: Bool = false
    @State private var animationAmount: Double = 0
    
    // Tách các view thành các component nhỏ hơn
    private var labelView: some View {
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
    }
    
    private var dropdownButtonView: some View {
        Button(action: {
            withAnimation(.spring()) {
                isOpen.toggle()
                animationAmount = isOpen ? 1 : 0
                
                // Ẩn bàn phím nếu đang hiển thị
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }) {
            HStack {
                Text(selectedLabel)
                    .foregroundColor(value.isEmpty ? Color.gray : Color.black)
                
                Spacer()
                
                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isInvalid ? Color.red : Color(UIColor.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Tách danh sách options thành một view riêng
    private var optionsListView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(options) { option in
                    OptionItemView(
                        option: option,
                        isSelected: option.value == value,
                        onSelect: {
                            value = option.value
                            onValueChange(option.value)
                            withAnimation(.spring()) {
                                isOpen = false
                                animationAmount = 0
                            }
                        }
                    )
                    
                    if option != options.last {
                        Divider()
                            .background(Color(UIColor.systemGray5))
                    }
                }
            }
        }
        .frame(maxHeight: 200)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .offset(y: 60)
        .opacity(animationAmount)
        .scaleEffect(y: animationAmount, anchor: .top)
    }
    
    private var errorView: some View {
        Group {
            if isInvalid && !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label
            labelView
            
            // Dropdown button and options
            ZStack(alignment: .top) {
                // Main button
                dropdownButtonView
                
                // Dropdown options
                if isOpen {
                    optionsListView
                }
            }
            .onTapGesture {}  // Chặn sự kiện tap để không đóng dropdown
            
            // Error message
            errorView
        }
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if isOpen {
                        withAnimation(.spring()) {
                            isOpen = false
                            animationAmount = 0
                        }
                    }
                }
        )
    }
    
    private var selectedLabel: String {
        if let selectedOption = options.first(where: { $0.value == value }) {
            return selectedOption.label
        }
        return placeholder
    }
}

// Tách thành component riêng cho từng mục trong dropdown
struct OptionItemView: View {
    let option: Option
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text(option.label)
                    .foregroundColor(.black)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .contentShape(Rectangle())
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


