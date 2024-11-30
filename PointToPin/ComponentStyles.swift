import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 20)
            .padding([.vertical], 10)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 20)
            .padding([.vertical], 10)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RoundedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct BoldLabel: ViewModifier {
    var color: Color
    var fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold)).foregroundColor(color).padding(5)
    }
}

extension View {
    func roundedTextField() -> some View {
        self.modifier(RoundedTextField())
    }
    
    func boldLabel(color: Color = .white, fontSize: CGFloat = 16) -> some View {
        self.modifier(BoldLabel(color: color, fontSize: fontSize))
    }
}
