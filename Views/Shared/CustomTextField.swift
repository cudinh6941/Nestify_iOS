
import SwiftUI

struct CustomTextField: View {
    let icon: String
    let label: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    var isValid: Bool? = nil
    
    private let backgroundColor = Color(hex: "#2A2A2A")
    private let primaryColor = Color(hex: "#4A9FF5")
    private let validColor = Color(hex: "#2ECC71")
    private let invalidColor = Color(hex: "#E74C3C")
    
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
                
                if let isValid = isValid {
                    Spacer()
                    Image(systemName: isValid ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(isValid ? validColor : invalidColor)
                }
            }
            
            // Input field
            HStack(spacing: 10) {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(Color(hex: "#777777"))
                            .font(.system(size: 16, design: .rounded))
                    }
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isValid == nil ? Color.clear :
                        (isValid! ? validColor.opacity(0.5) : invalidColor.opacity(0.5)),
                        lineWidth: isValid == nil ? 0 : 1.5
                    )
            )
        }
    }
}
