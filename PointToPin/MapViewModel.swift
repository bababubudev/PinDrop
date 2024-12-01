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
    private let locationManager: CLLocationManager
    
    init() {
        self.locationManager = CLLocationManager()
        
        setupLocationManager()
        loadLocations()
    }
    
    private func setupLocationManager() {
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
    
    func addCurrentLocation() {
        guard let location = locationManager.location else {
            print("Current location not available")
            return
        }
        
        let coordinate = location.coordinate
        let latFormatted = Int(floor(coordinate.latitude))
        let longFormatted = Int(floor(coordinate.longitude))
        
        addLocation(name: "@\(latFormatted), @\(longFormatted)", at: coordinate)
    
    }
    
    func addLocation(name: String, at coord: CLLocationCoordinate2D) {
        print("Adding location: \(name) at \(coord.latitude), \(coord.longitude)")
        let locationName = name.isEmpty ? "Unnamed" : name
        let newLocation = Location(name: locationName, coordinate: coord)
        annotations.append(newLocation)
        print("Annotations count after adding: \(annotations.count)")
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
}
