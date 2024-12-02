import SwiftUI

struct LaunchView: View {
    @StateObject private var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            switch viewModel.locationPermissionStatus {
            case .notDetermined:
                PermissionView(viewModel: viewModel)
            case .denied, .restricted:
                PermissionDeniedView()
            case .authorizedWhenInUse, .authorizedAlways:
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                        Text("Loading Map").padding()
                        Spacer()
                    }
                    .background(Color(UIColor.systemBackground))
                    .edgesIgnoringSafeArea(.all)
                } else {
                    ContentView()
                }
            @unknown default:
                PermissionDeniedView()
            }
        }
    }
}
