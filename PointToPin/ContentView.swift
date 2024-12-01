import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    @State private var isLocationSheetShowing = false
    @State private var isInputShowing = false
    @State private var pinName = ""
    
    var body: some View {
        VStack {
            Text("Number of Annotations: \(viewModel.annotations.count)")

            CustomMapView(
                region: $viewModel.region,
                annotations: $viewModel.annotations,
                onMapTap: { coordinate in
                    selectedCoordinate = coordinate
                    isInputShowing = true
                }
            )
            .ignoresSafeArea()
            .sheet(isPresented: $isInputShowing) {
                TextFieldAlert(
                    title: "Name your pin",
                    placeholder: "eg. friend's place",
                    onSubmit: { name in
                        guard let coordinate = selectedCoordinate else {return}
                        let locationName = name.isEmpty ? "No name": name
                        viewModel.addLocation(name: locationName, at: coordinate)
                        isInputShowing = false
                        pinName = ""
                    }
                )
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
            }
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Button("Pin Current Location") {
                        viewModel.addCurrentLocation()
                    }
                    .buttonStyle(CustomButton(color: .white, background: .blue))
                    
                    Button("Reset All Pins") {
                        viewModel.resetLocations()
                    }
                    .buttonStyle(CustomButton(color: .white, background: .red))
                }
                .padding()
            }
        )
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func coordinateFromTap(location: CGPoint, mapRegion: MKCoordinateRegion) -> CLLocationCoordinate2D {
        let mapView = MKMapView()
        mapView.region = mapRegion
        return mapView.convert(location, toCoordinateFrom: mapView)
    }
}

#Preview {
    ContentView()
}
