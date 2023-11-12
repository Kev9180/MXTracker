//
//  MapView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/20/23.
//

//**TODO** Need to fix the map functionality, currently unable to drag the map to different areas. Getting warnings that I can't modify a state variable while inside a view

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @ObservedObject var locationDataManager : LocationDataManager
    
    //Default region location is set to Tempe, AZ
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.425504, longitude: -111.938474),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    //Define and initialize an empty array that will be used to hold nearby automotive parts stores
    @State private var markers: [Location] = []
    
    //Define and initialize a userLocation variable that will track the users current location
    @State private var userLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @State private var nearbyStores: [MKMapItem] = []

    //Main view that handles the logic for MapView
    var body: some View {
        VStack {
            
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  //When the user has allowed location services
                
                //*****TODO****** Need to figure out how to make this map conform to iOS 17 requirements
                
                //Show a map based off of the users current location
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: markers) { store in
                    MapAnnotation(coordinate: store.coordinate){
                        Text(store.name)
                            .font(.callout)
                            .padding(5)
                            .background(Color(.white))
                            .cornerRadius(10)
                        
                        Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                              
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: 0, y: -5)
                     }
                }
                //If the user's location changes, update the userLocation variable and the region
                .onChange(of: locationDataManager.locationManager.location) { previousLoc, currentLoc in
                    if let locationCoordinate = currentLoc?.coordinate {
                        DispatchQueue.main.async {
                            self.userLocation = locationCoordinate
                            self.region.center = locationCoordinate
                        }
                    }
                }
                
            case .restricted, .denied:  //Location services currently unavailable.
                Text("Current location data was restricted or denied.")
            case .notDetermined:        //Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.getNearbyPartsStores()
            }
        }
    }

    //Helper function to search for places in the current city
    func getNearbyPartsStores() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "auto parts store"
        searchRequest.region = region
        
        //Conduct the search
        MKLocalSearch(request: searchRequest).start { response, error in
            
            //If there is an error, print it
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            //Create a new array to hold the different locations
            var newMarkers: [Location] = []
            
            //Put a placemark on the map for each found location
            for item in response.mapItems {
                let marker = Location(
                    name: item.name ?? "",
                    coordinate: item.placemark.coordinate
                )
                newMarkers.append(marker)
            }
            
            //Add the newMarkers to the markers array
            self.markers = newMarkers
        }
    }
}


#Preview {
    MapView(locationDataManager: LocationDataManager())
}
