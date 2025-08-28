//
//  File.swift
//  AIPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import UIKit
import MapKit
import AppResources

@MainActor
protocol PlannerMapManagerDelegate: AnyObject {
//    func mapManagerDidSelectAnnotation(_ location: TravelLocation)
}

@MainActor
protocol PlannerMapManagerProtocol {
    func showLocations(_ location: [TravelLocation])
    func focusOn(_ location: TravelLocation)
    func clearAnnotations()
}

@MainActor
final class PlannerMapManager: NSObject {
    private weak var mapView: MKMapView?
    private weak var delegate: PlannerMapManagerDelegate?
    
    init(mapView: MKMapView, delegate: PlannerMapManagerDelegate) {
        self.mapView = mapView
        self.delegate = delegate
        super.init()
        mapView.delegate = self
    }
}

extension PlannerMapManager: PlannerMapManagerProtocol {
    func focusOn(_ location: AppResources.TravelLocation) {
        guard let mapView = mapView else { return }
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func clearAnnotations() {
        return
    }
    
    func showLocations(_ locations: [TravelLocation]) {
        guard let mapView = mapView else { return }
        mapView.removeAnnotations(mapView.annotations)
        
        var coordinates: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let annotation = CustomAnnotation(
                title: location.name,
                subtitle: location.description,
                coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                imageName: location.symbol
            )
            
            mapView.addAnnotation(annotation)
            coordinates.append(annotation.coordinate)
        }
        
        // Focus the map on the shown locations
        if !coordinates.isEmpty {
            var minLat = coordinates[0].latitude
            var maxLat = coordinates[0].latitude
            var minLon = coordinates[0].longitude
            var maxLon = coordinates[0].longitude
            
            for coord in coordinates {
                minLat = min(minLat, coord.latitude)
                maxLat = max(maxLat, coord.latitude)
                minLon = min(minLon, coord.longitude)
                maxLon = max(maxLon, coord.longitude)
            }
            
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5
            )
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension PlannerMapManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        
        let identifier = "CustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = customAnnotation
        }
        
        
        let customView = CustomPinView(icon: UIImage(systemName: customAnnotation.imageName))
        annotationView?.image = customView.asImage()
        
        
        return annotationView
    }
}
