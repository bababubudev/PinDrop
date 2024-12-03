import SwiftUI
import MapKit

struct CustomButton: ButtonStyle {
    var color: Color
    var background: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 20)
            .padding([.vertical], 10)
            .background(background)
            .foregroundStyle(color)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomSearchField: View {
    @Binding var text: String
    @Binding var isSearchActive: Bool
    @FocusState var isFocus: Bool

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isSearchActive.toggle()
                    isFocus = isSearchActive
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isSearchActive ? .gray : .accent)
            }
            
            if isSearchActive {
                TextField("Search...", text: $text)
                    .transition(.move(edge: .leading))
                    .focused($isFocus)
            }
        
        }
        .background(
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .padding(.leading, 28)
            }
        )
        .padding(.horizontal, 16)
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
    func boldLabel(color: Color = .white, fontSize: CGFloat = 16) -> some View {
        self.modifier(BoldLabel(color: color, fontSize: fontSize))
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationPermissionStatus = .authorizedWhenInUse
            manager.startUpdatingLocation()
        case .denied, .restricted:
            locationPermissionStatus = .denied
        case .notDetermined:
            locationPermissionStatus = .notDetermined
        @unknown default:
            locationPermissionStatus = .notDetermined
        }
    }
}

extension Color {
    func toHex() -> String {
        guard let components = cgColor?.components else { return "#FF0000" }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    init?(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        guard hex.count == 6, let rgb = Int(hex, radix: 16) else { return nil }
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}

#Preview {
    ContentView()
}
