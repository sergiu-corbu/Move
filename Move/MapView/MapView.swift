//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @ObservedObject var mapViewModel: MapViewModel = MapViewModel()
    @ObservedObject var scooterViewModel: ScooterViewModel = ScooterViewModel()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var isUnlocked = false
    public func centerViewOnUserLocation() {
        guard let location = mapViewModel.locationManager.location?.coordinate else { print("errorr"); return }
            region = MKCoordinateRegion(center: location, latitudinalMeters: 900, longitudinalMeters: 900)
            scooterViewModel.location = location
    }
    
    let onMenu: () -> Void
	let onNFC: () -> Void
	let pinUnlock: () -> Void
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.showLocation, annotationItems: scooterViewModel.allScooters) { scooter in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0]))
                {
                    Image("pin-fill-img")
                        .onTapGesture {
                            self.mapViewModel.selectScooter(scooter: scooter)
                        }
                }
            }
			.edgesIgnoringSafeArea(.all)
            .onTapGesture { mapViewModel.selectedScooter = nil }
			.onAppear{
                if mapViewModel.showLocation {
                    centerViewOnUserLocation()
                    DispatchQueue.main.async {
                        centerViewOnUserLocation()
                    }
                }
            }
            if let selectedScooter = self.mapViewModel.selectedScooter {
                ZStack(alignment: .bottom) {
                    ScooterViewItem(scooter: selectedScooter, isUnlocked: $isUnlocked)
                        .padding([.leading, .trailing], 15)
						.animation(.easeIn(duration: 15))
                    if isUnlocked {
						UnlockScooterCard(onQR: {}, onPin: {pinUnlock()}, onNFC: {onNFC()}, scooter: selectedScooter)
                    }
                }
            }
            VStack {
				SharedElements.MapBarItems(menuAction: {onMenu()}, text: mapViewModel.cityName, locationEnabled: mapViewModel.showLocation, centerLocation: { centerViewOnUserLocation(); mapViewModel.selectedScooter = nil })
                Spacer()
            }
        }
    }
    
}

extension MKCoordinateRegion {
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
    }
}
