import SwiftUI

struct TextFieldAlert: View {
    let title: String
    let placeholder: String
    let onSubmit: (String) -> Void
    
    @State private var inputText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack() {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leadingFirstTextBaseline)
                .font(.headline)
                .foregroundStyle(.gray)
            
            TextField(placeholder, text: $inputText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
            
            HStack() {
                Spacer()
                Button("OK") {
                    onSubmit(inputText.trimmingCharacters(in: .whitespacesAndNewlines))
                    dismiss()
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding()
                
                Spacer(minLength: 28)
                Divider()
                Spacer(minLength: 25)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(.red)
                .padding()
                
                Spacer()
            }
            .font(.headline)
            .padding()
        }
        .padding()
    }
}
