//
//  MapSearchSheetView.swift
//  MXTracker
//
//  Created by Kevin Johnston on 11/12/23.
//

import SwiftUI
import MapKit

//MapSearchSheetView is the sheet that displays over the map when the user performs a search
struct MapSearchSheetView: View {
    @State private var locationService = LocationService(completer: .init())
    @State private var search: String = ""
    @Binding var searchResults: [SearchResult]

    //Main view responsisible for the logic and display of the UI elements
    var body: some View {
        VStack {
            
            //HStack to hold the search bar
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Automotive Parts Stores", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            searchResults = (try? await locationService.search(with: search)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())

            Spacer()
            
            //List that will return the matching results for the users search term
            List {
                
                //Iterate through the list of matching results and display them
                ForEach(locationService.completions) { completion in
                    Button(action: { }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            
                            Text(completion.subTitle)
                            
                            if let url = completion.url {
                                Link(url.absoluteString, destination: url)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        //When the user enters a different search term, update the results
        .onChange(of: search) {
            locationService.update(queryFragment: search)
        }
        .padding()
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
    
    private func didTapOnCompletion(_ completion: LocationInformation) {
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)").first {
                searchResults = [singleLocation]
            }
        }
    }
}

//Struct modifier for the search bar
struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}
