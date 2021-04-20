//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import MapKit
import SwiftUI
import NavigationStack
import Combine

struct MapViewNavigation: View {
    
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            MapView( onMenuButton: {
                navigationViewModel.push(MenuView())
            })
        }
    }
}

struct MapView: View {
    
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @ObservedObject var scooterViewModel: ScooterViewModel = ScooterViewModel()
    @State private var showScooterInfo: Bool = false
    //MKCoordinateSpan(latitudeDelta: 0.0095, longitudeDelta: 0.0054))
    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            guard let location = location else {
                region = MKCoordinateRegion.defaultRegion
                return
            }
            scooterViewModel.location = location.coordinate
            region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    
    let onMenuButton: () -> Void
    
    var body: some View {
        if locationManager.location != nil {
            ZStack(alignment: .top) {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: scooterViewModel.allScooters) { scooter in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0])) {
                        Image("pin-fill-img")
                            .onTapGesture {
                                showScooterInfo = true
                            }
                            .overlay(
                                ScooterViewItem(scooter: scooter)
                            )
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear { setCurrentLocation() }
                navigationBarItems
            }
        }
    }
    
    var navigationBarItems: some View {
        HStack {
            Button(action: {
                onMenuButton()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(.white)
                    Image("menu-img")
                }.frame(width: 36, height: 36)
                .shadow(radius: 17)
            })
            Spacer()
            Text("Cluj Napoca")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.semiBold, size: 18))
            Spacer()
            Button(action: {
                //track location
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(.white)
                    Image("location-img")
                }.frame(width: 36, height: 36)
            })
        }
        .padding(.top)
        .padding([.leading, .trailing], 24)
    }
}

extension MKCoordinateRegion {
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770, longitude: 23.591423), latitudinalMeters: 200, longitudinalMeters: 200)
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

