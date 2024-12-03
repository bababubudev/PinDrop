import MapKit
import Combine
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.1699, longitude: 24.9384),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
 
    @Published var locationPermissionStatus: CLAuthorizationStatus = .notDetermined
    @Published var annotations: [Location] = []
    @Published var isLoading = true
    
    private var subscriptions = Set<AnyCancellable>()
    private let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        setupLocationManager()
        loadLocationsWithDelay()
    }
    
    private func loadLocationsWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.loadLocations()
            self?.isLoading = false
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.publisher(for: \.location)
            .compactMap { $0 }
            .sink { [ weak self ] location in
                guard let self = self else { return }
                self.region.center = location.coordinate
            }
            .store(in: &subscriptions)
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addCurrentLocation(name: String, color: Color) {
        guard let location = locationManager.location else {
            print("Current location not available")
            return
        }
        
        let coordinate = location.coordinate
        addLocation(name: name, at: coordinate, color: color)
    }
    
    func addLocation(name: String, at coord: CLLocationCoordinate2D, color: Color) {
        let locationName = name.isEmpty ? "Unnamed" : name
        let newLocation = Location(name: locationName, coordinate: coord, color: color)
        annotations.append(newLocation)
        saveLocations()
    }
    
    func deleteLocation(_ location: Location) {
        annotations.removeAll { $0.id == location.id }
        saveLocations()
    }
    
    func saveLocations() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(annotations)
            UserDefaults.standard.set(data, forKey: "SavedLocations")
            print("Location Saved!")
        } catch {
            print("Error saving location: \(error)")
        }
    }
    
    func loadLocations() {
        guard let data = UserDefaults.standard.data(forKey: "SavedLocations") else { return }
        
        do {
            let decoder = JSONDecoder()
            annotations = try decoder.decode([Location].self, from: data)
        } catch {
            print("Error loading locations: \(error)")
        }
    }
    
    func resetLocations() {
        annotations.removeAll()
        saveLocations()
    }
    
    func centerOnCurrentLocation() {
        guard let location = locationManager.location else {
            region.center = .init(latitude: 61.4971, longitude: 23.7526)
            region.span = .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            return
        }
        
        region.center = location.coordinate
    }
  
    func centerOnLocation(_ location: Location) {
        region.center = location.coordinate
        print("Centered!")
    }
    
}
