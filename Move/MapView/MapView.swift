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
    
    let onMenuButton: () -> Void
    
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
            .edgesIgnoringSafeArea(.bottom)
            .onTapGesture {
                mapViewModel.selectedScooter = nil
            }
            .onAppear {
                if mapViewModel.showLocation {
                    centerViewOnUserLocation()
                    DispatchQueue.main.async {
                        centerViewOnUserLocation()
                    }
                }
            }
            .animation(.easeIn)
            if let selectedScooter = self.mapViewModel.selectedScooter {
                ZStack(alignment: .bottom) {
                    ScooterViewItem(scooter: selectedScooter, isUnlocked: $isUnlocked)
                        .padding([.leading, .trailing], 15)
                    if isUnlocked {
                        UnlockScooterCard(scooter: selectedScooter)
                            .cornerRadius(29, corners: [.topLeft, .topRight])
                            .background(Color.white.edgesIgnoringSafeArea(.bottom))
                    }
                }
            }
            VStack {
                navigationBarItems
                Spacer()
            }
        }
    }
    
    var navigationBarItems: some View {
        ZStack {
            Image("fademap-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
                .frame(height: 70)
            HStack {
                MapActionButton(image: "menu-img", action: { onMenuButton() })
                Spacer()
                Text(mapViewModel.cityName)
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.semiBold, size: 18))
                Spacer()
                MapActionButton(image: mapViewModel.showLocation ? "location-img" : "locationDenied", action: { centerViewOnUserLocation() })
            }
            .padding(.horizontal, 24)
        }
    }
}

extension MKCoordinateRegion {
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
    }
}
