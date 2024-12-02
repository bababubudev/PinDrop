import SwiftUI

struct PermissionView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Location Access")
                .font(.title)
                .padding()
            
            Text("This app needs access to your location to provide map features and pin your current location.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                viewModel.requestLocationPermission()
            }) {
                Text("Enable Location")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
    }
}

struct PermissionDeniedView: View {
    var body: some View {
        VStack {
            Image(systemName: "location.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
            
            Text("Location Access Denied")
                .font(.title)
                .padding()
            
            Text("Please enable location access in Settings to use all features of this app.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }) {
                Text("Open Settings")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
    }
}
