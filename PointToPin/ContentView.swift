import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    @State private var isLocationsShowing = false
    @State private var isInputShowing = false
    @State private var isRemoveAlertShowing = false
    @State private var isCurrentLocationRequest = false
    @State private var pinName = ""
    
    var body: some View {
        ZStack {
            CustomMapView(
                region: $viewModel.region,
                annotations: $viewModel.annotations,
                onMapTap: { coordinate in
                    selectedCoordinate = coordinate
                    viewModel.region.center = coordinate
                    isInputShowing = true
                }
            )
            .ignoresSafeArea()
            .sheet(isPresented: $isInputShowing, onDismiss: {
                isCurrentLocationRequest = false
            }) {
                TextFieldAlert(
                    title: "Name your pin",
                    placeholder: "eg. friend's place",
                    onSubmit: { name in
                        let locationName = name.isEmpty ? "No name": name
                        
                        if isCurrentLocationRequest {
                            viewModel.addCurrentLocation(name: locationName)
                        }
                        else {
                            guard let coordinate = selectedCoordinate else {return}
                            viewModel.addLocation(name: locationName, at: coordinate)
                            isInputShowing = false
                        }
                        
                        pinName = ""
                    }
                )
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isLocationsShowing) {
                LocationListView(
                    annotations: $viewModel.annotations,
                    onSelectLocation: { location in
                        viewModel.centerOnLocation(location)
                        isLocationsShowing = false
                    }
                )
                .presentationDetents([.height(500)])
            }
        }
        .overlay(
            VStack {
                Spacer(minLength: 750)
                HStack {
                    Spacer()
                    
                    Menu {
                        Button (role: .destructive, action: {
                            viewModel.onRemoveAll()
                            isRemoveAlertShowing = true
                        }) {
                            Label("Remove all pins", systemImage: "trash")
                        }.disabled(viewModel.annotations.count == 0)
                        Button(action: {
                            isCurrentLocationRequest = true
                            isInputShowing = true
                        }) {
                            Label("Pin your location", systemImage: "location")
                        }
                        Button(action: {
                            isLocationsShowing = true
                        }) {
                            Label("Show all pins", systemImage: "ellipsis")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Material.ultraThick)
                                .frame(width: 45, height: 45)
                                .shadow(radius: 1)
                            
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.primary)
                        }.padding(Edge.Set(.trailing), 5)
                    }
                }
                Spacer(minLength: 10)
            }
        )
        .confirmationDialog(
            "You have a total of \(viewModel.annotations.count) pins?",
            isPresented: $isRemoveAlertShowing,
            titleVisibility: .visible
        ) {
            Button("Remove All", role: .destructive) {
                viewModel.resetLocations()
                isRemoveAlertShowing = false
            }
            Button("Cancel", role: .cancel) {
                isRemoveAlertShowing = false
            }
        }
    }
}

#Preview {
    ContentView()
}
