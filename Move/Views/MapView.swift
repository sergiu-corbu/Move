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
    
   // @State var _result: Result<[Scooter]> =
    
    
    //MKCoordinateSpan(latitudeDelta: 0.0095, longitudeDelta: 0.0054))
   
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    let onMenuButton: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            if locationManager.location != nil {
              /*  Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: Result) { scooter in
                    //
                }*/
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        setCurrentLocation()
                    }
            }
            navigationBarItems
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
            Button(action: {
                API.getScooters { result in
                    switch result {
                        case .success:
                            scooterViewModel.allScooters = result
                      //  _result = result
                            print(result)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            }, label: {
                Text("get scooters")
            })
            Text("Cluj Napoca")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.semiBold, size: 18))
            Spacer()
            Button(action: {
                
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(.white)
                    Image("location-img")
                }.frame(width: 36, height: 36)
            })
        }
        .padding([.leading, .trailing], 24)
    }
}

extension MKCoordinateRegion {
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770, longitude: 23.591423), latitudinalMeters: 100, longitudinalMeters: 100)
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

