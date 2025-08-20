//
//  CustomAnnotation.swift
//  TravelPlanner
//
//  Created by ali cihan on 3.08.2025.
//
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let imageName: String

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.imageName = imageName
    }
}
