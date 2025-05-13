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
    let icon: String
    let label: String
    @Binding var value: String
    let options: [Option]
    var primaryColor: Color
    
    @State private var isExpanded = false
    private let backgroundColor = Color(hex: "#2A2A2A")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(primaryColor)
                
                Text(label)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.9))
                
                Spacer()
                
                Image(systemName: value.isEmpty ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(value.isEmpty ? Color(hex: "#E74C3C") : Color(hex: "#2ECC71"))
            }
            
            // Dropdown button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(options.first(where: { $0.value == value })?.label ?? options.first?.label ?? "")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(value.isEmpty ? Color(hex: "#777777") : Color.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.gray)
                        .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(value.isEmpty ? Color(hex: "#E74C3C").opacity(0.5) : Color.clear, lineWidth: value.isEmpty ? 1.5 : 0)
                )
            }
            
            // Dropdown options
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options.filter { $0.value != "" }, id: \.value) { option in
                        Button(action: {
                            value = option.value
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option.label)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if value == option.value {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14))
                                        .foregroundColor(primaryColor)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(value == option.value ? primaryColor.opacity(0.2) : Color.clear)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if option.value != options.last?.value {
                            Divider()
                                .background(Color(hex: "#333333"))
                                .padding(.horizontal, 12)
                        }
                    }
                }
                .background(Color(hex: "#1E1E1E"))
                .cornerRadius(12)
                .transition(.opacity)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.top, 4)
            }
        }
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


