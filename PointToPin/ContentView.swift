import SwiftUI

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                Text("Your current location is:").boldLabel(color: .red)
                Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                
            case .restricted, .denied:
                Text("Current location data was restricted or denied.")
                Button("Open Permission Settings") {
                    openAppSettings()
                }
                .buttonStyle(BlueButton())
            case .notDetermined:
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
        }
        .padding()
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    ContentView()
}
