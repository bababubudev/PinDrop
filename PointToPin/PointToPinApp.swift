import SwiftUI

@main
struct PointToPinApp: App {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some Scene {
        WindowGroup {
            LaunchView(viewModel: viewModel)
        }
    }
}
