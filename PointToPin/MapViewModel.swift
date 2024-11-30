import MapKit
import SwiftUI
import Combine

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.1699, longitude: 24.9384),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
 
    @Published var annotations: [Location] = []
    private var subscriptions = Set<AnyCancellable>()
    private var locationDataManager: LocationDataManager
    
    init(locationDataManager: LocationDataManager = LocationDataManager()) {
        self.locationDataManager = locationDataManager
        observeAuthorizationChange()
    }
    
    private func observeAuthorizationChange() {
        locationDataManager.$authorizationStatus
            .sink { [weak self] status in
                guard let self = self else { return }
                if status == .authorizedWhenInUse, let location = self.locationDataManager.locationManager.location {
                    self.region.center = location.coordinate
                }
            }
            .store(in: &subscriptions)
    }
    
    func addCurrentLocation() {
        guard let coordinate = locationDataManager.locationManager.location?.coordinate else { return }
        let newLocation = Location(name: "Unnamed", coordinate: coordinate)
        annotations.append(newLocation)
        saveLocations()
    }
    
    func saveLocations() {
        let encoded = try? JSONEncoder().encode(annotations)
        UserDefaults.standard.set(encoded, forKey: "SavedLocations")
    }
    
    func loadLocations() {
        if let data = UserDefaults.standard.data(forKey: "SavedLocations"),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            annotations = decoded
        }
    }
    
    func resetLocations() {
        annotations.removeAll()
        saveLocations()
    }
}
