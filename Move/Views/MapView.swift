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
    @State private var scooterTap = false
    
    func centerViewOnUserLocation() {
        if let location = mapViewModel.locationManager.location?.coordinate {
            region = MKCoordinateRegion(center: location, latitudinalMeters: 900, longitudinalMeters: 900)
            scooterViewModel.location = location
        }
        /* guard let location = location else {
         region = MKCoordinateRegion.defaultRegion
         return
         }*/
    }
    
    let onMenuButton: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.showLocation, annotationItems: scooterViewModel.allScooters) { scooter in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0]))
                {
                    Image("pin-fill-img")
                        .onTapGesture { scooterTap.toggle() }
                }
            }
            .onAppear {
                if mapViewModel.showLocation {
                    DispatchQueue.main.async {
                        centerViewOnUserLocation()
                    }
                }
            }
            .animation(.easeIn)
            if scooterTap {
                ForEach(scooterViewModel.allScooters) { scooter in
                    VStack {
                        ScooterViewItem(scooter: scooter)
                            .padding([.leading, .trailing], 15)
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
                .frame(height: 80)
            HStack {
                MiniActionButton(image: "menu-img", action: { onMenuButton() })
                Spacer()
                Text(mapViewModel.cityName)
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.semiBold, size: 18))
                Spacer()
                MiniActionButton(image: "location-img", action: { centerViewOnUserLocation() })
            }
            .padding([.leading, .trailing], 24)
        }
    }
}

extension MKCoordinateRegion {
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
    }
}
