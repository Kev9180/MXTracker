//
//  LocationService.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/12/23.
//

import MapKit

//Struct to hold the information for each search result
struct LocationInformation: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    var url: URL?
}

//Struct to hold the result of the search
struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D
    let name: String
    let address: String

    //Check if two search results are the same to avoid displaying duplicate search results
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    //Generate a hash value for each search result based off its id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//Observable oject class that will handle the user searches
@Observable class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    
    //Array to hold the places returned from the search
    var completions = [LocationInformation]()
    
    //Initialize function
    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }
    
    //Function that will update the search query
    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }
    
    //Function that will be called when completer updates its results
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

            return .init(
                title: completion.title,
                subTitle: completion.subtitle,
                url: mapItem?.url
            )
        }
    }
    
    //Function that will perform a search given a search value and a coordinate (optional)
    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .pointOfInterest
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)

        let response = try await search.start()

        return response.mapItems.compactMap { mapItem in
            guard let location = mapItem.placemark.location?.coordinate else { return nil }
            let name = mapItem.name ?? "Unknown" // You can adjust the default values
            let address = mapItem.placemark.title ?? "No Address"
            
            return SearchResult(location: location, name: name, address: address)
        }
    }
}
