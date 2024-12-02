import SwiftUI

struct LocationListView: View {
    @Binding var annotations: [Location]
    var onSelectLocation: (Location) -> Void
    
    private func formatDouble(val: Double) -> String {
        return String(format: "%.5f", val)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(annotations) { location in
                    Button(action: {
                        onSelectLocation(location)
                    }) {
                        HStack {
                            VStack(alignment: .leading){
                                Text(location.name).font(.headline)
                                VStack {
                                    Text("Latitude: \(formatDouble(val: location.coordinate.latitude))°")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Longitude: \(formatDouble(val: location.coordinate.longitude))°")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteLocation)
            }
            .navigationTitle("Stored Locations")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteLocation(at offsets: IndexSet) {
        annotations.remove(atOffsets: offsets)
    }
    
}
