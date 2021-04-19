//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import Foundation
import MapKit
import UIKit
import SwiftUI
import Combine
import NavigationStack

struct MapViewNavigation: View {
    
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            MapView(onMenuButton: {
                navigationViewModel.push(MenuView())
            })
        }
    }
}

var locationManager = CLLocationManager()


struct MapView: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    private static let defaultCoordinate = CLLocationCoordinate2D(latitude: 46.770, longitude: 23.591423)
    @State private var coordinateRegion = MKCoordinateRegion(center: defaultCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.0095, longitudeDelta: 0.0054))
   
    
    let onMenuButton: () -> Void
    
    var body: some View {
        
        ZStack(alignment: .top) {
            map
            navigationBarItems
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var map: some View {
        Map(coordinateRegion: $coordinateRegion)
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
                
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(.white)
                    Image("location-img")
                }.frame(width: 36, height: 36)
            })
        }
        .padding(.top, 65)
        .padding([.leading, .trailing], 24)
    }
}

extension Map {
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
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
