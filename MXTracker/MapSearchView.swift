//
//  MapSearchView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/12/23.
//

import SwiftUI
import MapKit

//Map view that will allow the user to search for nearby stores
struct MapSearchView: View {
    @State private var position = MapCameraPosition.userLocation(fallback: MapCameraPosition.automatic)
    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?
    @State private var isSheetPresented: Bool = true
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var scene: MKLookAroundScene?
    private var locationManager = CLLocationManager()
    
    //Initialize the location manager to get the user's location
    init() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    //Main view that handles the logic for displaying the UI elements and the map
    var body: some View {
        
        //Display the map based on the current position
        Map(position: $position, selection: $selectedLocation) {
            
            //Iterate through the found search results
            ForEach(searchResults) { result in
                
                //Display the found search results as markers on the map with a map pin
                Marker(coordinate: result.location) {
                    Image(systemName: "mappin")
                }
                .tag(result)
            }
        }
        
        //Overlay to handle the look around preview feature offered in iOS 17
        .overlay(alignment: .bottom) {
           if selectedLocation != nil {
               LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
                   .frame(height: 150)
                   .clipShape(RoundedRectangle(cornerRadius: 12))
                   .safeAreaPadding(.bottom, 40)
                   .padding(.horizontal, 20)
           }
        }
        .ignoresSafeArea()
        
        //Show the sheet if there is no currently selected location
        .onChange(of: selectedLocation) {
            if let selectedLocation {
                Task {
                    scene = try? await fetchScene(for: selectedLocation.location)
                }
            }
            isSheetPresented = selectedLocation == nil
        }
        
        //If the search only returns 1 matching search result, update the selected location to that result
        .onChange(of: searchResults) {
            if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedLocation = firstResult
            }
        }
        
        //Display the MapSearchSheetView to show the found locations and allow the user to search for locations
        .sheet(isPresented: $isSheetPresented) {
            MapSearchSheetView(searchResults: $searchResults)
        }
    }
    
    //Fetch the scene for the lookaround preview
    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}

#Preview {
    MapSearchView()
}
