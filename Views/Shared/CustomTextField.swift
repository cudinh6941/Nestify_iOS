
import SwiftUI

struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
            ZStack {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.horizontal, 10)
                }
                TextField("", text: $text)
                    .padding()
                    .background(Color(hex: "#2b2b2c"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        
    }
}
