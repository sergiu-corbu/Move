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

struct MapView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion()
    @State private var cancellable: AnyCancellable?
    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            //region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(latitude: 46.770, longitude: 23.59), span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7))
        }
    }
    
    var body: some View {
        NavigationView {
        GeometryReader { geometry in
            VStack {
                if locationManager.location != nil {
                    Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
                } else {
                    Text("")
                }
               // Map()
            }
            .edgesIgnoringSafeArea(.all)
            .overlay(
                HStack {
                    Button(action: {
                        
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
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .foregroundColor(.white)
                            Image("location-img")
                        }.frame(width: 36, height: 36)
                    })
                }
                .padding(.top, 65)
                .padding([.leading, .trailing], 20)
                .padding(.bottom, geometry.size.height)
            )
        }
        .navigationBarHidden(true)
        }
    }
}
/*
struct Map: UIViewRepresentable {
    
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.112, longitude: 49.840)
        let map = MKMapView()
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        view.addSubview(map)
        map.mapType = .standard
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.widthAnchor.constraint(equalTo: view.widthAnchor),
            map.heightAnchor.constraint(equalTo: view.heightAnchor),
            map.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            map.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
*/
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        // ForEach(["iPhone SE (2nd generation)", "iPhone 11"], id: \.self) { deviceName in
        MapView()
            //     .previewDevice(PreviewDevice(rawValue: deviceName))
            //     .previewDisplayName(deviceName)
            //  }
            .preferredColorScheme(.dark)
    }
}
