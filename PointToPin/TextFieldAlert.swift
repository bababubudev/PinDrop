import SwiftUI

struct TextFieldAlert: View {
    let title: String
    let placeholder: String
    let onSubmit: (String, Color) -> Void
    
    @State private var inputText: String = ""
    @State private var selectedColor: Color = .red
    
    @Environment(\.dismiss) private var dismiss
    
    private let colors: [Color] = [
        Color(uiColor: .red),
        Color(uiColor: .blue),
        Color(uiColor: .green),
        Color(uiColor: .orange),
        Color(uiColor: .purple),
        Color(uiColor: .yellow),
        Color(uiColor: .black),
        Color(uiColor: .brown)
    ]
    
    private func getTextColor(for color: Color) -> Color {
        let uiColor = UIColor(color)
        let ciColor = CIColor(color: uiColor)
        
        let brightness = (0.299 * Double(ciColor.red) + 0.587 * Double(ciColor.green) + 0.114 * Double(ciColor.blue))

        return brightness < 0.5 ? .white : .black
    }
    
    var body: some View {
        VStack() {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leadingFirstTextBaseline)
                .foregroundStyle(.gray)
                .opacity(0.6)
            
            TextField(placeholder, text: $inputText)
                .font(Font.system(size: 25))
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
                .padding(.bottom)
            
            Text("Choose the color for pin")
                .frame(maxWidth: .infinity, alignment: .leadingFirstTextBaseline)
                .foregroundStyle(.gray)
                .opacity(0.6)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ColorPicker("", selection: $selectedColor)
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                    
                    Divider().frame(height: 20)
                    
                    ForEach (colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .shadow(radius: 1)
                            .overlay(
                                Circle().stroke(
                                    selectedColor == color ?
                                        Color.black :
                                        Color.clear,
                                    lineWidth: 2
                                )
                            ).onTapGesture {
                                withAnimation {
                                    selectedColor = color
                                }
                            }
                            .padding(5)
                    }
                }
            }
            .padding(.bottom)
            Button(action: {
                withAnimation {
                    onSubmit(inputText, selectedColor)
                }
            }) {
                Label("Add pin", systemImage: "pin.fill")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .font(.headline)
                    .background(selectedColor)
                    .foregroundColor(getTextColor(for: selectedColor))
                    .cornerRadius(10)
                    .transition(.opacity)

            }
            .disabled(inputText.isEmpty)
        }.padding()
    }
}

#Preview {
    TextFieldAlert(
        title: "Write the name for pin",
        placeholder: "eg. Burger joint",
        onSubmit: { name, color in
            print("Name: \(name), Color: \(color)")
            
        }
    )
}
