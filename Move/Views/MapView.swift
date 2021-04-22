//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import MapKit
import SwiftUI
import Combine

struct MapView: View {
    
    @ObservedObject var scooterViewModel: ScooterViewModel = ScooterViewModel()
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State private var scooterTap = false
    var city: String {
        return locationManager.city ?? "unknown"
    }
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            DispatchQueue.main.async {
                guard let location = location else {
                    region = MKCoordinateRegion.defaultRegion
                    return
                }
                print(locationManager.city ?? "no location")
                scooterViewModel.location = location.coordinate
                region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

            }
        }
    }
    
    let onMenuButton: () -> Void
    
    var body: some View {
        if locationManager.location != nil {
            ZStack(alignment: .bottom) {
                
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: scooterViewModel.allScooters) { scooter in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0])) {
                        Image("pin-fill-img")
                            .onTapGesture {
                                scooterTap.toggle()
                            }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear { setCurrentLocation() }
                VStack {
                    navigationBarItems
                    Spacer()
                }
                if scooterTap {
                    ScooterRowView(scooters: scooterViewModel.allScooters)
                }
            }
        } else {
                Map(coordinateRegion: $region)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        navigationBarItems
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
                Text(city)
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.semiBold, size: 18))
                Spacer()
                MiniActionButton(image: "location-img", action: { })
            }
            
            .padding([.leading, .trailing], 24)
        }
    }
}

extension MKCoordinateRegion {
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770, longitude: 23.59142), span: MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6))
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone 12"], id: \.self) { deviceName in
            MapView(onMenuButton: {})
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.dark)
    }
}

/*
extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    var longitude: Double {
        return self.coordinate.longitude
    }
}

*/
