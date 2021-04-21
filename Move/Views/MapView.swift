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
                navigationViewModel.push(MenuView( onBack: {navigationViewModel.pop()}))
            })
        }
    }
}

struct MapView: View {
    
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    @ObservedObject var scooterViewModel: ScooterViewModel = ScooterViewModel()
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State private var scooterTap = false
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            DispatchQueue.main.async {
                guard let location = location else {
                    region = MKCoordinateRegion.defaultRegion
                    return
                }
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
                VStack { //maybe geometry?
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
                .frame(height: 130)
            HStack {
                Button(action: {
                    onMenuButton()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .foregroundColor(.white)
                        Image("menu-img")
                    }
                    .frame(width: 36, height: 36)
                    .shadow(radius: 7)
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
                    }
                    .frame(width: 36, height: 36)
                    .shadow(radius: 7)
                })
            }
            .padding(.top)
            .padding([.leading, .trailing], 24)
        }
        .edgesIgnoringSafeArea(.all)
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

