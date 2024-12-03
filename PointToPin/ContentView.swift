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
    @State private var searchText = ""
    
    @State private var searchResults: [MKMapItem] = []
    @State private var isShowingSearchResults = false

    @State private var searchFieldShowing: Bool = false
    
    private func searchLocations(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            isShowingSearchResults = false
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = viewModel.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                print("Error searching for locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            withAnimation {
                searchResults = response.mapItems
                isShowingSearchResults = true
            }
        }
    }
    
    private func centerMapOnLocation(_ mapItem: MKMapItem, delta: Double = 0.1) {
        viewModel.region.center = mapItem.placemark.coordinate
        viewModel.region.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
    }
    
    private func pinMapOnLocation (_ mapItem: MKMapItem) {
        withAnimation {
            searchFieldShowing = false
        }
        
        centerMapOnLocation(mapItem, delta: 0.025)
        searchText = ""
        searchResults = []
        
        viewModel.addLocation(name: mapItem.name ?? "Pinned location", at: mapItem.placemark.coordinate, color: Color.red)
    }
    
    
    var body: some View {
        ZStack {
            CustomMapView(
                region: $viewModel.region,
                annotations: $viewModel.annotations,
                onMapTap: { coordinate in
                    if searchFieldShowing {
                        withAnimation {
                            searchFieldShowing = false
                            searchText = ""
                        }
                        
                        searchResults = []
                        return
                    }
                    
                    selectedCoordinate = coordinate
                    viewModel.region.center = coordinate
                    isInputShowing = true
                }
            )
            .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    CustomSearchField(text: $searchText, isSearchActive: $searchFieldShowing)
                        .padding(.vertical, searchFieldShowing ? 10 : 15)
                        .background(searchFieldShowing ? Material.bar : Material.thick)
                        .onChange(of: searchText) {
                            searchLocations(query: searchText)
                        }
                        .cornerRadius(7)
                        .animation(.easeInOut(duration: 0.1), value: searchText.isEmpty)
                        .shadow(radius: 1)
                        
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            withAnimation {
                                searchText = ""
                                searchResults = []
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .foregroundStyle(.accent)
                                .frame(width: 25, height: 25)
                                .shadow(radius: 1)
                        }
                        .transition(.move(edge: .leading))
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 5)
                .padding(.top, 5)
                
                Spacer()
            }
            
            if !searchResults.isEmpty && isShowingSearchResults  {
                ScrollView {
                    LazyVStack {
                        ForEach(searchResults, id: \.self) { result in
                            VStack(alignment: .leading) {
                                Text(result.name ?? "Unknown Location")
                                    .font(.headline)
                                Text(result.placemark.title ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Material.bar)
                            .cornerRadius(5)
                            .onTapGesture {
                                centerMapOnLocation(result)
                                searchText = ""
                                searchResults = []
                                withAnimation {
                                    searchFieldShowing = false
                                }
                            }
                            
                            Button(action: {
                                pinMapOnLocation(result)
                            }) {
                                Label("Add pin", systemImage: "pin.fill")
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .font(.headline)
                                    .background(Material.regular)
                                    .foregroundColor(.red)
                                    .cornerRadius(5)
                                    .transition(.opacity)

                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.top, 70)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isInputShowing, onDismiss: {
            isCurrentLocationRequest = false
        }) {
            TextFieldAlert(
                title: "Write the name for pin",
                placeholder: "...",
                onSubmit: { name, color in
                    let locationName = name.isEmpty ? "No name": name
                    
                    if isCurrentLocationRequest {
                        viewModel.addCurrentLocation(name: locationName, color: color)
                    }
                    else {
                        guard let coordinate = selectedCoordinate else {return}
                        viewModel.addLocation(name: locationName, at: coordinate, color: color)
                    }
                    
                    pinName = ""
                    isInputShowing = false
                }
            )
            .presentationDetents([.height(300)])
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
        .overlay(
            // Menu buttons
            VStack {
                Spacer(minLength: 750)
                HStack {
                    Spacer()
                    
                    Menu {
                        Button (role: .destructive, action: {
                            viewModel.centerOnCurrentLocation()
                            isRemoveAlertShowing = true
                        }) {
                            Label("Remove all pins", systemImage: "trash")
                        }.disabled(viewModel.annotations.count == 0)
                        Button(action: {
                            viewModel.centerOnCurrentLocation()
                            isCurrentLocationRequest = true
                            isInputShowing = true
                        }) {
                            Label("Pin your location", systemImage: "location")
                        }
                        Button(action: {
                            isLocationsShowing = true
                            viewModel.centerOnCurrentLocation()
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
