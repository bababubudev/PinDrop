import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id: UUID
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.coordinate = coordinate
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
