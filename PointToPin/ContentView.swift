import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: viewModel.annotations
            ) {
                place in MapPin(coordinate: place.coordinate, tint: .red)
            }.ignoresSafeArea()
        }
        .padding()
        
        HStack {
            Button("Add Location") {
                viewModel.addCurrentLocation()
            }.buttonStyle(BlueButton())
            
            Button("Reset Pins") {
                viewModel.resetLocations()
            }.buttonStyle(RedButton())
        }
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
