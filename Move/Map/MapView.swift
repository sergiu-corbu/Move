//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 24.05.2021.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
	
	@Binding var centerCoordinate: CLLocationCoordinate2D
	var locations: [CLLocationCoordinate2D]
	
	func makeUIView(context: Context) -> some MKMapView {
		let mapView = MKMapView()
		let polyline = MKPolyline(coordinates: locations, count: locations.count)
		
//		let startAnnotation: MKPointAnnotation = MKPointAnnotation()
//		startAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations[0].latitude, longitude: locations[0].longitude)
//
//		let endAnnotation: MKPointAnnotation = MKPointAnnotation()
//		endAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations.last!.latitude, longitude: locations.last!.longitude)
		
		mapView.setRegion(MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 900, longitudinalMeters: 900), animated: false)
		mapView.delegate = context.coordinator
		mapView.addOverlay(polyline)
//		mapView.addAnnotations([startAnnotation, endAnnotation])
		return mapView
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapView
		
		init(_ parent: MapView) {
			self.parent = parent
		}
		
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			guard let polyline = overlay as? MKPolyline else {
				return MKOverlayRenderer()
			}
			let polylineRenderer = MKPolylineRenderer(overlay: polyline)
			polylineRenderer.strokeColor = UIColor(Color.coralRed)
			polylineRenderer.lineWidth = 3.5
			
			return polylineRenderer
		}
	}

	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}
