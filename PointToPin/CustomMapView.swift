import SwiftUI
import MapKit

class ColoredAnnotation: MKPointAnnotation {
    let color: Color
    
    init(coordinate: CLLocationCoordinate2D, title: String, color: Color) {
        self.color = color
        super.init()
        self.coordinate = coordinate
        self.title = title
    }
}

struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [Location]
    
    var onMapTap: (CLLocationCoordinate2D) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        mapView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        
        let mapAnnotations = annotations.map { location -> MKPointAnnotation in
            let annotation = ColoredAnnotation (
                coordinate: location.coordinate,
                title: location.name,
                color: location.color
            )
            
            return annotation
        }
        
        uiView.addAnnotations(mapAnnotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
            
            guard let coloredAnnotation = annotation as? ColoredAnnotation else { return nil }
            
            let identifier = "ColoredPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: coloredAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = coloredAnnotation
            }
            
            if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
                let uiColor = UIColor(coloredAnnotation.color)
                markerAnnotationView.markerTintColor = uiColor
            }
            
            return annotationView
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            parent.onMapTap(coordinate)
        }
    }
}
